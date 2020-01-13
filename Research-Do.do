

cd "/Users/Kantemirovs/Desktop/ECON 398"


do "2016 Individuals PUMF Stata EN Command File.do"


hist EMPIN, percent by (HDGREE)

mvdecode *, mv(99999999 = .a\ 88888888 = .b)
* decode missing values for quantitative variables
* 88,888,888 stands for not available. 99,999,999 stands for not applicable
*Converting numeric into string using the value labels

*Creating Dummy Variables for Degree
tabulate AGEGRP, gen(age)

*Creatin Dummy Variable for Degree- Select only those with degree in bachelor or more
tabulate HDGREE, gen(degree)
*drop non-available, non-applicable
drop degree14
drop degree15

gen highdegree=0
replace highdegree=1 if degree8
replace highdegree=1 if degree9 
replace highdegree=1 if degree10 
replace highdegree=1 if degree11 
replace highdegree=1 if degree12 
replace highdegree=1 if degree13 

*Drop age groups that are not in the range 20-59
drop if age1
drop if age2
drop if age3
drop if age4
drop if age5
drop if age6
drop if age7
drop if age16
drop if age17
drop if age18
drop if age19
drop if age20
drop if age22

*Dummys for weeks worked fulltime per year
tabulate FPTWK, gen(wwks)
gen wwks=0
replace wwks=1 if wwks1
drop if wwks3
drop if wwks4

*Dummy for High Income with specifications:
* higher than yearly avg. salary in CANADA and fulltime working
gen HINC=0
replace HINC=1 if EMPIN >= 50000 

*Define interaction coefficient
gen wwksdgree=0 

replace wwksdgree= 1 if HINC==1|highdegree==1

*Regress HINC with highdegree
regress HINC highdegree
*Regress HINC with wwks and highdegree with interaction term
regress HINC wwks highdegree wwksdgree
*Regression with Instrumental Variables
ivregress 2sls HINC wwks (highdegree=i.CIP2011)

*To see whether highdegree is actually an endogenous variable
estat endog
estat firststage
