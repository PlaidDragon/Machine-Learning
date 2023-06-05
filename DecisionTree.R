library(dplyr)
library(caret)
library(rpart)
library(rpart.plot)


#Read in and clean data
animals <- read.csv("animals-training.csv") %>%
  mutate_at(vars(Body.Covering, Animal), ~as.factor(.))
str(animals)
colnames(animals)[1] <- "Legs"

# create a train and test split. target variable (label) Animal. 70/30 split
index <- createDataPartition(y = animals$Animal,
                             p = .7,
                             list = FALSE)

animalsTrain <- animals[index,] 
animalsTest <- animals[-index,]



# Fit a decision tree
# Set the formula with all variables.If you choose, you can manually type the formula.
dtree <- rpart(Animal ~ Body.Covering + Legs, data = animalsTrain, method = "class", #categorical target
               control = rpart.control(minbucket = 2, cp = 0.00001, maxdepth = 7), 
               parms = list(split = "gini"))

# Plot the tree.
rpart.plot(dtree)



#----Training Error-------
predTrain <- predict(dtree, type = "class") 

#confusion matrix and accuracy
table(predTrain, animalsTrain$Animal)
(3+5+3+2+2)/(nrow(animalsTrain))



#----Testing Error-------
predTest <- predict(dtree, type = "class", newdata = animalsTest) 

#confusion matrix and accuracy
table(predTest, animalsTest$Animal)
(2)/(nrow(animalsTest))