
library(rgl)
library(MASS)
library(psych)  # For parallel analysis and psych

####################
# Confusion function
####################

confusion = function(actual, predicted, names = NULL, printit = TRUE, prior = NULL) 
{
  if (is.null(names))
    names = levels(actual)
  tab = table(actual, predicted)
  acctab = t(apply(tab, 1, function(x) x/sum(x)))
  dimnames(acctab) = list(Actual = names, "Predicted (cv)" = names)
  if (is.null(prior)) 
  {
    relnum = table(actual)
    prior = relnum/sum(relnum)
    acc = sum(tab[row(tab) == col(tab)])/sum(tab)
  }
  else 
  {
    acc = sum(prior * diag(acctab))
    names(prior) = names
  }
  
  print(round(c("Accuracy" = acc, "Prior Frequency" = prior), 4))
  cat("\nConfusion Matrix", "\n")
  print(round(acctab, 4))
}

##########################
# Kaiser-Meyer Olkin (KMO)
# measure of sample adequacy
##########################

KMO(dfNumeric)


##############################
# Bartlett Test of Sphericity
##############################

library(stats)
bartlett.test(dfNumeric)
# statistic = 471554, p-value < 2.2e-16

###################################
# Run PCA to determine # of factors
###################################

p = prcomp(dfNumeric, scale=T)

print(p)
summary(p)

plot(p)
abline(1, 0, col="red")
# 6th factor slightly above var = 1 line.
# Knee method indicates 5 factors

plot(p$x[, 1:2], col=df$Position)

PCA_Plot = ggplot(df, aes(x=p$x[,1], y = p$x[,2])) + 
  geom_point(col=as.numeric(df$Position)) +
  labs(title="PCA Plot 2D", x="PC1", y="PC2") +
  theme(
    axis.title.x = element_text(size=16, margin=margin(t=8)),
    axis.title.y = element_text(size=16, margin=margin(r=8)),
    axis.text.x = element_text(size=14),
    axis.text.y = element_text(size=14),
    plot.title = element_text(size=20)
  )

PCA_Plot

scatter3d(x = p$x[, 1], y = p$x[, 2], z = p$x[, 3],
          point.col = as.numeric(df$Position), surface=FALSE)


# Parallel analysis

parallel_PFA = fa.parallel(dfNumeric, n.iter=500)
# Parallel analysis indicates 9 factors and 6 components

##########################
# Run PFA using 5 factors
##########################

p = principal(dfNumeric, nfactors=5)

summary(p)

print(p$loadings, cutoff=.4, sort=T)


##########################
# Run CFA using 5 factors
##########################

fit <- factanal(dfNumeric, 5)

print(fit, cutoff=.4, sort=T)


#############################
# Run LDA on original dataset
#############################

# Create updated dataframe
df2 <- dfNumeric
df2$Preferred.Foot <- df$Preferred.Foot
df2$Work.Rate <- df$Work.Rate
df2$Body.Type <- df$Body.Type
df2$Position <- df$Position

CVorig.lda <- lda(Position ~ ., data=df2, CV=TRUE)

table(df2$Position, CVorig.lda$class)

confusion(df2$Position, CVorig.lda$class)

# Overall accuracy: 0.8604
# Defender 0.8977
# Forward: 0.7981
# Midfielder: 0.8595

##########################
# Run LDA using 5 factors
##########################

# Get scores to do LDA

scores = as.data.frame(p$scores)

# Rename factors
names(scores) = c("Overall", "Defending", "SizeMovement", "Potential", "Physical")


# Add in categorical variables
scores$Preferred.Foot <- df2$Preferred.Foot
scores$Work.Rate <- df2$Work.Rate
scores$Body.Type <- df2$Body.Type
scores$Position <- df2$Position

# Run LDA
soccer.lda <- lda(Position ~ ., data=scores)

print(soccer.lda)

print(soccer.lda$scaling[order(soccer.lda$scaling[, 1]), ])
print(soccer.lda$scaling[order(soccer.lda$scaling[, 2]), ])

# Predict values on training
soccer.lda.values <- predict(soccer.lda)

# Group separations

ldahist(data=soccer.lda.values$x[,1], g=scores$Position)
ldahist(data=soccer.lda.values$x[,2], g=scores$Position)

# Plot the transformed data

par(mfrow=c(1,1))
plot(soccer.lda.values$x[,1], soccer.lda.values$x[, 2],
     col = scores$Position, pch=16)

LDA_Plot = ggplot(df, aes(x=soccer.lda.values$x[,1], 
                          y = soccer.lda.values$x[, 2])) + 
  geom_point(col=as.numeric(df2$Position)) +
  labs(title="LDA Plot", x="LD1", y="LD2") +
  theme(
    axis.title.x = element_text(size=16, margin=margin(t=8)),
    axis.title.y = element_text(size=16, margin=margin(r=8)),
    axis.text.x = element_text(size=14),
    axis.text.y = element_text(size=14),
    plot.title = element_text(size=20)
  )

LDA_Plot

# Compute confusion matrix on training set
table(scores$Position, soccer.lda.values$class)

# Compute confusion matrix
confusion(scores$Position, soccer.lda.values$class)

# Overall accuracy: 0.8098
# Defender: 0.8786
# Forward: 0.8119
# Midfielder: 0.7498

# Run CV LDA
set.seed(123)

soccerCV.lda <- lda(Position ~ ., data=scores, CV=TRUE)

table(scores$Position, soccerCV.lda$class)

confusion(scores$Position, soccerCV.lda$class)

# Overall accuracy: 0.8095
# Defender: 0.8786
# Forward: 0.8119
# Midfielder: 0.7490


