import requests
from fastapi import FastAPI
from pydantic import BaseModel
from roboflow import Roboflow
import cv2
import threading
import os
import time

rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)
project = rf.workspace().project("gn-detect")
model = project.version(2).model
print("Roboflow Initialized")

# Shared variables to store the detection result
gunDetected = False
pred_box = None

# Function to process the image
def readImage(pathName: str):
    prediction = model.predict(pathName, confidence=40, overlap=30).json()
    os.remove(pathName)
    print(f"Deleted file: {pathName}")
    return prediction

# Worker thread to handle image processing
def process_image(image_path, frame):
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
            else:
                gunDetected = False
                pred_box = None
    else:
        gunDetected = False
        pred_box = None

# Initialize the webcam
cap = cv2.VideoCapture(1)  # Default webcam

# Check if the webcam is opened correctly
if not cap.isOpened():
    print("Error: Could not open webcam.")
    exit()

frame_counter = 0
processing_thread = None
frame_skip = 5  # Skip every 5 frames to reduce processing load

try:
    while True:
        # Read a frame from the webcam
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture image")
            break

        # If enough frames have passed, process a new frame
        if frame_counter % frame_skip == 0:
            if processing_thread is None or not processing_thread.is_alive():
                # Create a unique image file name
                image_path = "temp_image.jpg"
                frame_copy = frame.copy()  # Make a copy of the frame for processing

                # Start a new thread for image processing
                processing_thread = threading.Thread(target=process_image, args=(image_path, frame_copy))
                processing_thread.start()

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
