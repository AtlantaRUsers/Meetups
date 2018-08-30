# R Basic Operations (Shorter Version)
#
# Matthew D. Turner
# mturner46@gsu.edu
# Georgia State University
#
# Presented to the R Users Group/R Meetup Atlanta August 28, 2018.
#
# 2018.02.25 
# Revised: 2018.08.24

# NOTES:
#
# This is the shorted version of the file that I will use for the
# actual presentation. The longer version has extra material in it
# that will not be presented.
#
# This is a file derived from an introductory meeting of the the GSU R
# users group. We had been asked by students to present some really
# basic operations in R, and this was the result. It is a somewhat
# random assortment of things people want to do in R, but it is not
# covering any particular topic or idea. It uses some basic linear
# models as examples.



## 1: Installing and Attaching Libraries
#
# When adding new features to R - INSTALL (function: install.packages)
# When USING new features in R - ATTACH (function: library or require)
#
# ONLY INSTALL PACKAGES ONCE
#
# Example install: the TIDYverse -- a set of tools that basically
# completely remakes R into a new system!

#install.packages("tidyverse")

# Loading packages for use:

library(ggplot2)    # This is what you should usually do
require(MASS)       # Used inside of packages (you see it sometimes)

#    you do not have the ggplot2 library installed, you can install it
#    with:
#
#    install.packages("ggplot2")



## 2: Data Frames
#
# Data frames are spreadsheet-like data storage. You do a lot without
# them, but basically **all** of your primary data will live in them!
# In the examples here we will use the built-in data set 'mpg'. You
# can see details by typing ?ggplot2::mpg

data(mpg)   # Set up data to use
head(mpg)   # Since we loaded ggplot2, our data frames are called *tibbles* now
dim(mpg)    # Rows and columns of data frame
names(mpg)  # Variable names
str(mpg)    # Review of the data structure (with types)

summary(mpg)     # Summary statistics for the variables

# Note that the summary function does not work as well with the
# "tidyverse" packages loaded (via ggplot2). I am not sure why this is
# the case. But with different (or no) packages loaded it works better
# with string or character variables.
#
# Selecting Variables
# 
# Picking out variables, that is columns of data, is done with the
# dollar sign ($) operator. The order is data_frame_name$column_name,
# so for our example:

mpg$hwy    # The highway milage of our cars

# Tables are good for summarizing categorical variables and work with
# tidyverse's tibbles:

table(mpg$cyl)
table(mpg$model)

# An the usual math/stats functions:

mean(mpg$cty)
sd(mpg$cty)
median(mpg$cty)   # and so on...

# In R, factors (categorical or ordinal variables) are treated more
# intelligently than character variables, so we will tell R to treat
# some of the character variables as factors. This uses the factor
# function (the arrow -> is the assignment operator, you can also use
# the equals sign = if you prefer):

mpg2 <- mpg
mpg2$manufacturer <- factor(mpg2$manufacturer) # Tell R manufacturer is a factor

# Compare the manufacturer variable in these outputs:

summary(mpg2)  # R is much smarter with the factor than the string!
summary(mpg)

# Let's do a t-test on hwy versus cty MPG
# 
# To do this we will need to do some arithmetic on variables/columns 
# of the data frame. The usual arithmetic operations work columnwise.

mpgdiff <- mpg$hwy - mpg$cty  # Get all the 234 differences
print(mpgdiff)
t.test(x = mpgdiff, conf.level = 0.99)  # One sample t-test

# Here is how to do it as a paired t-test directly on the original
# data:

t.test(x = mpg$hwy, y = mpg$cty, conf.level = 0.99, paired = TRUE)

# Compare the output from the two versions of the t-test above. Note
# that all of the usual requirements of a t-test are there.

?t.test   # for more info and for settings to change things



## 3: Some quick exploratory plots (Always look at your data!)
#
# Displacement versus highway MPG (w/scatterplot smoother)

