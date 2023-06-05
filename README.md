# Machine-Learning
Examples of various scripts that include machine learning (Pytorch, Tensorflow, caret, nuralnet, ect)


# Table of contents
1. [Neural Net to Predict Probability of Loan Default (R)](#loanNNR)
3. [Support Vector Model using Titanic Dataset (R)](#svmR)
4. [Decision Tree to Predict Animal Species (R)](#decTreeR)
5. [Decision Tree to Predict Animal Species (Python)](#decTreePy)


## **Neural Net:**<a name="loanNNR"></a>

**Files included:** LoanDefaultNN.R

**Purpose:** Predict the probability of a user defaulting on a loan using a nural net model type

Predictor values given include the Client ID, Income, Age, Borrowed ammount, and the loan to income ratio. Client ID was removed and Loan to income ratio was deemed redundant. This dataset happened to come pre-cleaned so no cleaning was necessary in this case.

Two seperate models were created: The first uses the single "answer" column as the target variable while the second created two seperate columns that each represent default or paid with a boolean value. 

The first model has an accuracy of ~98% while the second has an accuracy of over 99%. These numbers usually indicate that the model is overfitting as we wouldn't expect accuracy that high. Next steps would be to explore the model itself to determine if it is indeed overfitting the data. It is also a possibility there is some sort of order to the data that is being factored into the model and 'shuffling' the data may include more randomness.


**Libraries used:** neuralnet, splitTools, dplyr

**Output:** 

![image](https://github.com/PlaidDragon/Machine-Learning/assets/135033377/1b920e68-3d06-4e74-984f-b7cd82520c97)



## **Support Vector in R:**<a name="svmR"></a>

**Files included:** TitanicSVM.R

**Purpose:** Predict the probability of an individual surviving the Titanic Disaster

Predictor values are the usual Titanic Dataset features: age, class, gender, perch, class, fare, cabin

The dataset has many missing values for age. Age and gender are the two most defining features for this particualr dataset, so rather than throw the data out, a dive into the distribution of the missing ages in particular was done. Bar charts showed the missing data is strongly skewed towards Men in the 3rd Class; the mean of this group in particualr was used to fill in the missing ages. 

A Principal Component Analysis was then performed in order to determine the optimal parameters to feed into the SVM. Parameters were deemed to be optimal at cost=1, gamma=0.5, with a linear kernal. This model yeilded an accuracy of 86%.


**Libraries used:** dplyr, plotly, e1071, tidyr, psych

**Output:** 

![image](https://github.com/PlaidDragon/Machine-Learning/assets/135033377/8ae872ba-c0f9-4511-8795-53f16ab556e6)




## **Decision Tree in R:**<a name="decTreeR"></a>

**Files included:** DecisionTree.R

**Purpose:** Predict the Species of an animal with a decision tree model

Predictor values given include body covering and number of legs. Target variable is animal species

The dataset is quite small. A 70/30 split leaves only two datapoints for the test dataset. With the original data, the model has an 94% accuracy on the test data, and 100% on the train. The lack of data in the training model makes the accuracy reading largely unreliable. A larger dataset could be useful in getting a more reliable read on the accuracy of the model. 


**Libraries used:** dplyr, caret, rpart

**Output:** 

![image](https://github.com/PlaidDragon/Machine-Learning/assets/135033377/efa36314-6eb3-46f3-ac33-f7a9be9600c1)



## **Decision Tree in Python:**<a name="decTreePy"></a>

**Files included:** DecisionTree.py

**Purpose:** Predict the Species of an animal with a decision tree model

Predictor values given include body covering and number of legs. Target variable is animal species

The dataset is quite small. A 70/30 split leaves only two datapoints for the test dataset. Python's sklearn Tree method does not accept categorical variables, so the script utilizes one-hot encoding. The resulting tree has high accuracy, but it is also using the whole dataset, as opposed to the R script that pulled out 70% of it


**Libraries used:** matplotlib, sklearn, pandas, numpy

**Output:** 

![image](https://github.com/PlaidDragon/Machine-Learning/assets/135033377/524e7f18-e354-4cf9-a920-db75cbcc9c65)

