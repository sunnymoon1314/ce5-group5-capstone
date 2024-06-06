# https://www.datacamp.com/tutorial/machine-learning-models-api-python
# https://medium.com/red-buffer/how-to-build-a-rest-api-for-your-machine-learning-model-using-flask-8c2fbc75e359

# WORKDIR = C:\Users\bunny\OneDrive\OneDrive_AddOn\github\ce5-group5-capstone-project>
# docker build -t ml-model:latest .
# docker run -dp 5000:5000 ml-model:latest
#
# python src/test_predict.py
# {'prediction': '[0, 2, 1]'}
#
# When you test the POST method using postman.com, please enter the data as raw/JSON. The keys must be enclosed by double and not single quotes.
# [
#        {
#            "sepal length (cm)": 5.1,
#            "sepal width (cm)": 3.5,
#            "petal length (cm)": 1.1,
#            "petal width (cm)": 0.2
#        }
# ]
# Sample curl commands for testing.
# curl -i -X GET http://rest-api.io/items
# curl -i -X GET http://rest-api.io/items/5069b47aa892630aae059584
# curl -i -X DELETE http://rest-api.io/items/5069b47aa892630aae059584
# This is (1, versicolor).
# curl -i -X POST -H 'Content-Type: application/json' -d '{'sepal length (cm)': 6.7, 'sepal width (cm)': 2.8, 'petal length (cm)': 4.4, 'petal width (cm)': 1.4}' http://127.0.0.1:5000/predict
# curl -i -X PUT -H 'Content-Type: application/json' -d '{"name": "Updated item", "year": "2010"}' http://rest-api.io/items/5069b47aa892630aae059584

# Dependencies
from flask import Flask, request, jsonify
import joblib
import traceback
import pandas as pd
import numpy as np

# Your API definition
app = Flask(__name__)

description = """
    <!DOCTYPE html>
    <head>
    <title>Test Model Prediction</title>
    </head>
    <body>  
        <h3>Please specify the data in JSON format.</h3>
        <a href="http://localhost:5000/">Sample GET Request</a>
    </body>
"""

@app.route('/', methods=['GET'])
def hello_world():
    # return a html format string that is rendered in the browser
    return description

@app.route('/predict', methods=['POST'])
def predict():
    if model_loaded:
        try:
            # This segment from https://www.datacamp.com/tutorial/machine-learning-models-api-python
            json_ = request.json
            print(json_)
            query = pd.get_dummies(pd.DataFrame(json_))
            query = query.reindex(columns=model_columns, fill_value=0)
            prediction = list(model_loaded.predict(query))
            return jsonify({'prediction': str(prediction)})
            
            # This segment from # https://medium.com/red-buffer/how-to-build-a-rest-api-for-your-machine-learning-model-using-flask-8c2fbc75e359
            # json_ = request.json
            # df = pd.DataFrame(json_)
            # prediction = model_loaded.predict(df)
            # return jsonify({"Prediction": list(prediction)})

            # df = pd.DataFrame(json_)
            # prediction = model_loaded.predict(df)
            # return jsonify({"Prediction": list(prediction)})
        except:

            return jsonify({'trace': traceback.format_exc()})
    else:
        print ('Train the model first')
        return ('No model here to use')

if __name__ == '__main__':
    try:
        port = int(sys.argv[1]) # This is for a command-line input
    except:
        port = 5000 # If you don't provide any port the port will be set to 5000

    # Load the model file.
    model_loaded = joblib.load("./model/iris_model.pkl") # Load "model.pkl"
    print ('Model loaded')
    model_columns = joblib.load("./model/iris_model_columns.pkl") # Load "model_columns.pkl"
    print ('Model columns loaded')

    # For debugging locally
    # app.run(debug=True, host='0.0.0.0', port=5000)

    # For production
    app.run(host='0.0.0.0', port=5000)