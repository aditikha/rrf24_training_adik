* RRF 2024 - Analyzing Data Template	
*-------------------------------------------------------------------------------	
* Load data
*------------------------------------------------------------------------------- 
	
	use $data/Final/TZA_CCT_analysis.dta, clear


*-------------------------------------------------------------------------------	
* Summary stats
*------------------------------------------------------------------------------- 

	* defining globals with variables used for summary
	global sumvars 	area_acre_w food_cons_usd_w read sick days_sick treat_cost_usd nonfood_cons_usd_w	
	
	* Summary table - overall and by districts
	eststo all: 	estpost sum $sumvars
	eststo district_1: estpost sum $sumvars if district==1
	eststo district_2: estpost sum $sumvars if district==2
	eststo district_3: estpost sum $sumvars if district==3

	
	
	* Exporting table in csv
	esttab 	all district_* ///
			using "$outputs/sum_stats.csv", replace ///
			label ///
			main(mean %6.2f) aux(sd) ///
			refcat(hh_size "HH characteristcs" drought_flood "Shocks", nolabel) /// 
			mtitle("Full Sample" "Kibaha" "Bagayos" "Chamwino") ///
			nonotes addn(Mean with sd in parenthesis)
			
	
	* Also export in tex for latex
	*esttab all district_* ///
	
			
*-------------------------------------------------------------------------------	
* Balance tables
*------------------------------------------------------------------------------- 	
	
	* Balance (if they purchased cows or not)
	iebaltab 	$sumvars, ///
				grpvar(treatment) ///
				rowvarlabels	///
				format(%9.2f)	///
				savecsv($outputs/baltab.csv) ///
				savetex($outputs/baltab_tex.tex) ///
				nonote addnote("Balance tables with t-test") replace 			

				
*-------------------------------------------------------------------------------	
* Regressions
*------------------------------------------------------------------------------- 				
				
	* Model 1: Regress of food consumption value on treatment
	regress food_cons_usd_w treatment
	eststo 	reg1	// store regression results
	
	estadd local clustering "No" //local store which will distinguish the regressions in output
	
	* Model 2: Add controls 
	regress food_cons_usd_w treatment crop_damage drought_flood
	eststo reg2
	estadd local clustering "No"
	
	* Model 3: Add clustering by village
	regress food_cons_usd_w treatment crop_damage drought_flood, vce(cluster vid)
    eststo reg3
	estadd local clustering "Yes"
	
	* Export results in tex
	esttab 	reg1 reg2 reg3 ///
			using "$outputs/regression.tex" , ///
			label ///
			b(%9.2f) se(%9.2f) ///
			nomtitles ///
			mgroup("Food consumption(USD)", pattern(1 0 0 ) span) ///
			scalars("clustering Clustering") ///
			replace
			
*-------------------------------------------------------------------------------			
* Graphs 
*-------------------------------------------------------------------------------	

	* Bar graph by treatment for all districts 
	gr bar area_acre_w, ///
	    over(treatment) ///
		by(district, row(1) note("") ///
		legend(pos(6)) ///
		title("Area cultivated by treatment status per districts")) ///
		asy ///
		legend(rows(1) order(0 "Assignment:" 1 "Control" 2 "Treatment")) ///
		subtitle(,pos(6) bcolor(none)) ///
		blabel(total, format(%9.1f)) ///
		bar(1, color(red)) ///
		bar(2, color(blue)) ///
		ytitle("Average area cultivates(Acre)") name(g1, replace)
		
		
		
		
	gr export "$outputs/fig1.png", replace		
			
	* Distribution of non food consumption by female headed hhs with means
   forvalue f= 0/1 {
   	 sum nonfood_cons_usd_w if female_head== `f'
	 local mean_`f' = r(mean)
   }   //AK: For x-lines 
	
	
	twoway	(kdensity nonfood_cons_usd_w if female_head==0, color(red)) ///
			(kdensity nonfood_cons_usd_w if female_head==1, color(green)), ///
			xline(`mean_0', lcolor(red) 	lpattern(dash)) ///
			xline(`mean_1', lcolor(green) 	lpattern(dash)) ///
			leg(order(0 "Household Head:" 1 "Male" 2 "Female" ) row(1) pos(6)) ///
			xtitle("Distribution of non food consumption") ///
			ytitle("Density") ///
			title("Distribution of non food consumption") ///
			note("Dashed lines represent the averages")
			
	gr export "$outputs/fig2.png", replace				
			
*-------------------------------------------------------------------------------			
* Graphs: Secondary data
*-------------------------------------------------------------------------------			
			
	use "$data/Final/TZA_amenity_analysis.dta", clear
	
	* createa  variable to highlight the districts in sample
	gen in_sample= district==1|district==3|district==6
	*sample= inlist(district, 1,3,6)
	
	* Separate indicators by sample
	separate n_school, by(in_sample)
	separate n_medical, by(in_sample)
	
	
	* Graph bar for number of schools by districts
	gr hbar 	n_school0 n_school1, ///
				nofill ///
				over(district, sort(n_school)) ///
				legend(order(0 "Sample:" 1 "Out" 2 "In") row(1)  pos(6)) ///
				ytitle("No. of schools") ///
				name(g1, replace)
				
	* Graph bar for number of medical facilities by districts				
	gr hbar 	n_medical0 n_medical1, ///
	            nofill ///
				over(district, sort(n_school)) ///
				legend(order(0 "Sample:" 1 "Out" 2 "In") row(1)  pos(6)) ///
				ytitle("No. of medical facilities") ///
				name(g2, replace)
	*Combine both graphs			
	grc1leg2 	g1 g2, ///
				row(2) legend(g1) ///
				ycommon xcommon ///
				title("School and medical facilities by District", size(medsmall))
			
	
	gr export "$outputs/fig3.png", replace			

****************************************************************************end!
	
