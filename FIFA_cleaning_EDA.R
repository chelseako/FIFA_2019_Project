
library(corrplot) # For corrplot
library(moments) # For skewness
library(ggplot2) # For visualizations

#########################
# FIFA 2019 Data Cleaning
#########################

df <- cleanFIFA

# Convert categorical variables to factors

df$Position = as.factor(cleanFIFA$Position)

summary(df$Position)

df$Nationality = as.factor(cleanFIFA$Nationality)

summary(df$Nationality)
        
df$Preferred.Foot = as.factor(cleanFIFA$Preferred.Foot)

summary(df$Preferred.Foot)

df$Work.Rate = as.factor(cleanFIFA$Work.Rate)

summary(df$Work.Rate)

df$Body.Type = as.factor(cleanFIFA$Body.Type)

summary(df$Body.Type)

df$Contract.Valid.Until = as.factor(cleanFIFA$Contract.Valid.Until)

summary(df$Contract.Valid.Until)

# Remove irrelevant variables: Name, Nationality, Club, Joined, Contract Valid Until
# Removed Release Clause because highly correlated with value (r>0.99) and missing 1300+ values

df <- df[-c(1,3,6,17,18,76)]

# Remove categorical vars: Preferred food, work rate, body type, position

dfNumeric <- df[-c(7,11:13)]

summary(dfNumeric)

###########################
# Exploratory Data Analysis
###########################

cor.fifa = cor(dfNumeric)

corrplot(cor.fifa, method="ellipse", order="AOE")

# Calculate correlations between each var

model <- lm(Age ~ ., data=dfNumeric)
summary(model)

# Remove duplicate variables

dfNumeric <- dfNumeric[-c(13,14,17,18,19,21,22,25,26,27,30,31,32,35,36,37)]

# Check to see if each variable can be accounted for by remaining variables 95%+

model <- lm(Special ~ ., data=dfNumeric)
summary(model)
# Remove Special - R^2 = 0.9983
dfNumeric <-dfNumeric[-c(6)]


model <- lm(LS ~ ., data=dfNumeric)
summary(model)
# Remove LS - R^2 = 0.99
dfNumeric <- dfNumeric[-c(11)]


model <- lm(LW ~ ., data=dfNumeric)
summary(model)
# Remove LW - R^2 = 0.9991
dfNumeric <- dfNumeric[-c(11)]

model <- lm(LF ~ ., data=dfNumeric)
summary(model)
# Remove LF - R^2 = 0.9991
dfNumeric <- dfNumeric[-c(11)]


model <- lm(LAM ~ ., data=dfNumeric)
summary(model)
# Remove LAM - R^2 = 0.9991
dfNumeric <- dfNumeric[-c(11)]

model <- lm(LM ~ ., data=dfNumeric)
summary(model)
# Remove LM - R^2 = 0.999
dfNumeric <- dfNumeric[-c(11)]

model <- lm(LCM ~ ., data=dfNumeric)
summary(model)
# Remove LCM - R^2 = 0.9989
dfNumeric <- dfNumeric[-c(11)]

model <- lm(LWB ~ ., data=dfNumeric)
summary(model)
# Remove LWB - R^2 = 0.9989
dfNumeric <- dfNumeric[-c(11)]

model <- lm(LDM ~ ., data=dfNumeric)
summary(model)
# Remove LDM - R^2 = 0.9991
dfNumeric <- dfNumeric[-c(11)]

model <- lm(LB ~ ., data=dfNumeric)
summary(model)
# Remove LB - R^2 = 0.999
dfNumeric <- dfNumeric[-c(11)]

model <- lm(LCB ~ ., data=dfNumeric)
summary(model)
# Remove LCB - R^2 = 0.9994
dfNumeric <- dfNumeric[-c(11)]

model <- lm(SlidingTackle ~ ., data=dfNumeric)
summary(model)

########################################
# Skew Test for Normality
#########################################

skewTest = round(skewness(dfNumeric, na.rm=TRUE), 2)
skewTest

# Value, Wage, International Reputation, above 1.0

# Wage

hist(dfNumeric$Wage)

dfNumeric$logWage <- log(dfNumeric$Wage + 1)
skewness(dfNumeric$logWage)  # -1.41

hist(dfNumeric$logWage)
# Remove wage
dfNumeric <- dfNumeric[-c(5)]

# Value
dfNumeric$logValue <- log(dfNumeric$Value + 1)
skewness(dfNumeric$logValue)  # -3.39

hist(dfNumeric$logValue)
# Remove Value
dfNumeric <- dfNumeric[-c(4)]


cor.fifa = cor(dfNumeric)

corrplot(cor.fifa, method="ellipse", order="AOE")


