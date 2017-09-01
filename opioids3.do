*this data set combines TEDS2 with the rest of the data

cd \\rschfs1x\userth\R-Z\sas648_TH\Documents\TEDS
use fulldata.dta, clear
sort namestate
gen year=string(newyear)
gen id=namestate+year
save cleandata.dta, replace

use TEDS2data.dta
sort namestate
gen year=string(YEAR)
gen id=namestate+year
save TEDS2data.dta, replace

merge id using cleandata.dta

drop Insured children nohighschool highschool somecollege somecollege college PI TMR med_hydromorphone med_oxymorphone med_oxycodone med_codeine med_hydrocodone med_meperidine med_methadone med_sum med_fentanyl med_sum unrate ratemed perwhite unrate13 effect deathsF111 deathsF119 deathsF191 deathsF192 deathsF199 deathsTotal deathsX42 deathsX62 deathsY12 deathsF112 deathsF152 r_fentanyl r_tapentadol r_sufentanil r_remifentanil r_oxymorphone r_morphine r_opium r_methadone r_mepreridine r_hydrocodone r_hydromorphone r_oxycodone r_buprenorphine r_med_fentanyl r_codeine r_med_sum r_med_sum r_F111 r_F119 r_F191 r_F192 r_F199 r_Total r_X42 r_Y12 r_F112 r_F152 r_opioidsum r_opioidsum2 r_opioidsum3

*creating a variable expand2 which marks the percentage of the expansion that has occured

gen expand2=expand
replace expand2=(4/12) if newyear==2015 & namestate=="Alaska (02)"
replace expand2=(11/12) if newyear==2015 & namestate=="Indiana (18)"
replace expand2=(9/12) if newyear==2014 & namestate=="Michigan (26)"
replace expand2=(5/12) if newyear==2014 & namestate=="New Hampshire (33)"

gen primarytreatopioid=sub1methadone+sub1other
replace primarytreatopioid=treat if newyear==2015

merge id using mergin.dta
gen effect=unrate13*expand2

save cleandata.dta, replace

drop if newyear==1999
drop if newyear==2000
drop if newyear==2001
drop if newyear==2002
drop if newstateid==. /*This gets rid of 2016 observations as well*/

gen rp_sub1heroin=(sub1heroin/pop)*100000
gen rp_sub1methadone=(sub1methadone/pop)*100000
gen rp_sub1other =(sub1other /pop)*100000
gen rp_sub1anyopioid =(sub1anyopioid /pop)*100000
gen rp_heroin=(heroin/pop)*100000
gen rp_otheropioid=(otheropioid/pop)*100000
gen rp_opioiddependence=(opioiddependence/pop)*100000
gen rp_opioidabuse=(opioidabuse/pop)*100000
gen rp_insprivateins=(insprivateins/pop)*100000
gen rp_insmedicaid=(insmedicaid/pop)*100000
gen rp_insmedicare=(insmedicare/pop)*100000
gen rp_primarytreatopioid=(primarytreatopioid/pop)*100000

*generating an idicator for if the state expanded in either 2014 or 2015
gen everexpand=0
replace everexpand = 1 if namestate=="Arizona (04)" 
replace everexpand = 1 if namestate=="Arkansas (05)" 
replace everexpand = 1 if namestate=="California (06)" 
replace everexpand = 1 if namestate=="Colorado (08)" 
replace everexpand = 1 if namestate=="Connecticut (09)" 
replace everexpand = 1 if namestate=="D.C.(11)" 
replace everexpand = 1 if namestate=="Delaware (10)" 
replace everexpand = 1 if namestate=="Hawaii (15)" 
replace everexpand = 1 if namestate=="Illinois (17)" 
replace everexpand = 1 if namestate=="Iowa (19)" 
replace everexpand = 1 if namestate=="Kentucky (21)"
replace everexpand = 1 if namestate=="Maryland (24)" 
replace everexpand = 1 if namestate=="Massachusetts (25)" 
replace everexpand = 1 if namestate=="Michigan (26)" 
replace everexpand = 1 if namestate=="Minnesota (27)" 
replace everexpand = 1 if namestate=="Nevada (32)" 
replace everexpand = 1 if namestate=="New Jersey (34)" 
replace everexpand = 1 if namestate=="New Mexico (35)" 
replace everexpand = 1 if namestate=="New York (36)" 
replace everexpand = 1 if namestate=="North Dakota (38)" 
replace everexpand = 1 if namestate=="Ohio (39)" 
replace everexpand = 1 if namestate=="Oregon (41)" 
replace everexpand = 1 if namestate=="Rhode Island (44)" 
replace everexpand = 1 if namestate=="Vermont (50)" 
replace everexpand = 1 if namestate=="Washington (53)" 
replace everexpand = 1 if namestate=="West Virginia (54)" 
replace everexpand = 1 if namestate=="Indiana (18)" 
replace everexpand = 1 if namestate=="Pennsylvania (42)" 
replace everexpand = 1 if namestate=="New Hampshire (33)"

