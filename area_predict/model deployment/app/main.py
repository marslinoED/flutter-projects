from fastapi import FastAPI, Body
from typing import Union
import pickle
import numpy as np

app = FastAPI()

with open('house_price_model.pkl', 'rb') as file:
    loaded_model = pickle.load(file)

@app.get("/")
async def root():
    return {"message": "Welcome to the House Price Prediction API. Use POST /predict to make predictions. Docs: /docs"}

@app.post("/predict")
async def predict_price(data: dict = Body(...)):
    area = data.get("area")
    if not isinstance(area, (int, float)):
        raise ValueError(f"Area must be a number, got {type(area)}: {area}")
    price = np.array([[float(area)]])  # Convert to float for prediction
    predicted_price = loaded_model.predict(price)
    return {"predicted_price": float(predicted_price[0])}