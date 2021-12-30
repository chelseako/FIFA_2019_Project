# FIFA 2019 Position Prediction Project Overview
* Created a linear discrimnant analysis model that predicts player position (forward, midfielder, defender) with 81% cross-validated accuracy.
* Used principal component analysis and factor analysis to reduce dimensionality and explore variable factoring
* Identified five factors among numeric variables (overall, defending ability, size and movement, potential, and physical ability)

## Packages Used
* rgl
* MASS
* psych
* corrplot
* moments
* ggplot2
* numpy
* pandas

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

