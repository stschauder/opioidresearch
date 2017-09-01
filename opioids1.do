*this cleans the arcos and death data and define variables, corresponds to origenal opioids4

use "U:\Documents\opioids5.dta"
 
*creating a dummy variable for if the state expaned by 2014
gen estateid=0
replace estateid=1 if expand==1 & newyear==2014

 
*making morphine equivalent dosages (these are equilivalent to oral morphine)
gen med_hydromorphone=hydromorphone*4
gen med_oxymorphone=oxymorphone*3
gen med_oxycodone=oxycodone*1.5
gen med_codeine=codeine*.15
gen med_hydrocodone=hydrocodone
gen med_meperidine=mepreridine*.1

*generating the med_sum variable
gen med_sum=morphine+ med_hydromorphone+med_oxymorphone+med_oxycodone+med_codeine+med_hydrocodone+med_meperidine

*making insurance variables
gen unrate=Uninsured/total /*uninsurance rate*/
gen ratemed=InsuredMedicaid/total /*number of people on medicaid*/
gen perwhite=white/total /*percent white*/

*generating the key regressor
gen effect=unrate13*expand

*all opioid related deaths
gen opioidsum=deathsF111+deathsF119+deathsF191+deathsF192+deathsF199+deathsX42+deathsX62+deathsY12+deathsF112

*no suicides
gen opioidsum2=deathsF111+deathsF119+deathsF191+deathsF192+deathsF199+deathsX42+deathsY12+deathsF112

*no suicides or multiple drug causes
gen opioidsum3=deathsF111+deathsF119+deathsX42+deathsY12+deathsF112

*generating the per 100,000 variables
gen rp_fentanyl=(fentanyl/pop)*100000 
gen rp_tapentadol=(tapentadol/pop)*100000 
gen rp_sufentanil=(sufentanil/pop)*100000
gen rp_remifentanil=(remifentanil/pop)*100000 
gen rp_oxymorphone=(oxymorphone/pop)*100000 
gen rp_opium=(opium/pop)*100000
gen rp_morphine=(morphine/pop)*100000 
gen rp_methadone=(methadone/pop)*100000 
gen rp_mepreridine=(mepreridine/pop)*100000 
gen rp_hydrocodone=(hydrocodone/pop)*100000 
gen rp_hydromorphone=(hydromorphone/pop)*100000
gen rp_oxycodone=(oxycodone/pop)*100000 
gen rp_buprenorphine=(buprenorphine/pop)*100000 
gen rp_codeine=(codeine/pop)*100000 
gen rp_med_fentanyl=(med_fentanyl/pop)*100000 
gen rp_med_sum=(med_sum/pop)*100000 
gen rp_F111=(deathsF111/pop)*100000 
gen rp_F119=(deathsF119/pop)*100000 
gen rp_F191=(deathsF191/pop)*100000 
gen rp_F192=(deathsF192/pop)*100000 
gen rp_F199=(deathsF199/pop)*100000 
gen rp_Total=(deathsTotal/pop)*100000
gen rp_X42=(deathsX42/pop)*100000
gen rp_X62=(deathsX62/pop)*100000 
gen rp_Y12=(deathsY12/pop)*100000 
gen rp_F112=(deathsF112/pop)*100000 
gen rp_F152=(deathsF152/pop)*100000 
gen rp_opioidsum=(opioidsum/pop)*100000 
gen rp_opioidsum2=(opioidsum2/pop)*100000 
gen rp_opioidsum3=(opioidsum3/pop)*100000
gen rp_treat=(treat/pop)*100000

save "\\rschfs1x\userth\R-Z\sas648_TH\Documents\fulldata.dta", replace

use "\\rschfs1x\userth\R-Z\sas648_TH\Documents\fulldata.dta", clear

*Doing the event study

*Creating the relative time dummies for the event study

gen t_16=0
gen t_15=0
gen t_14=0
gen t_13=0
gen t_12=0
gen t_11=0
gen t_10=0
gen t_9=0
gen t_8=0
gen t_7=0
gen t_6=0
gen t_5=0
gen t_4=0
gen t_3=0
gen t_2=0
gen t0=0
gen t1=0

*2014 expanders

