/*_//_//_//_//_//_//_//_//_//_//_//_//
  WINTER 2022
    PP291A: Tools for Causal Inference 
     == PS#1 part#3 ==
//_//_//_//_//_//_//_//_//_//_//_//_*/

clear all
cap log close
set more off

cd "C:\Users\rabe8\OneDrive\ドキュメント\留学全般\16. Winter 2022\PP291A - Tools for Causal Inference\Week-4"

import delimited "ggl-sample-500cl.csv"
browse
misstable sum

gen female = (sex == "female")
gen p2004_int = (p2004 == "Yes")

encode treatment, gen(D)

// collapse to the hh-level:
collapse (mean) avg_yob=yob pr_p2004=p2004_int pr_female=female pr_voted=voted_ind ///
    (count) hh_size=hh_size ///
    (firstnm) treatment=treatment, by(hh_id)

rename hh_size household_size
rename pr_female female_proportion
rename avg_yob average_year_of_bitrh
rename pr_p2004 August_2004_vote
	
* Encode the treatment variable:
encode treatment, gen(D)

// Question #1 //
* Balance Table
iebaltab household_size female_proportion average_year_of_bitrh August_2004_vote, ///
    grpvar(D) control(2) nott onerow save("balancetable.xlsx") replace

// Question #2 //
clear all
import delimited "ggl-sample-500cl.csv"
tab treatment, sum(voted_ind)

// Question #3,4 //
clear all
import delimited "ggl-sample-500cl.csv"
encode treatment, gen(D)

// OSL
eststo: regress voted_ind ib2.D, vce(cl hh_id)

// FE Model
xtset cluster
eststo: xtreg voted_ind ib2.D, fe
esttab, nobase label

// Question 5 //
clear all
import delimited "ggl-sample-500cl.csv"
encode treatment, gen(D)

gen female = (sex == "female")
gen p2004_int = (p2004 == "Yes")

// OSL
eststo: regress voted_ind ib2.D, vce(cl hh_id)

// FE Model
xtset cluster
eststo: xtreg voted_ind ib2.D, fe
esttab, nobase label

// ANCOVA - Using the pre-treatment covariates as controls
eststo: anova voted_ind ib2.D c.hh_id c.female c.yob c.p2004_int
reg
esttab, nobase label cell(b(fmt(4) star) se(par fmt(4)))
