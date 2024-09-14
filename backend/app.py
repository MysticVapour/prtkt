import requests
from roboflow import Roboflow
import cv2
import threading
import os
import sqlite3
import time

# Initialize Roboflow model for video detection
rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)
project = rf.workspace().project("gn-detect")
model = project.version(2).model
print("Roboflow Initialized")

# SQLite connection to check DB logs for audio incidents
conn = sqlite3.connect('example.db', check_same_thread=False)
cursor = conn.cursor()

baseUrl = "http://127.0.0.1:8000"

# Shared variables to store the detection result
gunDetected = False
pred_box = None

# Function to process the image and check for pistol detection using Roboflow
def readImage(pathName: str):
    prediction = model.predict(pathName, confidence=40, overlap=30).json()
    os.remove(pathName)
    print(f"Deleted file: {pathName}")
    return prediction

# Function to send the POST request for video incidents
def send_video_incident_log(room: str):
    try:
        # POST request for video incident detection
        url = baseUrl + "/video-incident-log/"  # Change this to the correct URL if needed
        data = {
            "room_number": room,
            "event_time": time.strftime("%H:%M:%S"),  # Current time
            "incident_source": "video"  # Mark source as video
        }
        response = requests.post(url, json=data)
        print(f"Video incident log sent to server: {response.json()}")
    except Exception as e:
        print(f"Failed to send video log: {e}")

# Worker thread to handle image processing for pistol detection
def process_image(image_path, frame, room):
    global gunDetected, pred_box

    # Save the frame as an image file
    cv2.imwrite(image_path, frame)
    print(f"Image saved as {image_path}")

    # Process the image using the custom function
    prediction = readImage(image_path)

    # Check if any predictions are returned
    if prediction["predictions"]:
        for pred in prediction["predictions"]:
            if pred["class"] == "pistol":
                # If a gun is detected, set the global variable to True
                gunDetected = True

                # Calculate the bounding box coordinates
                x = pred["x"]
                y = pred["y"]
                width = pred["width"]
                height = pred["height"]

                top_left = (int(x - width / 2), int(y - height / 2))
                bottom_right = (int(x + width / 2), int(y + height / 2))

                # Store the bounding box for the main thread to draw
                pred_box = (top_left, bottom_right)
                print(f"Gun detected: Bounding box {top_left} to {bottom_right}")

                # Send the video incident log
                send_video_incident_log(room)

            else:
                gunDetected = False
                pred_box = None
    else:
        gunDetected = False
        pred_box = None

# Function to check DB logs for audio incidents reported via the frontend
def check_db_logs(room):
    cursor.execute("SELECT * FROM room_schedule WHERE room_number = ?", (room,))
    logs = cursor.fetchall()
    if logs:
        for log in logs:
            print(f"Audio incident detected in room {room}")
            send_audio_incident_log(room)
            # Delete the log after processing
            cursor.execute("DELETE FROM room_schedule WHERE room_number = ?", (room,))
            conn.commit()

# Function to send the POST request for audio incidents detected via the database (frontend inserts)
def send_audio_incident_log(room: str):
    try:
        url = baseUrl + "/audio-incident-log/"  # Adjust the URL if needed
        data = {
            "room_number": room,
            "event_time": time.strftime("%H:%M:%S"),  # Current time
            "incident_source": "audio"  # Mark source as audio
        }
        response = requests.post(url, json=data)
        print(f"Audio incident log sent to server: {response.json()}")
    except Exception as e:
        print(f"Failed to send audio log: {e}")

# Initialize the webcam
cap = cv2.VideoCapture(1)  # Default webcam

# Check if the webcam is opened correctly
if not cap.isOpened():
    print("Error: Could not open webcam.")
    exit()

frame_counter = 0
processing_thread = None
frame_skip = 5  # Skip every 5 frames to reduce processing load
room_number = "101"  # Example room number, could be dynamic

try:
    while True:
        # Read a frame from the webcam
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture image")
            break

        # If enough frames have passed, process a new frame for video detection
        if frame_counter % frame_skip == 0:
            if processing_thread is None or not processing_thread.is_alive():
                # Create a unique image file name
                image_path = "temp_image.jpg"
                frame_copy = frame.copy()  # Make a copy of the frame for processing

                # Start a new thread for image processing (video incident detection)
                processing_thread = threading.Thread(target=process_image, args=(image_path, frame_copy, room_number))
                processing_thread.start()

        # Check the DB logs for any audio incidents reported via the frontend
        check_db_logs(room_number)

        # Draw the rectangle around the detected gun if gunDetected is True
        if gunDetected and pred_box:
            top_left, bottom_right = pred_box
            cv2.rectangle(frame, top_left, bottom_right, (0, 0, 255), 2)

        # Display the current frame (with or without the rectangle)
        cv2.imshow("Webcam Footage", frame)

        frame_counter += 1

        # Press 'q' to quit the webcam window
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

except KeyboardInterrupt:
    print("Stopped by user")

finally:
    # Release the webcam and close any OpenCV windows
    cap.release()
    cv2.destroyAllWindows()
