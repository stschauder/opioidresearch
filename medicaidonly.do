clear all
set more off

cd \\rschfs1x\userth\R-Z\sas648_TH\Documents\TEDS

use teds2003.dta


*the substance 1 variables
gen sub1heroin=0
replace sub1heroin=1 if SUB1==5

gen sub1methadone=0
replace sub1methadone=1 if SUB1==6

gen sub1other=0
replace sub1other=1 if SUB1==7

gen sub1anyopioid=sub1heroin+sub1methadone+sub1other



*the substance 2 variables
gen sub2heroin=0
replace sub2heroin=1 if SUB2==5

gen sub2methadone=0
replace sub2methadone=1 if SUB2==6

gen sub2other=0
replace sub2other=1 if SUB2==7

gen sub2anyopioid=sub2heroin+sub2methadone+sub2other


*the substance 3 variables
gen sub3heroin=0
replace sub3heroin=1 if SUB3==5

gen sub3methadone=0
replace sub3methadone=1 if SUB3==6

gen sub3other=0
replace sub3other=1 if SUB3==7

gen sub3anyopioid=sub1heroin+sub1methadone+sub1other

*Is heroin sub 1, 2, or 3?

gen heroin=0
replace heroin=1 if HERFLG==1

*Is non-perscription methadone sub 1, 2, or 3?

gen methadone=0
replace methadone=1 if METHFLG==1

*Is another opioid sub 1, 2, or 3?

gen otheropioid=0
replace otheropioid=1 if OPSYNFLG==1


*Diagnosed with opioid dependence
gen opioiddependence=0
replace opioiddependence=1 if DSMCRIT==5

*Diagnosed with opioid abuse
gen opioidabuse=0
replace opioidabuse=1 if DSMCRIT==12

*Has private insurance
gen insprivateins=0
replace insprivateins=1 if HLTHINS==1

*Has Medicaid
gen insmedicaid=0
replace insmedicaid=1 if HLTHINS==2

*Has Medicare
gen insmedicare=0
replace insmedicare=1 if HLTHINS==3

*Paid with private insurance
gen paidprivateins=0
replace paidprivateins=1 if HLTHINS==1

*Paid with Medicaid
gen paidmedicaid=0
replace paidmedicaid=1 if HLTHINS==2

*Paid with Medicare
gen paidmedicare=0
replace paidmedicare=1 if HLTHINS==3

drop if insmedicaid==0

collapse (mean) YEAR (sum) sub1heroin sub1methadone sub1other sub1anyopioid sub2heroin sub2methadone sub2other sub2anyopioid sub3heroin sub3methadone sub3other sub3anyopioid heroin methadone otheropioid opioiddependence opioidabuse insprivateins insmedicaid insmedicare paidprivateins paidmedicaid paidmedicare, by(STFIPS)

save TEDSmedicaiddata.dta 

clear 
set more off
forvalues y=2004/2014 {
use teds`y'.dta 

*the substance 1 variables
gen sub1heroin=0
replace sub1heroin=1 if SUB1==5

gen sub1methadone=0
replace sub1methadone=1 if SUB1==6

gen sub1other=0
replace sub1other=1 if SUB1==7

gen sub1anyopioid=sub1heroin+sub1methadone+sub1other



*the substance 2 variables
gen sub2heroin=0
replace sub2heroin=1 if SUB2==5

gen sub2methadone=0
replace sub2methadone=1 if SUB2==6

gen sub2other=0
replace sub2other=1 if SUB2==7

gen sub2anyopioid=sub2heroin+sub2methadone+sub2other


*the substance 3 variables
gen sub3heroin=0
replace sub3heroin=1 if SUB3==5

gen sub3methadone=0
replace sub3methadone=1 if SUB3==6

gen sub3other=0
replace sub3other=1 if SUB3==7

gen sub3anyopioid=sub1heroin+sub1methadone+sub1other

*Is heroin sub 1, 2, or 3?

gen heroin=0
replace heroin=1 if HERFLG==1

*Is non-perscription methadone sub 1, 2, or 3?

gen methadone=0
replace methadone=1 if METHFLG==1

*Is another opioid sub 1, 2, or 3?

gen otheropioid=0
replace otheropioid=1 if OPSYNFLG==1


*Diagnosed with opioid dependence
gen opioiddependence=0
replace opioiddependence=1 if DSMCRIT==5

*Diagnosed with opioid abuse
gen opioidabuse=0
replace opioidabuse=1 if DSMCRIT==12

*Has private insurance
gen insprivateins=0
replace insprivateins=1 if HLTHINS==1

*Has Medicaid
gen insmedicaid=0
replace insmedicaid=1 if HLTHINS==2

*Has Medicare
gen insmedicare=0
replace insmedicare=1 if HLTHINS==3

*Paid with private insurance
gen paidprivateins=0
replace paidprivateins=1 if HLTHINS==1

*Paid with Medicaid
gen paidmedicaid=0
replace paidmedicaid=1 if HLTHINS==2

*Paid with Medicare
gen paidmedicare=0
replace paidmedicare=1 if HLTHINS==3

drop if insmedicaid==0

collapse (mean) YEAR (sum) sub1heroin sub1methadone sub1other sub1anyopioid sub2heroin sub2methadone sub2other sub2anyopioid sub3heroin sub3methadone sub3other sub3anyopioid heroin methadone otheropioid opioiddependence opioidabuse insprivateins insmedicaid insmedicare paidprivateins paidmedicaid paidmedicare, by(STFIPS)

append using TEDSmedicaiddata.dta, 
save TEDSmedicaiddata.dta, replace 
}










































