# FIFA 2019 Position Prediction Project Overview
* Created a linear discrimnant analysis (LDA) model that predicts player position (forward, midfielder, defender) with a cross-validated accuracy of 81%.
* Model can be used to assist club managers in determining what position best suits a player.
* Used principal component analysis (PCA) and factor analysis to reduce dimensionality and explore relationships between predictor variables.
* Identified five factors among numeric variables (overall, defending ability, size/movement, potential, and physical ability).
* As expected, the classifier had greater difficulty distinguishing between the midifielder and forward positions and the midfielder and defender positions, indicating greater overlap between midfielder and the other two positions.
* Club managers could potentially examine their midfield players' stats on the five factors to identify players that are more likely to be successful as a forward or defender, if those positions needed to be filled.

## Code and Resources Used
**Packages:** rgl, MASS, psych, corrplot, moments, ggplot2, numpy, pandas

## Data Cleaning
Cleaned 18,207 rows and 88 columns:
* Dropped index/irrelevant columns (e.g., club logo, jersey number, flag, etc.)
* Removed goal keeper rows and variables because dataset was disjoint
* Parsed money value and converted to consistent format
* Removed missing position variables
* Parsed height value and converted to inches
* Parsed weight value
* Binned position variable to forward, midfielder, and defender
* Manually inputted missing/special body type values
* Converted skill rating to single number

## Exploratory Data Analysis
* Examined correlations between each of the independent variables to determine if any were highly correlated with almost all variables or uncorrelated with all variables.
* Linear models of the skill variables indicated that the remaining variables accounted for over 99% of the variance in each of these models. These variables were subsequently removed.
* Below is a correlation plot with remaining numeric variables.

![alt text](https://github.com/chelseako/FIFA_2019_Project/blob/main/FIFACorrplot.png)

## Model Building
* Used the skewness function from the moments package to examine whether the independent variables were normally distributed.
* Wage and value were highly negatively skewed and were subsequently transformed by taking the log + 1.
* Conducted PCA and used the knee method, variance = 1 criteria, and parallel analysis to aid in determining an appropriate number of factors.
* Conducted principal factor analysis using 4, 5, and 6 factors and determined 5 factors produced the most interpretable results. Common factor analysis largely confirmed the variable loadings obtained using principal factor analysis.

The five factors included:
* Overall
* Defending ability
* Inverse relationship between size and movement
* Potential
* Physical ability

Used the scores for each row obtained from the engineered features and combined with the three categorical independent variables and categorical dependent variable to create a new dataset.
Conducted cross-validated LDA on the new dataset.

## Model Performance
The model performed best in discriminating the defender and forward positions but had greater difficulty differntiating the midfielder position from defender and forward.

**Overall Accuracy:** 80.95%
**Defender:** 87.86%
**Forward:** 81.19%
**Midfielder:** 74.90%

The 3D image below shows the separation of positions in the first three components.

![alt text](https://github.com/chelseako/FIFA_2019_Project/blob/main/3Dplot.png)

## Discussion
The LDA model built using the full dataset without the engineered PCA features had an overall accuracy of 86.04%, with approximately 11% higher accuracy for the midfielder position but approximately 1-2% lower accuracy for the defender and forward positions.  However, the full dataset had 66 numeric variables, and the decreased accuracy is worth the improved interpretability and parsimony of the model.


