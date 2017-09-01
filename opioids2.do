*this do file cleans the Teds data, addapted from TEDS2

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

use TEDS2data.dta, clear

gen namestate="name"

replace namestate="Alabama (01)" if STFIPS == 1
replace namestate="Alaska (02)" if STFIPS == 2
replace namestate="Arizona (04)" if STFIPS == 4
replace namestate="Arkansas (05)" if STFIPS == 5
replace namestate="California (06)" if STFIPS == 6
replace namestate="Colorado (08)" if STFIPS == 8
replace namestate="Connecticut (09)" if STFIPS == 9
replace namestate="D.C.(11)" if STFIPS == 11
replace namestate="Delaware (10)" if STFIPS == 10
replace namestate="Florida (12)" if STFIPS == 12 
replace namestate="Georgia (13)" if STFIPS == 13
replace namestate="Hawaii (15)" if STFIPS == 15
replace namestate="Idaho (16)" if STFIPS == 16
replace namestate="Illinois (17)" if STFIPS == 17
replace namestate="Indiana (18)" if STFIPS == 18
replace namestate="Iowa (19)" if STFIPS == 19
replace namestate="Kansas (20)" if STFIPS == 20
replace namestate="Kentucky (21)" if STFIPS == 21
replace namestate="Louisiana (22)" if STFIPS == 22
replace namestate="Maine (23)" if STFIPS == 23
replace namestate="Maryland (24)" if STFIPS == 24
replace namestate="Massachusetts (25)" if STFIPS == 25
replace namestate="Michigan (26)" if STFIPS == 26
replace namestate="Minnesota (27)" if STFIPS == 27
replace namestate="Mississippi (28)" if STFIPS == 28
replace namestate="Missouri (29)" if STFIPS == 29
replace namestate="Montana (30)" if STFIPS == 30
replace namestate="Nebraska (31)" if STFIPS == 31
replace namestate="Nevada (32)" if STFIPS == 32
replace namestate="New Hampshire (33)" if STFIPS == 33
replace namestate="New Jersey (34)" if STFIPS == 34
replace namestate="New Mexico (35)" if STFIPS == 35
replace namestate="New York (36)" if STFIPS == 36
replace namestate="North Carolina (37)" if STFIPS == 37
replace namestate="North Dakota (38)" if STFIPS == 38
replace namestate="Ohio (39)" if STFIPS == 39
replace namestate="Oklahoma (40)" if STFIPS == 40
replace namestate="Oregon (41)" if STFIPS == 41
replace namestate="Pennsylvania (42)" if STFIPS == 42
replace namestate="Rhode Island (44)" if STFIPS == 44
replace namestate="South Carolina (45)" if STFIPS == 45
replace namestate="South Dakota (46)" if STFIPS == 46
replace namestate="Tennessee (47)" if STFIPS == 47
replace namestate="Texas (48)" if STFIPS == 48
replace namestate="Utah (49)" if STFIPS == 49
replace namestate="Vermont (50)" if STFIPS == 50
replace namestate="Virginia (51)" if STFIPS == 51
replace namestate="Washington (53)" if STFIPS == 53
replace namestate="West Virginia (54)" if STFIPS == 54
replace namestate="Wisconsin (55)" if STFIPS == 55
replace namestate="Wyoming (56)" if STFIPS == 56

drop if STFIPS==72

gen primarytreatopioid=sub1methadone+sub1other

save TEDS2data.dta, replace


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

append using TEDS2data.dta, 
save TEDS2data.dta, replace 
}