plot(mpg$displ, mpg$hwy, pch = 16, col = "blue")         # Scatterplot

# You can add lines to plots with several commands, the simplest one
# is lines; it takes a list of x and y coordinates. The lowess command
# produces these are a result:

lines(lowess(mpg$displ, mpg$hwy), lwd = 3, col = "red")

# There are a variety of scatterplot smoothers available, LOESS (LOcal
# regrESSion) and lowess (LOcally WEighted Scatterplot Smoothing)
# being the two most popular. They vary in terms of their features and
# options and in the amount of work you have to do to use them.

# Highway MPG versus city MPG (w/regression line)
#
# R has a simple language for regression (and related) models. See the
# handout included in the repo and the slides.

plot(mpg$cty, mpg$hwy, pch = 16, col = "blue")

fit1 <- lm(hwy ~ cty, data = mpg)              # Fit a regression
abline(fit1, lwd = 3, col = "red")             # Draw regression line

# The abline function is smart and knows how to use a model to draw a
# line.



## 4: Using Indices (Easy Examples)
#
# Indexing is complicated, but powerful! It uses the **square**
# brackets. In R, **round** brackets are for functions and square
# brackets are for indexing.

head(mpg)

mpg[1,1]   # First row (item/subject/whatever) and first variable
mpg[1,]    # First row, all variables (compare with matlab's :)
mpg[,1]    # ALL rows, first variable (similar to using $)

# Note that R won't show us all the lines. See the longer form of this
# file for (1) a hack to see them, and (2) a discussion of types and 
# polymorphism in R

mpg[1:10,] # Data for first 10 "subjects" (here cars)

table(mpg$manufacturer)   # How many Audis? 

# Can we grab all of the Audis?

audimpg <- mpg[mpg$manufacturer == "audi",]  # == means "is equal to"
audimpg

# R allows logical indexing -- if you make a list of TRUE/FALSE values
# then pass this as an index to a data frame (or tibble) it returns
# the ones where it is true. Let's look at that more closely:

mpg$manufacturer == "audi"

# What we did was this, but all in one step:

temporaryVariable <- mpg$manufacturer == "audi" # Get T for Audi
newVersion <- mpg[temporaryVariable,]           # Stick these into row indices

# More ways of picking out variables:

audimpg[,5]          # List the 5th column/variable
audimpg[,"cyl"]      # List all the values of column "cyl" (by name!)
audimpg[,c("hwy","cyl")]  # Pick out two columns



## 5: An example of all of this!
#
# Get the model, highway, and city mileage from mpg for ford cars and
# put this into a new data frame.

ford_mileage <- mpg[mpg$manufacturer == "ford", c("model", "hwy", "cty")]
ford_mileage

# People often use the "attach" function to make a data frame part of
# the environment (?attach for more). This is generally considered a
# bad habit by R experts. Rather than using attach() use with() which
# wraps up a data frame with some commands in a local environment.
#
# Some plots:

with(audimpg, plot(cyl, hwy, pch = 16))
with(audimpg, plot(factor(cyl), hwy))    # Force R to treat cyl as factor

# Note that R is smart enough to recognize that a boxplot is better
# for data that appears to be in groups, in this case the levels of
# cylinders (4, 6, 8).
#
# Compare the use of with() to how we would have done the first plot
# previously:

plot(audimpg$cyl, audimpg$hwy)

# The with() function wraps up the data frame you want to use with the
# commands to be executed. This is useful for many R functions that do
# not have other ways to do this.



# 7: Importing CSV Data and Basic Stats
#
# Here is a data set on treatment for stress. It is from a designed
# (factorial) experiment. There are 3 treatments, evenly divided by
# gender (30 women and 30 men), and their stress reduction score.

stressdata <- read.csv('dataset_twoway_with_interactions.csv')

plot(stressdata)               # Quick working plot of correlations
summary(stressdata)
levels(stressdata$Treatment)   # List the levels of treatment

