/*_//_//_//_//_//_//_//_//_//_//_//_//
  WINTER 2022
    PP291A: Tools for Causal Inference 
     == PS#1 Part#4 ==
//_//_//_//_//_//_//_//_//_//_//_//_*/

clear all
cap log close
set more off

cd "C:\Users\rabe8\OneDrive\ドキュメント\留学全般\16. Winter 2022\PP291A - Tools for Causal Inference\PS-1"

import delimited "OlkenData.csv"
browse
misstable sum

gen Treatment = "Treated" if treat_invite == 1
replace Treatment = "Control" if  treat_invite == 0

encode Treatment, gen(D)

// Q1
iebaltab head_edu mosques pct_poor total_budget, ///
	grpvar(D) nott save("balancetable.xlsx") replace

// Q2
eststo: reg pct_missing treat_invite
esttab, nobase label cells("b(fmt(4) star) ci(par fmt(4))") wide

// Q3
eststo: anova pct_missing treat_invite c.head_edu c.mosques c.pct_poor c.total_budget
reg
esttab, nobase label cells("b(fmt(4) star) ci(par fmt(4))") wide
