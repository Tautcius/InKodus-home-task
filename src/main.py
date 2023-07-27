from fastapi import FastAPI, Response

app = FastAPI()

@app.get("/")
async def root():
    return {"msg": "This is Home."}

@app.get("/hello")
async def hello():
    return {"msg":"Hello World"}

print('test line')