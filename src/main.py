from fastapi import FastAPI, Response

app = FastAPI()

@app.get("/")
async def root():
    return {"This is Home."}

@app.get("/hello")
async def root():
    return {"World."}