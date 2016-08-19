setwd("/Users/rituc/machine_learning/titanic_survival/")
# Load packages
library('ggplot2') # visualization
library('ggthemes') # visualization
library('scales') # visualization
library('dplyr') # data manipulation
library('mice') # imputation
library('randomForest') # classification algorithm

training_set <- read.csv('train.csv', stringsAsFactors = F)
test_set <- read.csv('test.csv', stringsAsFactors = F)
data <- bind_rows(training_set, test_set)
colnames(data)
data$Title <- gsub('(.*, )|(\\..*)', '', data$Name)
data$Title
table(data$Sex, data$Title)
rare_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')

data$Title[data$Title == 'Mlle']        <- 'Miss' 
data$Title[data$Title == 'Ms']          <- 'Miss'
data$Title[data$Title == 'Mme']         <- 'Mrs' 
data$Title[data$Title %in% rare_title]  <- 'Rare Title'

data$Surname <- sapply(data$Name, function(x) strsplit(x, split = '[,.]')[[1]][1])
unique_surnames = nlevels(factor(data$Surname))
print(unique_surnames)
table(data$Survived, data$Surname)

# Create a family size variable including the passenger themselves
data$Fsize <- data$SibSp + data$Parch + 1
data$Family <- paste(data$Surname, data$Fsize, sep='_')

# Use ggplot2 to visualize the relationship between family size & survival
ggplot(data[1:891,], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  labs(x = 'Family Size') +
  theme_few()

# Discretize family size
data$FsizeD[data$Fsize == 1] <- 'singleton'
data$FsizeD[data$Fsize < 5 & data$Fsize > 1] <- 'small'
data$FsizeD[data$Fsize > 4] <- 'large'

table(data$FsizeD, data$Survived)
mosaicplot(table(data$FsizeD, data$Survived), main='Family Size by Survival', shade=TRUE)
strsplit(data$Cabin[2], NULL)[[1]]
data$Deck <- factor(sapply(data$Cabin, function(x) strsplit(x, split = NULL)[[1]][1]))
data[c(62, 830), 'Embarked']

# Get rid of our missing passenger IDs
embark_fare <- data %>% filter(PassengerId != 62 & PassengerId != 830)

# Use ggplot2 to visualize embarkment, passenger class, & median fare
ggplot(embark_fare, aes(x = Embarked, y = Fare, fill = factor(Pclass))) +
  geom_boxplot() +
  geom_hline(aes(yintercept=80), 
             colour='red', linetype='dashed', lwd=2) +
  scale_y_continuous(labels=dollar_format()) +
  theme_few()
# Since their fare was $80 for 1st class, they most likely embarked from 'C'
data$Embarked[c(62, 830)] <- 'C'

ggplot(data[data$Pclass == '3' & data$Embarked == 'S', ], 
       aes(x = Fare)) +
  geom_density(fill = '#99d6ff', alpha=0.4) + 
  geom_vline(aes(xintercept=median(Fare, na.rm=T)),
             colour='red', linetype='dashed', lwd=1) +
  scale_x_continuous(labels=dollar_format()) +
  theme_few()


data$Fare[1044] <- median(data[data$Pclass == '3' & data$Embarked == 'S', ]$Fare, na.rm = TRUE)

# Make variables factors into factors
factor_vars <- c('PassengerId','Pclass','Sex','Embarked', 'Title','Surname','Family','FsizeD')
data[factor_vars] <- lapply(data[factor_vars], function(x) as.factor(x))
set.seed(129)

mice_output <- complete(mice_mod)


# Plot age distributions
par(mfrow=c(1,2))
hist(data$Age, freq=F, main='Age: Original Data', 
     col='darkgreen', ylim=c(0,0.04))
hist(mice_output$Age, freq=F, main='Age: MICE Output', 
     col='lightgreen', ylim=c(0,0.04))

data$Age <- mice_output$Age
sum(is.na(data$Age))

# First we'll look at the relationship between age & survival
ggplot(data[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram() + 
  # I include Sex since we know (a priori) it's a significant predictor
  facet_grid(.~Sex) + 
  theme_few()

data$Child[data$Age < 18] <- 'Child'
data$Child[data$Age >= 18] <- 'Adult'
data$Mother <- 'Not Mother'

data$Mother[data$Sex == 'female' & data$Parch > 0 & data$Age > 18 & data$Title != 'Miss'] <- 'Mother'
table(data$Mother, data$Survived)
na.omit(data)
train <- data[1:891,]
test <- data[892:1309,]
set.seed(754)

rf_model <- randomForest(factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + 
                           Fare + Embarked + Title + 
                           FsizeD + Child + Mother,
                         data = train)

plot(rf_model, ylim=c(0,0.36))
legend('topright', colnames(rf_model$err.rate), col=1:3, fill=1:3)