forvalues y=2003/2012{
local r=2014-`y'

replace t_`r' = 1 if namestate=="Arizona (04)" & newyear==`y'
replace t_`r' = 1 if namestate=="Arkansas (05)" & newyear==`y'
replace t_`r' = 1 if namestate=="California (06)" & newyear==`y'
replace t_`r' = 1 if namestate=="Colorado (08)" & newyear==`y'
replace t_`r' = 1 if namestate=="Connecticut (09)" & newyear==`y'
replace t_`r' = 1 if namestate=="D.C." & newyear==`y'
replace t_`r' = 1 if namestate=="Delaware (10)" & newyear==`y'
replace t_`r' = 1 if namestate=="Hawaii (15)" & newyear==`y'
replace t_`r' = 1 if namestate=="Illinois (17)" & newyear==`y'
replace t_`r' = 1 if namestate=="Iowa (19)" & newyear==`y'
replace t_`r' = 1 if namestate=="Kentucky (21)" & newyear==`y'
replace t_`r' = 1 if namestate=="Maryland (24)" & newyear==`y'
replace t_`r' = 1 if namestate=="Massachusetts (25)" & newyear==`y'
replace t_`r' = 1 if namestate=="Michigan (26)" & newyear==`y'
replace t_`r' = 1 if namestate=="Minnesota (27)" & newyear==`y'
replace t_`r' = 1 if namestate=="Nevada (32)" & newyear==`y'
replace t_`r' = 1 if namestate=="New Jersey (34)" & newyear==`y'
replace t_`r' = 1 if namestate=="New Mexico (35)" & newyear==`y'
replace t_`r' = 1 if namestate=="New York (36)" & newyear==`y'
replace t_`r' = 1 if namestate=="North Dakota (38)" & newyear==`y'
replace t_`r' = 1 if namestate=="Ohio (39)" & newyear==`y'
replace t_`r' = 1 if namestate=="Oregon (41)" & newyear==`y'
replace t_`r' = 1 if namestate=="Rhode Island (44)" & newyear==`y'
replace t_`r' = 1 if namestate=="Vermont (50)" & newyear==`y'
replace t_`r' = 1 if namestate=="Washington (53)" & newyear==`y'
replace t_`r' = 1 if namestate=="West Virginia (54)" & newyear==`y' 

}

forvalues y=2014/2015{
local r=`y'-2014

replace t`r' = 1 if namestate=="Arizona (04)" & newyear==`y'
replace t`r' = 1 if namestate=="Arkansas (05)" & newyear==`y'
replace t`r' = 1 if namestate=="California (06)" & newyear==`y'
replace t`r' = 1 if namestate=="Colorado (08)" & newyear==`y'
replace t`r' = 1 if namestate=="Connecticut (09)" & newyear==`y'
replace t`r' = 1 if namestate=="D.C.(11)" & newyear==`y'
replace t`r' = 1 if namestate=="Delaware (10)" & newyear==`y'
replace t`r' = 1 if namestate=="Hawaii (15)" & newyear==`y'
replace t`r' = 1 if namestate=="Illinois (17)" & newyear==`y'
replace t`r' = 1 if namestate=="Iowa (19)" & newyear==`y'
replace t`r' = 1 if namestate=="Kentucky (21)" & newyear==`y'
replace t`r' = 1 if namestate=="Maryland (24)" & newyear==`y'
replace t`r' = 1 if namestate=="Massachusetts (25)" & newyear==`y'
replace t`r' = 1 if namestate=="Michigan (26)" & newyear==`y'
replace t`r' = 1 if namestate=="Minnesota (27)" & newyear==`y'
replace t`r' = 1 if namestate=="Nevada (32)" & newyear==`y'
replace t`r' = 1 if namestate=="New Jersey (34)" & newyear==`y'
replace t`r' = 1 if namestate=="New Mexico (35)" & newyear==`y'
replace t`r' = 1 if namestate=="New York (36)" & newyear==`y'
replace t`r' = 1 if namestate=="North Dakota (38)" & newyear==`y'
replace t`r' = 1 if namestate=="Ohio (39)" & newyear==`y'
replace t`r' = 1 if namestate=="Oregon (41)" & newyear==`y'
replace t`r' = 1 if namestate=="Rhode Island (44)" & newyear==`y'
replace t`r' = 1 if namestate=="Vermont (50)" & newyear==`y'
replace t`r' = 1 if namestate=="Washington (53)" & newyear==`y'
replace t`r' = 1 if namestate=="West Virginia (54)" & newyear==`y' 

}

*2015 expanders

forvalues y=2003/2013{
local r=2015-`y'

replace t_`r' = 1 if namestate=="Indiana (18)" & newyear==`y'
replace t_`r' = 1 if namestate=="Pennsylvania (42)" & newyear==`y'
replace t_`r' = 1 if namestate=="New Hampshire (33)" & newyear==`y'
}

forvalues y=2015/2015{
local r=`y'-2015

replace t`r' = 1 if namestate=="Indiana (18)" & newyear==`y'
replace t`r' = 1 if namestate=="Pennsylvania (42)" & newyear==`y'
replace t`r' = 1 if namestate=="New Hampshire (33)" & newyear==`y'
}

save "\\rschfs1x\userth\R-Z\sas648_TH\Documents\fulldata.dta", replace