gen post=0
replace post=1 if newyear==2014 | newyear==2015

gen unpost=unrate13*post


save cleandata2.dta, replace

*a good command for graphs
xtset newstateid newyear
xtline sub1anyopioid, overlay


*should I control for ratemed
*regreasions
xtreg rp_opioidsum effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
xtreg rp_Total effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_buprenorphine effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_oxycodone effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_med_sum effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_med_fentanyl effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)



*regression equations
use cleandata.dta, clear
reg rp_opioidsum effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_Total effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_buprenorphine effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_oxycodone effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_med_sum effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)
reg rp_med_fentanyl effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed st* y*, vce(cluster newstateid)


xtreg rp_opioidsum effect,fe
reg rp_opioidsum effect i.newyear i.newstateid


/*Event studies:  rp signifies rate per 100,000*/

gen t_12un=t_12*unrate13
gen t_11un=t_11*unrate13
gen t_10un=t_10*unrate13
gen t_9un=t_9*unrate13
gen t_8un=t_8*unrate13
gen t_7un=t_7*unrate13
gen t_6un=t_6*unrate13
gen t_5un=t_5*unrate13
gen t_4un=t_4*unrate13
gen t_3un=t_3*unrate13
gen t_2un=t_2*unrate13
gen t0un=t0*unrate13
gen t1un=t1*unrate13


*ARCOS variables: Buprenorphine Sold, Methadone Sold, Oxycodone Sold, Total Opioids Sold, Fentanyl Sold
foreach var in  {

quietly reg `var' i.newyear t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un
test t_7un t_6un t_5un t_4un t_3un t_2un 

	}rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl

*death data variables: rp_opioidsum is the sum of all opioid related deaths, rp_Total is the total overdose deaths
*Opioid Related Deaths, Total Overdose Deaths

foreach var in rp_opioidsum rp_Total {

quietly reg `var' i.newyear t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un
test t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un 

}

