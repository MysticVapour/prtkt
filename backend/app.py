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


# Function to process the image
def readImage(pathName: str):
    prediction = model.predict(pathName, confidence=40, overlap=30).json()
    os.remove(pathName)
    print(f"Deleted file: {pathName}")
    return prediction


# Initialize the webcam
cap = cv2.VideoCapture(0)

# cap.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
# cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)
# cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*"MJPG"))


def process_image(image_path):
    # Save the frame as an image file
    cv2.imwrite(image_path, frame)
    print(f"Image saved as {image_path}")

    # Process the image using the custom function
    readImage(image_path)


# Check if the webcam is opened correctly
if not cap.isOpened():
    print("Error: Could not open webcam.")
    exit()

frame_counter = 0

try:
    while True:
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture image")
            break

        if frame_counter % 2 == 0:
            # Display the resulting frame
            cv2.imshow("Webcam Footage", frame)

            # Process image in a new thread
            image_path = "temp_image.jpg"
            threading.Thread(target=process_image, args=(image_path,)).start()

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


app = FastAPI()
