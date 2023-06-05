import pandas as pd
import os
import numpy as np
from sklearn import tree
from matplotlib import pyplot as plt

animals = pd.read_csv('animals-training.csv', header=0)
animals.head()

#Convert categroical variables to numberical by creating dummy variables
colList = list(animals.columns)
objList = []
for col in colList:
    if animals.dtypes[col] == object:
        objList.append(col)
objList # list of categorical variables


# 1-Hot encoding using pandas
animalsCats = pd.get_dummies(animals[objList[:-1]], prefix_sep='_', drop_first=False)
animalsCats.head()

#Get list of Continuous variables
contList = [item for item in colList if item not in objList] # select all columns not in categorical column list

#Create new dataframe with all continuous variables
aniamlsCont = animals[contList]
aniamlsVars = pd.concat([aniamlsCont, animalsCats],axis=1)
featureVals = aniamlsVars

#List of features to be used in model
features = list(aniamlsVars.columns)
features


#-----Create model--------
target = animals.iloc[:, -1].values    #Pull out the target variable

# train Decision Tree classifier
dTree = tree.DecisionTreeClassifier(max_leaf_nodes=None, criterion='gini') #Could also use entropy method
dTree = dTree.fit(featureVals,target)

#Determine accuracy of the model
predictions = dTree.predict(featureVals)
accuracy = (predictions == target).sum() / len(predictions)
accuracy

#Visualize the decision tree
plt.figure(figsize=(10,10))
tree.plot_tree(dTree, feature_names=(features), class_names=(np.unique(target)), filled=True)
plt.show()

