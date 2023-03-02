from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def show_instructions():
    return {
        "headline": "Welcome to the ADK Wrapped API",
        "content": "Please find your greybox ID and enter it at /achievements/{greybox_id}",
    }


@app.get("/achievements/{greybox_id}")
def show_achievements(greybox_id: int):
    pass