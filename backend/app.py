import requests
#from inference import get_model
#import supervision as sv
#import cv2pip
import roboflow
from fastapi import FastAPI
from pydantic import BaseModel

rbfkey = "VPnji39f7Fj12PD9z35O"
rf = roboflow.Roboflow(api_key=rbfkey)
project = rf.workspace()
gunDetected = False


app = FastAPI()

class Student(BaseModel):
    name: str
    designation: str | None = None

@app.get("/gun.detected")
def read_root(student: Student):
    return {"name": student.name, "isGunDetected": gunDetected ,"room": student.designation}

'''@app.get("/gandu")
def read_gandu():
    return {1: "Tonya"} '''

@app.post("/post_test")
def read_post(person: Student):
    return {"Message": "Hey " + person.name} 
