*corresponds to regressions

use "\\rschfs1x\userth\R-Z\sas648_TH\Documents\TEDS\cleandata2.dta"

*a good command for graphs
xtset newyear newstateid
xtline sub1anyopioid, overlay
xtreg rp_opioidsum effect i.newstateid,  fe 


*DD event study graphs


*ARCOS variables: Buprenorphine Sold, Methadone Sold, Oxycodone Sold, Total Opioids Sold, Fentanyl Sold
foreach var in rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl {

quietly reg `var' i.newyear i.newstateid t_7 t_6 t_5 t_4 t_3 t_2 t0 t1 ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
test t_7 t_6 t_5 t_4 t_3 t_2 
}

*death data variables: rp_opioidsum is the sum of all opioid related deaths, rp_Total is the total overdose deaths
*Opioid Related Deaths, Total Overdose Deaths

foreach var in rp_opioidsum {

quietly reg `var' i.newyear i.newstateid t_12 t_11 t_10 t_9 t_8 t_7 t_6 t_5 t_4 t_3 t_2 t0 t1 ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
test t_12 t_11 t_10 t_9 t_8 t_7 t_6 t_5 t_4 t_3 t_2 

}

*treatment admissions variables: rp_sub1methadone rp_sub1other rp_sub1anyopioid rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare
*Opioid Treatment Admission, Opioid dependence, Opioid Abuse, Treated with Private Insurance, Treated with Medicaid, Treated with Medicare
foreach var in rp_primarytreatopioid rp_opioiddependence rp_opioidabuse  {

quietly reg `var' i.newyear i.newstateid t_12 t_11 t_10 t_9 t_8 t_7 t_6 t_5 t_4 t_3 t_2 t0 t1 ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
test t_12 t_11 t_10 t_9 t_8 t_7 t_6 t_5 t_4 t_3 t_2 

}


*Creating nice figures
xtset newstateid newyear
xtgraph rp_buprenorphine, group(everexpand)
xtgraph rp_methadone, group(everexpand)
xtgraph rp_oxycodone, group(everexpand)
xtgraph rp_med_sum, group(everexpand)
xtgraph rp_fentanyl, group(everexpand)
xtgraph rp_opioidsum, group(everexpand)
xtgraph rp_primarytreatopioid, group(everexpand)
xtgraph rp_opioiddependence, group(everexpand)
xtgraph rp_opioidabuse, group(everexpand)




*ARCOS Data
matrix coeffs = J(9,5,.)
matrix CIl = J(9,5,.)
matrix CIu = J(9,5,.)

local ii = 0
foreach var in rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl {
	local ii = `ii' + 1
	quietly reg `var' i.newyear i.newstateid t_7 t_6 t_5 t_4 t_3 t_2 t0 t1 ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-7/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a']
			matrix CIl[`kk',`ii'] = _b[t_`a'] - invt(e(df_r),.975)*_se[t_`a']
			matrix CIu[`kk',`ii'] = _b[t_`a'] + invt(e(df_r),.975)*_se[t_`a']
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime']
		matrix CIl[`kk',`ii'] = _b[t`abstime'] - invt(e(df_r),.975)*_se[t`abstime']
		matrix CIu[`kk',`ii'] = _b[t`abstime'] + invt(e(df_r),.975)*_se[t`abstime']
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


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Buprenorphine Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_bupe.gph", replace
graph export "U:\Documents\graphs\ES_bupe.png", as(png) replace
twoway (scatter b2 b_year, mcolor(black)) (rcap CIl2 CIu2 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Methadone Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_methadone.gph", replace
graph export "U:\Documents\graphs\ES_methadone.png", as(png) replace
twoway (scatter b3 b_year, mcolor(black)) (rcap CIl3 CIu3 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Oxycode Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_oxy.gph", replace
graph export "U:\Documents\graphs\ES_oxy.png", as(png) replace
twoway (scatter b4 b_year, mcolor(black)) (rcap CIl4 CIu4 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Total Opioids Sold" ) ytitle("Coefficient on Relative Time Variable")/*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_sum.gph", replace
graph export "U:\Documents\graphs\ES_sum.png", as(png) replace
twoway (scatter b5 b_year, mcolor(black)) (rcap CIl5 CIu5 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Fentanyl Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_fentanyl.gph", replace
graph export "U:\Documents\graphs\ES_fentanyl.png", as(png) replace


*Death Data
drop b_year b1 b2 b3 b4 b5 CIl1 CIl2 CIl3 CIl4 CIl5 CIu1 CIu2 CIu3 CIu4 CIu5
matrix coeffs = J(14,2,.)
matrix CIl = J(14,2,.)
matrix CIu = J(14,2,.)

local ii = 0
foreach var in rp_opioidsum {
	local ii = `ii' + 1
	quietly reg `var' i.newyear i.newstateid t_12 t_11 t_10 t_9 t_8 t_7 t_6 t_5 t_4 t_3 t_2 t0 t1 ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-12/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a']
			matrix CIl[`kk',`ii'] = _b[t_`a'] - invt(e(df_r),.975)*_se[t_`a']
			matrix CIu[`kk',`ii'] = _b[t_`a'] + invt(e(df_r),.975)*_se[t_`a']
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime']
		matrix CIl[`kk',`ii'] = _b[t`abstime'] - invt(e(df_r),.975)*_se[t`abstime']
		matrix CIu[`kk',`ii'] = _b[t`abstime'] + invt(e(df_r),.975)*_se[t`abstime']
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


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Overdose Deaths" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioidsum.gph", replace
graph export "U:\Documents\graphs\ES_opioidsum.png", as(png) replace



*TEDS Data
drop b_year b1 b2 CIl1 CIl2 CIu1 CIu2 
matrix coeffs = J(14,6,.)
matrix CIl = J(14,6,.)
matrix CIu = J(14,6,.)

local ii = 0
foreach var in rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare {
	local ii = `ii' + 1
	quietly reg `var' i.newyear i.newstateid t_12 t_11 t_10 t_9 t_8 t_7 t_6 t_5 t_4 t_3 t_2 t0 t1 ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-12/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a']
			matrix CIl[`kk',`ii'] = _b[t_`a'] - invt(e(df_r),.975)*_se[t_`a']
			matrix CIu[`kk',`ii'] = _b[t_`a'] + invt(e(df_r),.975)*_se[t_`a']
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime']
		matrix CIl[`kk',`ii'] = _b[t`abstime'] - invt(e(df_r),.975)*_se[t`abstime']
		matrix CIu[`kk',`ii'] = _b[t`abstime'] + invt(e(df_r),.975)*_se[t`abstime']
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


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Opioid Treatment Admissions" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_primarytreatopioid.gph", replace
graph export "U:\Documents\graphs\ES_primarytreatopioid.png", as(png) replace
twoway (scatter b2 b_year, mcolor(black)) (rcap CIl2 CIu2 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Opioid Dependence Flag" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioiddependence.gph", replace
graph export "U:\Documents\graphs\ES_opioiddependence.png", as(png) replace
twoway (scatter b3 b_year, mcolor(black)) (rcap CIl3 CIu3 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Opioid Abuse Flag" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioidabuse.gph", replace
graph export "U:\Documents\graphs\ES_opioidabuse.png", as(png) replace

*DDD event study

*ARCOS variables: Buprenorphine Sold, Methadone Sold, Oxycodone Sold, Total Opioids Sold, Fentanyl Sold
foreach var in rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl {

quietly reg `var' i.newyear i.newstateid t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
test t_7un t_6un t_5un t_4un t_3un t_2un 
}

*death data variables: rp_opioidsum is the sum of all opioid related deaths, rp_Total is the total overdose deaths
*Opioid Related Deaths, Total Overdose Deaths

foreach var in rp_opioidsum {

quietly reg `var' i.newyear i.newstateid t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
test t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un 

}

*treatment admissions variables: rp_sub1methadone rp_sub1other rp_sub1anyopioid rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare
*Opioid Treatment Admission, Opioid dependence, Opioid Abuse, Treated with Private Insurance, Treated with Medicaid, Treated with Medicare
foreach var in rp_opioidsum {

quietly reg `var' i.newyear i.newstateid t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
test t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un 

}




*DDD event study graphs


*ARCOS Data
matrix coeffs = J(9,5,.)
matrix CIl = J(9,5,.)
matrix CIu = J(9,5,.)

local ii = 0
foreach var in rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl {
	local ii = `ii' + 1
    quietly reg `var' i.newyear i.newstateid t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-7/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a']
			matrix CIl[`kk',`ii'] = _b[t_`a'] - invt(e(df_r),.975)*_se[t_`a']
			matrix CIu[`kk',`ii'] = _b[t_`a'] + invt(e(df_r),.975)*_se[t_`a']
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime']
		matrix CIl[`kk',`ii'] = _b[t`abstime'] - invt(e(df_r),.975)*_se[t`abstime']
		matrix CIu[`kk',`ii'] = _b[t`abstime'] + invt(e(df_r),.975)*_se[t`abstime']
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


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Buprenorphine Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_bupe.gph", replace
graph export "U:\Documents\graphs\ES_bupe.png", as(png) replace
twoway (scatter b2 b_year, mcolor(black)) (rcap CIl2 CIu2 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Methadone Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_methadone.gph", replace
graph export "U:\Documents\graphs\ES_methadone.png", as(png) replace
twoway (scatter b3 b_year, mcolor(black)) (rcap CIl3 CIu3 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Oxycode Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_oxy.gph", replace
graph export "U:\Documents\graphs\ES_oxy.png", as(png) replace
twoway (scatter b4 b_year, mcolor(black)) (rcap CIl4 CIu4 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Total Opioids Sold" ) ytitle("Coefficient on Relative Time Variable")/*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_sum.gph", replace
graph export "U:\Documents\graphs\ES_sum.png", as(png) replace
twoway (scatter b5 b_year, mcolor(black)) (rcap CIl5 CIu5 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Fentanyl Sold" ) ytitle("Coefficient on Relative Time Variable") /*xline(0, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_fentanyl.gph", replace
graph export "U:\Documents\graphs\ES_fentanyl.png", as(png) replace


*Death Data
drop b_year b1 b2 b3 b4 b5 CIl1 CIl2 CIl3 CIl4 CIl5 CIu1 CIu2 CIu3 CIu4 CIu5
matrix coeffs = J(14,2,.)
matrix CIl = J(14,2,.)
matrix CIu = J(14,2,.)

local ii = 0
foreach var in rp_opioidsum {
	local ii = `ii' + 1
    quietly reg `var' i.newyear i.newstateid t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
 	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-12/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a']
			matrix CIl[`kk',`ii'] = _b[t_`a'] - invt(e(df_r),.975)*_se[t_`a']
			matrix CIu[`kk',`ii'] = _b[t_`a'] + invt(e(df_r),.975)*_se[t_`a']
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime']
		matrix CIl[`kk',`ii'] = _b[t`abstime'] - invt(e(df_r),.975)*_se[t`abstime']
		matrix CIu[`kk',`ii'] = _b[t`abstime'] + invt(e(df_r),.975)*_se[t`abstime']
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


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Overdose Deaths" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioidsum.gph", replace
graph export "U:\Documents\graphs\ES_opioidsum.png", as(png) replace



*TEDS Data
drop b_year b1 b2 CIl1 CIl2 CIu1 CIu2 
matrix coeffs = J(14,6,.)
matrix CIl = J(14,6,.)
matrix CIu = J(14,6,.)

local ii = 0
foreach var in rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare {
	local ii = `ii' + 1
    quietly reg `var' i.newyear i.newstateid t_12un t_11un t_10un t_9un t_8un t_7un t_6un t_5un t_4un t_3un t_2un t0un t1un ml mm sdmm pdmp pdmpmustaccess newincome perwhite 
	
	* save coeffs for graph
	local kk = 0
	forvalues abstime=-12/1 {
		local kk = `kk' + 1
		*local abstime=`time'-13
		if (`abstime' <= -2) {
			local a=`abstime'*-1
			matrix coeffs[`kk',`ii'] = _b[t_`a']
			matrix CIl[`kk',`ii'] = _b[t_`a'] - invt(e(df_r),.975)*_se[t_`a']
			matrix CIu[`kk',`ii'] = _b[t_`a'] + invt(e(df_r),.975)*_se[t_`a']
		}
		else if (`abstime' == -1) {
			matrix coeffs[`kk',`ii'] = 0
			matrix CIl[`kk',`ii'] = 0
			matrix CIu[`kk',`ii'] = 0
		}
		else if (`abstime' >=0) {
		matrix coeffs[`kk',`ii'] = _b[t`abstime']
		matrix CIl[`kk',`ii'] = _b[t`abstime'] - invt(e(df_r),.975)*_se[t`abstime']
		matrix CIu[`kk',`ii'] = _b[t`abstime'] + invt(e(df_r),.975)*_se[t`abstime']
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


twoway (scatter b1 b_year, mcolor(black)) (rcap CIl1 CIu1 b_year, lcolor(gray)), legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Opioid Treatment Admissions" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_primarytreatopioid.gph", replace
graph export "U:\Documents\graphs\ES_primarytreatopioid.png", as(png) replace
twoway (scatter b2 b_year, mcolor(black)) (rcap CIl2 CIu2 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Opioid Dependence Flag" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioiddependence.gph", replace
graph export "U:\Documents\graphs\ES_opioiddependence.png", as(png) replace
twoway (scatter b3 b_year, mcolor(black)) (rcap CIl3 CIu3 b_year, lcolor(gray)),legend(label(1 "Estimate") label(2 "95% CI")) xtitle("Time Relative to Treatment") title("Event Study for Opioid Abuse Flag" ) ytitle("Coefficient on Relative Time Variable") /*xline(2011, lcolor(gs3))*/ yline(0, lcolor(gs3)) graphregion(color(white))
graph save Graph "U:\Documents\graphs\ES_opioidabuse.gph", replace
graph export "U:\Documents\graphs\ES_opioidabuse.png", as(png) replace




*creating summary statistics
*varlist
*rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl rp_opioidsum rp_Total rp_primarytreatopioid rp_opioiddependence rp_opioidabuse rp_insprivateins rp_insmedicaid rp_insmedicare
sort everexpand
by everexpand: sum rp_buprenorphine rp_methadone rp_oxycodone rp_med_sum rp_fentanyl rp_opioidsum rp_primarytreatopioid rp_opioiddependence rp_opioidabuse 

by everexpand: sum ml mm sdmm pdmp pdmpmustaccess newincome perwhite unrate ratemed 

ttest rp_buprenorphine, by(everexpand)
ttest rp_methadone, by(everexpand)
ttest rp_oxycodone, by(everexpand)
ttest rp_med_sum, by(everexpand)
ttest rp_fentanyl, by(everexpand)
ttest rp_opioidsum, by(everexpand)
ttest rp_primarytreatopioid, by(everexpand)
ttest rp_opioiddependence, by(everexpand)
ttest rp_opioidabuse, by(everexpand)
ttest ml, by(everexpand)
ttest mm, by(everexpand)
ttest sdmm, by(everexpand)
ttest pdmp, by(everexpand)
ttest pdmpmustaccess, by(everexpand)
ttest newincome, by(everexpand)
ttest perwhite, by(everexpand)
ttest unrate, by(everexpand)
ttest ratemed, by(everexpand)


*dif in dif
foreach var in rp_buprenorphine rp_methadone rp_med_sum rp_fentanyl rp_opioidsum rp_primarytreatopioid rp_opioiddependence rp_opioidabuse{

reg `var' expand ml mm sdmm pdmp pdmpmustaccess newincome perwhite i.newyear i.newstateid, vce(cluster newstateid) 
}

*triple dif
foreach var in rp_buprenorphine rp_methadone rp_med_sum rp_fentanyl rp_opioidsum rp_primarytreatopioid rp_opioiddependence rp_opioidabuse{

reg `var' expand effect ml mm sdmm pdmp pdmpmustaccess newincome perwhite i.newyear i.newstateid, vce(cluster newstateid) 
}



*sensitivity checks

*dropping Indiana, Pennsylvania, and New Hampshire (2015 expanders)

drop if newstateid==15 | newstateid==30 | newstateid==39
save "\\rschfs1x\userth\R-Z\sas648_TH\Documents\TEDS\cleandata3.dta", replace

use "\\rschfs1x\userth\R-Z\sas648_TH\Documents\TEDS\cleandata3.dta", replace


*dif in dif
foreach var in rp_buprenorphine rp_methadone rp_med_sum rp_fentanyl rp_opioidsum rp_primarytreatopioid rp_opioiddependence rp_opioidabuse{

reg `var' expand ml mm sdmm pdmp pdmpmustaccess newincome perwhite i.newyear i.newstateid, vce(cluster newstateid) 
}

*triple dif
foreach var in rp_buprenorphine rp_methadone rp_med_sum rp_fentanyl rp_opioidsum rp_primarytreatopioid rp_opioiddependence rp_opioidabuse{

reg `var' effect expand ml mm sdmm pdmp pdmpmustaccess newincome perwhite i.newyear i.newstateid, vce(cluster newstateid) 
}



*Dropping early expanders  AZ, CA, CT, DE, HI, MA, MN, NY, VT, DC, and WI
use "\\rschfs1x\userth\R-Z\sas648_TH\Documents\TEDS\cleandata2.dta", clear

drop if newstateid==3 | newstateid==5 | newstateid==7 | newstateid==8 | newstateid==9 | newstateid==12 | newstateid==22 | newstateid==24 | newstateid==33 | newstateid==46 | newstateid==50

save "\\rschfs1x\userth\R-Z\sas648_TH\Documents\TEDS\cleandata4.dta", replace


*dif in dif
foreach var in rp_buprenorphine rp_methadone rp_med_sum rp_fentanyl rp_opioidsum rp_primarytreatopioid rp_opioiddependence rp_opioidabuse{

reg `var' expand ml mm sdmm pdmp pdmpmustaccess newincome perwhite i.newyear i.newstateid, vce(cluster newstateid) 
}

*triple dif
foreach var in rp_buprenorphine rp_methadone rp_med_sum rp_fentanyl rp_opioidsum rp_primarytreatopioid rp_opioiddependence rp_opioidabuse{

reg `var' effect expand unrate13 ml mm sdmm pdmp pdmpmustaccess newincome perwhite i.newyear i.newstateid, vce(cluster newstateid) 
}







