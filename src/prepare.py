from sklearn import datasets
import pandas as pd 

def prepare():
    # Load dataset.
    iris = datasets.load_iris()
    # print(data)

    # https://stackoverflow.com/questions/55346510/how-do-i-write-scikit-learn-dataset-to-csv-file.
    # df = pd.DataFrame(data=iris['data'], columns = iris['feature_names'])
 
    # https://www.jcchouinard.com/sklearn-datasets-iris/
    df = pd.DataFrame(
        iris.data, 
        columns=iris.feature_names
        )
    df['target'] = iris.target
 
    # Map targets to target names
    target_names = {
        0:'setosa',
        1:'versicolor', 
        2:'virginica'
    }
 
    df['target_names'] = df['target'].map(target_names)
    df.head(10)
    df.tail(10)
    df.to_csv('./data/iris.csv', sep = ',', index = False)

if __name__ == "__main__":
    prepare()
