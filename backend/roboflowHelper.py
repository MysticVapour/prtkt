from roboflow import Roboflow
rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)

project = rf.workspace().project("gn-detect")
model = project.version(2).model

# infer on a local image

print(model.predict("backend/pistol1.jpeg", confidence=40, overlap=30).json())
