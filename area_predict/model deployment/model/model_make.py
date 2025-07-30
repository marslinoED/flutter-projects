import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np
import pickle  # Import pickle for saving the model

# Create DataFrame from the data
data = {
    'area': [100, 200, 300, 400, 500],
    'price': [10, 20, 30, 40, 50]
}
df = pd.DataFrame(data)

# Features and target
X = df[['area']]  # Feature (2D array for sklearn)
y = df['price']   # Target

# Train the model
model = LinearRegression()
model.fit(X, y)

# Make predictions
y_pred = model.predict(X)

# Evaluate the model
mse = mean_squared_error(y, y_pred)
r2 = r2_score(y, y_pred)

print(f'Mean Squared Error: {mse}')
print(f'R² Score: {r2}')
print(f'Model Coefficient (slope): {model.coef_[0]}')
print(f'Model Intercept: {model.intercept_}')

# Save the model using pickle
with open('house_price_model.pkl', 'wb') as file:
    pickle.dump(model, file)
print("Model saved as 'house_price_model.pkl'")


