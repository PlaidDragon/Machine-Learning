library(e1071)
library(dplyr)
library(plotly)
library(tidyr)
library(psych)


#Read in data and check classes
train <- read.csv("titanic-train.csv")
test <- read.csv("titanic-test.csv")

allDat <- rbind.data.frame(train %>% select(-Survived), test) 
summary(allDat)

#Features such as Cabin and Name and Ticket are unimportant. 
#There are two Embarked observations with no data and a significant number of missing ages.
#We know that age is a strong indicator of who survived the Titanic sinking, so we don't 
#want to throw this feature out. However, there are too many missing observations to simply replace 
#them with the mean age. Instead, we should investigate the relationships between the missing data.

cleanedDat <- allDat %>% 
  select(-Cabin, -Name, -Ticket) %>%
  mutate("Embarked" = as.factor(ifelse(Embarked == "", "S", Embarked))) %>% #Embarked is strongly Skewed to "S"
  mutate_at(vars(Pclass, Sex, SibSp, Parch, Embarked), ~as.factor(.))
  

summary(cleanedDat)


#------------Fill in the Missing Ages-----------

#Look for distribution of missing age data

cleanedDat %>%
  group_by(Sex) %>%
  mutate("Missing Age" = sum(is.na(Age) == T)) %>%
  distinct(Sex, `Missing Age`) %>%
  plot_ly(x=~Sex, y=~`Missing Age`, color =~Sex, type='bar') %>%
  layout(yaxis=list(title="Frequency"),
         xaxis=list(title="Missing Ages"),
         title = paste("Missing Ages by Gender")
  )


cleanedDat %>%
  group_by(Pclass) %>%
  mutate("Missing Age" = sum(is.na(Age) == T)) %>%
  distinct(Pclass, `Missing Age`) %>%
  plot_ly(x=~Pclass, y=~`Missing Age`,color =~Pclass, type='bar') %>%
  layout(yaxis=list(title="Frequency"),
         xaxis=list(title="Missing Ages"),
         title = paste("Missing Ages by Passenger Class")
  )

#There is a definite skew to having missing ages for men in 3rd class. 
#It would be more beneficial to group by gender and class and fill in missing ages 
#with the grouping's median rather than replacing the missing ages with the mean of the entire data set.

cleanedDatAges <- cleanedDat %>%
  group_by(Sex, Pclass) %>%
  mutate("Age" = replace_na(Age, mean(Age, na.rm = T)))
summary(cleanedDatAges) #Verify no missing data



#-----------Principal Component Analysis--------------
allClean <- cleanedDatAges %>%
  mutate_at(vars(-PassengerId), ~as.numeric(.))

trainClean <- allClean %>%
  filter(PassengerId %in% train$PassengerId) %>% #Get cleaned Train Data
  left_join(train %>% select(Survived, PassengerId), by = "PassengerId") %>% #Bring in target variable
  select(-PassengerId) #remove unneeded data column

testClean <- allClean %>%
  filter(PassengerId %in% test$PassengerId) %>%
  select(-PassengerId)

#Perform Principal Component Analysis  to determine best parameters for SVM Model
pca <- prcomp(trainClean[,-8], center = TRUE, scale = TRUE)
summary(pca)

#Visualize PCA
pairs.panels(pca$x, gap=0, bg=c('blue','green','red')[trainClean$Survived],pch=21)

trainPCA <- as.data.frame(predict(pca, trainClean)) %>%
  mutate("Survived" = trainClean$Survived)
testPCA <- as.data.frame(predict(pca, testClean))


#Perform Gridsearch using the created PCA dataframe
supVecMod <- svm(Survived ~ ., data = trainPCA, kernel = "linear", gamma=1, cost=1)

gridSearch <- tune(svm, Survived ~ ., data = trainPCA,
                   ranges = list(cost = c(0.01, 1, 10, 50, 100),
                                 gamma = c(0.5, 1, 3, 5),
                                 kernal=c("linear","radial","sigmoid"))
)

summary(gridSearch)


#Create Model using the best found parameters
svmPred <- predict(gridSearch$best.model, newdata = trainPCA)
svmPred <- ifelse(svmPred < 0.5, 0, 1) #Round to determine target variable
table(svmPred, trainPCA$Survived)

#Accuracy
(522+251)/nrow(trainPCA)