with(stressdata, plot(Treatment, StressReduction))  # Quick boxplots
with(stressdata, plot(Gender, StressReduction))

# This is a factor plot, used in psychology to show how relationships
# change for different levels of factors:

with(stressdata,
     interaction.plot(Treatment, Gender, StressReduction, lwd = 3))

# Finally, let's do an ANOVA. This first one models treatment type and
# gender. Each is a main effect.

fit2 <- aov(StressReduction ~ Treatment + Gender, data = stressdata)

fit2             # Printing the model tells you little
summary(fit2)    # This is the actual output most people want

# This version has the same main effects but adds the interaction. 
# Given the interaction plot this is essential for this data! This 
# can be seen in the significance of the interaction term.

fit3 <- aov(StressReduction ~ Treatment + Gender + Treatment:Gender,
            data = stressdata)

summary(fit3)

# In R, functions are polymorphic, that is, they do different things
# when given different sorts of inputs. Look at summary() and plot()
# above. (Also, try doing plot on a linear model or ANOVA result--
# make sure to look in the "console" window, as you will have to press
# the enter/return key a few times.)

plot(fit3)   # This works better for regression than for ANOVA's



# 8. Regression Example
#
# ANOVA is for binary or multi-level independent variables, while
# regression is for contiunuous independent (or predictor) variables.
# In reality, they are really the same machinery underneath, but they
# are rarely taught that way in intro statistics classes. For
# completeness, we will show a regression example here.
#
# NOTE: If you do a lot with designed experiments or standard
# regression, the car library is a good one to have available!

library(car)     # The data lives in this library

data(Prestige)
head(Prestige)

# Prestige variable: Pineo-Porter prestige score for occupation, from
# a social survey conducted in the **mid-1960's**.
#
# Demographic information was collected about the professions that
# were rated for prestige, and they include:
# 
#   + Level of income for each job (1960's dollars; median family income $6,900)
#   + Percentage of women in the job
#   + Education required for each job
#   + Job type: blue collar (bc), white collar (wc), and professional (p)

# More information about this dataset can be found by typing in
# prestige into the "help" bar.
#
# We can pick out just the variables we want:

np <- Prestige[,c(1:4)]  

head(np)
summary(np)
plot(np, pch = 16, col = "blue")

# Centering predictors is valuable for improving interpretation. This
# will make discussing the regression intercept easier. We can do this
# either as simple math or using the scale function. We can directly
# make new variables right in the data frame.

np$education.c <- scale(np$education, center = TRUE, scale = FALSE)
np$prestige.c  <- scale(np$prestige,  center = TRUE, scale = FALSE)
np$women.c     <- scale(np$women,     center = TRUE, scale = FALSE)

summary(np)

# To fit the linear model, we just use the notation language (see
# slides/handout). Traditionally regression focuses on "main effects"
# so we do not include interaction terms. But these terms are actually
# available if you want to go deeper (this falls under names like
# analysis of covariance, etc.)
#
# Here we model income as a function of the others:

m1 <- lm(income ~ education.c + prestige.c + women.c, data = np)
summary(m1)

# As the average education level in a profession does not seem
# significant we can make the model without this term and take a look:

m2 = lm(income ~ prestige.c + women.c, data = np)
summary(m2)

# So for each unit increase in (centered) prestige score, there is an
# increase in income of 165 dollars (USD for year 1965, or so).
# Similarly, as the percentage of women in a career is reduced, the
# income goes up. (Obviously, we are not reading this causally here!)
#
# The intercept of $6797 tells us the average income for a career with
# the average number of years of education, and the average percent of
# women in the job. (Centering allows us to talk like this -- without
# doing that we would have a harder time discussing intercepts.)
#
# Some people want the "ANOVA Table" for a regression problem, this
# can be obtained by:

anova(m2)

# To do a model comparison you can ask the anova function to compare
# the models (in this case there is no significant difference, as we
# might expect):

anova(m1,m2)

# EOF