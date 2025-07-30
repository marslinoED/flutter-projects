import torch
from torchvision import models, transforms
from fastapi import FastAPI, File, UploadFile, HTTPException
from PIL import Image
import io

# Initialize FastAPI app
app = FastAPI(title="Bird vs Forest Image Classifier")

# Set device
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Define transforms
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

# Load the model
model = models.resnet18()
num_ftrs = model.fc.in_features
model.fc = torch.nn.Linear(num_ftrs, 1)
model.load_state_dict(torch.load('bird_forest_classifier.pth', map_location=device))
model = model.to(device)

def predict_image(image: Image.Image, model, transform, device):
    model.eval()
    try:
        image = image.convert('RGB')
        image = transform(image).unsqueeze(0).to(device)
        with torch.no_grad():
            output = model(image)
            raw_output = output.item()
            prob = torch.sigmoid(output).item()
            label = 'Bird' if prob < 0.5 else 'Forest'
            confidence = 1 - prob if prob < 0.5 else prob
        return {
            'class': label,
            'confidence': confidence,
            'raw_output': raw_output,
            'probability_bird': 1 - prob,
            'probability_forest': prob
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to process image: {str(e)}")

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not file.content_type.startswith('image/'):
        raise HTTPException(status_code=400, detail="File must be an image")

    try:
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))
        result = predict_image(image, model, transform, device)
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

@app.get("/")
async def welcome_page():
    return {"message": "Please use /predict endpoint to upload an image for prediction, and /docs for documentation."}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)