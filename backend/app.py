import requests
from fastapi import FastAPI
from pydantic import BaseModel
from roboflow import Roboflow
import cv2
import threading
import os
import time
from roboflow import Roboflow

rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)
project = rf.workspace().project("gn-detect")
model = project.version(2).model
gunDetected = False
print("Roboflow Initialized")

# Initialize the webcam
cap = cv2.VideoCapture(1)

cap.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)
cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*'MJPG')) 

def readImage(pathName: str):
    model.predict(pathName, confidence=40, overlap=30).json()

def process_image(image_path, counter):
    # Save the frame as an image file
    cv2.imwrite(image_path, frame)
    print(f"Image saved as {image_path}")

    # Process the image using the custom function
    readImage(image_path)

    # Delete the image after processing
    os.remove(image_path)
    print(f"Image {image_path} deleted")

# Check if the webcam is opened correctly
if not cap.isOpened():
    print("Error: Could not open webcam.")
    exit()

counter = 0
frame_counter = 0

try:
    while True:
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture image")
            break

        if frame_counter % 2 == 0:
            # Display the resulting frame
            cv2.imshow('Webcam Footage', frame)

            # Process image in a new thread
            image_path = f"image_{counter}.jpg"
            threading.Thread(target=process_image, args=(image_path, counter)).start()

            # Increment the counter for the next image
            counter += 1

        frame_counter += 1

        # Press 'q' to quit the webcam window
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

except KeyboardInterrupt:
    print("Stopped by user")

finally:
    # Release the webcam and close any OpenCV windows
    cap.release()
    cv2.destroyAllWindows()


app = FastAPI()





