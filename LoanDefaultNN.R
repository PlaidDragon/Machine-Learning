library(neuralnet)
library(splitTools)
library(dplyr)

creditData <- read.csv("Loans.csv") 

#Adjust last five values to default
creditData$known_value[(nrow(creditData) - 4):nrow(creditData)] <- 1
colnames(creditData) <- c("clientid", "Inc", "attained age", "borrowed", "redundant_feature", "answer")

creditDatNorm <- creditData %>%
  na.omit() %>% #remove NA values
  mutate_at(vars(Inc, `attained age`, borrowed),  ~((.-min(.))/(max(.)-min(.)))) %>% #normalize data columns
  select(-redundant_feature, -clientid) %>% #remove non-useful columns
  rename("attained_age" = "attained age") #remove space in column name


#Split data into Training, Test, and Validation sets
indexSplit <- partition(creditDatNorm$answer, p = c(train = 0.70, valid = 0.10, test = 0.20))
trainData <- creditDatNorm[indexSplit$train, ] #70% of the data
validData <- creditDatNorm[indexSplit$valid, ] #10% of the data
testData <- creditDatNorm[indexSplit$test, ] #20% of the data


#Create Neural Network Model
nnMod <- neuralnet(answer~ ., data = trainData,
                   hidden = 5, act.fct = "logistic", linear.output = FALSE)

plot(nnMod)


#Predict the test data
predTest <- neuralnet::compute(nnMod, testData %>% select(-answer))
predTestRound <- round(predTest$net.result, 0)
head(predTestRound, 10)

#Determine the accuracy of the model using the test set
mean(testData$answer == predTestRound)*100


#Determine accuracy of the validation data
predVal <- neuralnet::compute(nnMod, validData %>% select(-answer))
predValRound <- round(predVal$net.result, 0)
head(predValRound, 10)

#Determine the accuracy of the model using the validation set
mean(validData$answer == predValRound)*100






#---------Determine Probability-----------

creditDataProb <- creditDatNorm %>%
  mutate("Default" = ifelse(answer == 1, TRUE, FALSE),
         "Paid" = ifelse(answer == 0, TRUE, FALSE)
         )



trainDataProb <- creditDataProb[indexSplit$train, ] #70% of the data
validDataProb <- creditDataProb[indexSplit$valid, ] #10% of the data
testDataProb <- creditDataProb[indexSplit$test, ] #20% of the data


#Create Neural Network Model
nnModProb <- neuralnet(Default + Paid~ Inc+attained_age+borrowed, data = trainDataProb,
                   hidden = 5, act.fct = "logistic", linear.output = FALSE)

plot(nnModProb)


#Predict the test data
predTestProb <- neuralnet::compute(nnModProb, testDataProb %>% select(-Default, -Paid))
predTestRoundProb <- round(predTestProb$net.result, 0)
head(predTestRoundProb, 10)

#Determine the accuracy of the model using the test set
mean((testDataProb$Default == predTestRoundProb[,1]) & (testDataProb$Paid == predTestRoundProb[,2]) )*100


