from fastapi import FastAPI
from pydantic import BaseModel
import sqlite3

# Initialize FastAPI app
app = FastAPI()

# Connect to the SQLite database
conn = sqlite3.connect('example.db', check_same_thread=False)
cursor = conn.cursor()

# Create the table if it doesn't already exist
cursor.execute('''
CREATE TABLE IF NOT EXISTS room_schedule (
    room_number TEXT NOT NULL,
    event_time TEXT NOT NULL
)
''')
conn.commit()

# Define a Pydantic model for the request body
class RoomSchedule(BaseModel):
    room_number: str
    event_time: str  # Format: HH:MM:SS

# FastAPI endpoint to insert data into the room_schedule table
@app.post("/incident-log/")
async def incident_log(schedule: RoomSchedule):
    try:
        # Insert the room number and time into the database
        cursor.execute(
            "INSERT INTO room_schedule (room_number, event_time) VALUES (?, ?)", 
            (schedule.room_number, schedule.event_time)
        )
        conn.commit()
        return {"message": "Room no. ${schedule.room_number} added successfully at time ${schedule.event_time}"}
    except Exception as e:
        return {"error": str(e)}

