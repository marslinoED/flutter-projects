import pickle  # Import pickle for saving the model
import numpy as np

# Load the saved model
with open('house_price_model.pkl', 'rb') as file:
    loaded_model = pickle.load(file)

# Example prediction with the loaded model
area = input("Enter the area in sq ft: ")
price = np.array([[int(area)]])  # Reshape for prediction
predicted_price = loaded_model.predict(price)
print(f'Predicted price for {area} sq ft (loaded model): {predicted_price[0]}')