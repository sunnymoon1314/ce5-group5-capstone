import pandas as pd
from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import joblib

def train_build():
    # Load dataset
    # iris = datasets.load_iris()
    # X = iris.data
    # y = iris.target
    
    data = pd.read_csv('./data/iris.csv')
    data.head()
    data.tail()

    X = data.drop(['target', 'target_names'], axis=1)
    y = data["target"]
    X.head()
    X.tail()
    y.head()
    y.tail()

    # Split dataset into training set and test set
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=123)

    # Create a Gaussian Classifier
    clf = RandomForestClassifier()

    # Train the model using the training sets
    clf.fit(X_train, y_train)

    # Predict the response for test dataset
    y_pred = clf.predict(X_test)

    # Model Accuracy, how often is the classifier correct?
    # print(f"Accuracy: {accuracy_score(y_test, y_pred)}")
    with open('./model/accuracy.txt', 'w') as f:
        f.write(f"Accuracy: {accuracy_score(y_test, y_pred)}")
        f.write('\n')

    # https://stackoverflow.com/questions/47059781/how-to-append-new-dataframe-rows-to-a-csv-using-pandas
    # data.head().to_csv('./model/accuracy.txt', sep='\t', header=None, mode='a')
    data.head().to_csv('./model/accuracy.txt', sep='\t', mode='a')
    data.tail().to_csv('./model/accuracy.txt', sep='\t', header=None, mode='a')

    # Save the trained model
    joblib.dump(clf, './model/iris_model.pkl')
    print("Model dumped!")
    # Saving the data columns from training
    model_columns = list(X.columns)
    joblib.dump(model_columns, './model/iris_model_columns.pkl')
    print("Models columns dumped!")

if __name__ == "__main__":
    train_build()
