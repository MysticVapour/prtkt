import cv2
import os
import time
from roboflow import Roboflow

rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)
project = rf.workspace().project("gn-detect")
model = project.version(2).model

# Function to process the image
def readImage(pathName: str):
    model.predict(pathName, confidence=40, overlap=30).json()

# Initialize the webcam
cap = cv2.VideoCapture(0)

# Check if the webcam is opened correctly
if not cap.isOpened():
    print("Error: Could not open webcam.")
    exit()

# Counter for saving images
counter = 0

try:
    while True:
        # Capture frame-by-frame
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture image")
            break

        # Save the frame as an image file
        image_path = f"image_{counter}.jpg"
        cv2.imwrite(image_path, frame)
        print(f"Image saved as {image_path}")

        # Process the image using the custom function
        readImage(image_path)

        # Delete the image after processing
        os.remove(image_path)
        print(f"Image {image_path} deleted")

        # Wait for 1 second before capturing the next image
        time.sleep(1)

        # Increment the counter for the next image
        counter += 1

except KeyboardInterrupt:
    print("Stopped by user")

finally:
    # Release the webcam and close any OpenCV windows
    cap.release()
    cv2.destroyAllWindows()