*treatment admissions variables: rp_sub1methadone rp_sub1other rp_sub1anyopioid rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare
*Opioid Treatment Admission, Opioid dependence, Opioid Abuse, Treated with Private Insurance, Treated with Medicaid, Treated with Medicare
foreach var in rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare {

quietly reg `var' i.newyear t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un
test t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un 

}


*Creating nice figures

xtgraph rp_buprenorphine, group(everexpand)
xtgraph rp_methadone, group(everexpand)
xtgraph rp_oxycodone, group(everexpand)
xtgraph rp_med_sum, group(everexpand)
xtgraph rp_fentanyl, group(everexpand)
xtgraph rp_opioidsum, group(everexpand)
xtgraph rp_Total, group(everexpand)
xtgraph rp_primarytreatopioid, group(everexpand)
xtgraph rp_opioiddependence, group(everexpand)
xtgraph rp_opioidabuse, group(everexpand)
xtgraph rp_insprivateins, group(everexpand)
xtgraph rp_insmedicaid, group(everexpand)
xtgraph rp_insmedicare, group(everexpand)





*Things to ask John about
*am I interpreting the F test correctly, what do I do about the event studies for the variables that did not pass?
*try with negative numbers

*ARCOS Data
matrix coeffs = J(9,5,.)
matrix CIl = J(9,5,.)
matrix CIu = J(9,5,.)

local ii = 0
foreach var in rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl {
	local ii = `ii' + 1
	quietly reg `var' i.newyear t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-7/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a'un]
			matrix CIl[`kk',`ii'] = _b[t_`a'un] - invt(e(df_r),.975)*_se[t_`a'un]
			matrix CIu[`kk',`ii'] = _b[t_`a'un] + invt(e(df_r),.975)*_se[t_`a'un]
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime'un]
		matrix CIl[`kk',`ii'] = _b[t`abstime'un] - invt(e(df_r),.975)*_se[t`abstime'un]
		matrix CIu[`kk',`ii'] = _b[t`abstime'un] + invt(e(df_r),.975)*_se[t`abstime'un]
		}
	}
}

svmat coeffs, names(b)
svmat CIl, names(CIl)
svmat CIu, names(CIu)


g b_year = .
local kk = 0
forv year = -7/1 {
	local kk = `kk' + 1
	replace b_year = `year' in `kk'
}


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Buprenorphine Sold" ) ytitle("Grams Sold Per Capita") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_bupe.gph", replace
graph export "U:\Documents\graphs\ES_bupe.png", as(png) replace
twoway (scatter b2 b_year, mcolor(black)) (rcap CIl2 CIu2 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Methadone Sold" ) ytitle("Grams Sold Per Capita") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_methadone.gph", replace
graph export "U:\Documents\graphs\ES_methadone.png", as(png) replace
twoway (scatter b3 b_year, mcolor(black)) (rcap CIl3 CIu3 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Oxycode Sold" ) ytitle("Grams Sold Per Capita") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_oxy.gph", replace
graph export "U:\Documents\graphs\ES_oxy.png", as(png) replace
twoway (scatter b4 b_year, mcolor(black)) (rcap CIl4 CIu4 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Total Opioids Sold" ) ytitle("Morphine Equivalent grams per capita")/*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_sum.gph", replace
graph export "U:\Documents\graphs\ES_sum.png", as(png) replace
twoway (scatter b5 b_year, mcolor(black)) (rcap CIl5 CIu5 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Fentanyl Sold" ) ytitle("Grams Sold Per Capita") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_fentanyl.gph", replace
graph export "U:\Documents\graphs\ES_fentanyl.png", as(png) replace


*Death Data
drop b_year b1 b2 b3 b4 b5 CIl1 CIl2 CIl3 CIl4 CIl5 CIu1 CIu2 CIu3 CIu4 CIu5
matrix coeffs = J(14,2,.)
matrix CIl = J(14,2,.)
matrix CIu = J(14,2,.)

local ii = 0
foreach var in rp_opioidsum rp_Total {
	local ii = `ii' + 1
	quietly reg `var' i.newyear t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-12/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a'un]
			matrix CIl[`kk',`ii'] = _b[t_`a'un] - invt(e(df_r),.975)*_se[t_`a'un]
			matrix CIu[`kk',`ii'] = _b[t_`a'un] + invt(e(df_r),.975)*_se[t_`a'un]
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime'un]
		matrix CIl[`kk',`ii'] = _b[t`abstime'un] - invt(e(df_r),.975)*_se[t`abstime'un]
		matrix CIu[`kk',`ii'] = _b[t`abstime'un] + invt(e(df_r),.975)*_se[t`abstime'un]
		}
	}
}

svmat coeffs, names(b)
svmat CIl, names(CIl)
svmat CIu, names(CIu)


g b_year = .
local kk = 0
forv year = -12/1 {
	local kk = `kk' + 1
	replace b_year = `year' in `kk'
}


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Deaths Due to Opioids" ) ytitle("Deaths per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioidsum.gph", replace
graph export "U:\Documents\graphs\ES_opioidsum.png", as(png) replace
twoway (scatter b2 b_year, mcolor(black)) (rcap CIl2 CIu2 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Total Overdose Deaths" ) ytitle("Deaths per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_Total.gph", replace
graph export "U:\Documents\graphs\ES_Total.png", as(png) replace



*TEDS Data
drop b_year b1 b2 CIl1 CIl2 CIu1 CIu2 
matrix coeffs = J(14,6,.)
matrix CIl = J(14,6,.)
matrix CIu = J(14,6,.)

local ii = 0
foreach var in rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare {
	local ii = `ii' + 1
	quietly reg `var' i.newyear t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-12/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a'un]
			matrix CIl[`kk',`ii'] = _b[t_`a'un] - invt(e(df_r),.975)*_se[t_`a'un]
			matrix CIu[`kk',`ii'] = _b[t_`a'un] + invt(e(df_r),.975)*_se[t_`a'un]
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime'un]
		matrix CIl[`kk',`ii'] = _b[t`abstime'un] - invt(e(df_r),.975)*_se[t`abstime'un]
		matrix CIu[`kk',`ii'] = _b[t`abstime'un] + invt(e(df_r),.975)*_se[t`abstime'un]
		}
	}
}

svmat coeffs, names(b)
svmat CIl, names(CIl)
svmat CIu, names(CIu)


g b_year = .
local kk = 0
forv year = -12/1 {
	local kk = `kk' + 1
	replace b_year = `year' in `kk'
}


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Treatment Admissions for Opioid Addiction" ) ytitle("Treatment Admissions per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_primarytreatopioid.gph", replace
graph export "U:\Documents\graphs\ES_primarytreatopioid.png", as(png) replace
twoway (scatter b2 b_year, mcolor(black)) (rcap CIl2 CIu2 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Opioid Dependence Flag" ) ytitle("Treatment Admissions per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioiddependence.gph", replace
graph export "U:\Documents\graphs\ES_opioiddependence.png", as(png) replace
twoway (scatter b3 b_year, mcolor(black)) (rcap CIl3 CIu3 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Opioid Abuse Flag" ) ytitle("Treatment Admissions per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioidabuse.gph", replace
graph export "U:\Documents\graphs\ES_opioidabuse.png", as(png) replace
twoway (scatter b4 b_year, mcolor(black)) (rcap CIl4 CIu4 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Treatment Admissions with Private Insurance" ) ytitle("Treatment Admissions per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_insprivate.gph", replace
graph export "U:\Documents\graphs\ES_insprivate.png", as(png) replace
twoway (scatter b5 b_year, mcolor(black)) (rcap CIl5 CIu5 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Treatment Admissions with Medicaid" ) ytitle("Treatment Admissions per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_insmedicaid.gph", replace
graph export "U:\Documents\graphs\ES_insmedicaid.png", as(png) replace
twoway (scatter b6 b_year, mcolor(black)) (rcap CIl6 CIu6 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Treatment Admissions with Medicare" ) ytitle("Treatment Admissions per capita") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\insmedicare.gph", replace
graph export "U:\Documents\graphs\ES_insmedicare.png", as(png) replace

*varlist
*rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl rp_opioidsum rp_Total rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare
sort everexpand
by everexpand: sum rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl rp_opioidsum rp_Total rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare

by everexpand: sum ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed 

ttest rp_buprenorphine, by(everexpand)
ttest rp_methadone, by(everexpand)
ttest rp_oxycodone, by(everexpand)
ttest rp_med_sum, by(everexpand)
ttest rp_fentanyl, by(everexpand)
ttest rp_opioidsum, by(everexpand)
ttest rp_Total, by(everexpand)
ttest rp_primarytreatopioid, by(everexpand)
ttest rp_opioiddependence, by(everexpand)
ttest rp_opioidabuse, by(everexpand)
ttest rp_insprivateins, by(everexpand)
ttest rp_insmedicaid, by(everexpand)
ttest rp_insmedicare, by(everexpand)
ttest ml, by(everexpand)
ttest mm, by(everexpand)
ttest sdmm, by(everexpand)
ttest pdmp, by(everexpand)
ttest pdmpmustaccess, by(everexpand)
ttest newincome, by(everexpand)
ttest perwhite, by(everexpand)
ttest unrate, by(everexpand)
ttest ratemed, by(everexpand)





