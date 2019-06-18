### testing raters R package for professor Peter Goos
### basics
install.packages("raters")
library(raters)
data(winetable)
winetable #Wine data
# rows are different bottles
# columns are bitterness levels
# each entry is how many raters gave that bitternes rating?
# there are 9 raters for every bottle
# I do not know if it is required to have the same number of raters for this package to work
set.seed(12345) #RNG reproducability
test1 = wlin.conc(winetable,test="MC")
test1
# MC is the best for small datasets
# I do not understand what "min" is in the result.

set.seed(12345)
test2 = wlin.conc(winetable,test="Default")
test2
# Default is a normal approximation I presume, not fully specified in documentation
# would be a good approximation if you have many bottles of wine
# Why doesnt this give a p-value?

set.seed(12345)
test3 = wlin.conc(winetable,test="Chisq")
test3
# In the documentation they also speak of a Chisq approximation, but I can not get this to work for ordinal data.
# I've looked at the source code and can't find any Chisq for ordinal data.
# the chisq approximation would work if you have many raters.

test4 = wquad.conc(winetable,test="MC") # a different test that uses quadratic weights
test4

### some more detailed options
# use more Monte carlo samples by increasing B, default is 1000
set.seed(12345) 
test5 = wlin.conc(winetable,test="MC",B = 10000)
test5
set.seed(12345) 
test6 = wlin.conc(winetable,test="MC",B = 100000) # UCL seems to chagne slightly 
test6
set.seed(12345) 
test7 = wlin.conc(winetable,test="MC",B = 10) # Watch out with a small sample
test7

# change confidence level
set.seed(12345) 
test8 = wlin.conc(winetable,test="MC",alpha = 0.0001) #wider confidence interval
test8


### additional example
data(uterine)
set.seed(12345)
wquad.conc(uterine,test="MC",B=1000) #this dataset is quite large so smaller sample suffices, or use normal approx.
set.seed(12345)
wquad.conc(as.data.frame(uterine),test="MC",B=1000) # make sure data frame and data table work the same
set.seed(12345)
wquad.conc(uterine,test="Default")
# general remark: they don't give any examples with non significant results?

