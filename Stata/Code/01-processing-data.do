* RRF 2024 - Processing Data Template	
*-------------------------------------------------------------------------------	
* Loading data
*------------------------------------------------------------------------------- 	
	
	* Load TZA_CCT_baseline.dta
	use "${data}/Raw/TZA_CCT_baseline.dta", clear
	
*-------------------------------------------------------------------------------	
* Checking for unique ID and fixing duplicates
*------------------------------------------------------------------------------- 		
*AK: iefieldkit
	* Identify duplicates 
	ieduplicates	hhid ///
					using "${outputs}/duplicates.xlsx", ///
					uniquevars(key) ///
					keepvars(vid enid submissionday) ///
					nodaily
					//AK: Run this again after editing the excel file with comments and duplicates 
	
*-------------------------------------------------------------------------------	
* Define locals to store variables for each level
*------------------------------------------------------------------------------- 							
	
	* IDs
	local ids hhid key vid enid 
	
	* Unit: household
	local hh_vars 	floor roof walls water enegry rel_head female_head hh_size n_child_5 n_child_17 n_adult n_elder food_cons nonfood_cons farm ar_farm ar_farm_unit crop crop_other crop_prp livestock_now livestock_before drought_flood crop_damage trust_mem trust_lead assoc health submissionday duration
	
	//local hh_vars floor - n_elder///
	//food_cons - key
	
	* Unit: Household-memebr
	local hh_mem	gender_1 age_1 read_1 clinic_visit_1 sick_1 days_sick_1 treat_fin_1 treat_cost_1 ill_impact_1 days_impact_1 gender_2 age_2 read_2 clinic_visit_2 sick_2 days_sick_2 treat_fin_2 treat_cost_2 ill_impact_2 days_impact_2
	
	
	* define locals with suffix and for reshape
	foreach mem in `hh_mem' {
		
		local mem_vars 		"`mem_vars' `mem'_*"
		local reshape_mem  "`reshape_mem' `mem'_"
	}
		
	
*-------------------------------------------------------------------------------	
* Tidy Data: HH
*-------------------------------------------------------------------------------	

	*preserve 
		
		* Keep HH vars
		keep `ids' `hh_vars'
		
		* Check if data type is string
		ds, has(type string)
		
		*Fix submission dates
		gen submissiondate = date(submissionday, "YMD hms")
		format submissiondate %td
		
		*Encoding area farm 
		encode ar_farm_unit,gen(at_unit)  //AK:labelbook for checking the encoding
		
		
		*Destring duration 
		destring duration, replace
		
		*Clean crop_other
		replace crop_other = proper(crop_other) //AK: stringtrim and allcaps options also available
		
		replace crop =40 if regex(crop_other, "Coconut")==1
		replace crop=41 if regex(crop_other, "Sesame")==1
		
		label define df_CROP 40 "Coconut" 41 "Sesame", add
		
		* Fix data types 
		* numeric should be numeric
		* dates should be in the date format
		* Categorical should have value labels 
		
				
		
		* Turn numeric variables with negative values into missings
		ds, has(type numeric) //AK: describe all var that has type numeric
		global numVar `r(varlist)'
		foreach global numVar `r(Var)'

		foreach numVar of global numVars {
			
			recode `numVar' (-88=.d) //.d is don't know, .o-other, .r-refuse
		}	
		
		* Explore variables for outliers
		sum ???
		
		* dropping, ordering, labeling before saving
		drop 	???
				
		order 	???
		
		lab var ???
		
		isid ???
		
		* Save data		
		iesave 	"${data}/Intermediate/???", ///
				idvars(???)  version(???) replace ///
				report(path("${outputs}/???.csv") replace)  
		
	restore
	
*-------------------------------------------------------------------------------	
* Tidy Data: HH-member 
*-------------------------------------------------------------------------------*

	preserve 

		keep `mem_vars' `ids'

		* tidy: reshape tp hh-mem level 
		reshape long `reshape_mem', i(`ids') j(member)
		
		* clean variable names 
		rename *_ *
		
		* drop missings 
		drop if mi(gender)
		
		* Cleaning using iecodebook
		// recode the non-responses to extended missing
		// add variable/value labels
		// create a template first, then edit the template and change the syntax to 
		// iecodebook apply
		iecodebook template 	using ///
								"${outputs}/hh_mem_codebook.xlsx"
								
		isid ???					
		
		* Save data: Use iesave to save the clean data and create a report 
		iesave 	???  
				
	restore			
	
*-------------------------------------------------------------------------------	
* Tidy Data: Secondary data
*------------------------------------------------------------------------------- 	
	
	* Import secondary data 
	???
	
	* reshape  
	reshape ???
	
	* rename for clarity
	rename ???
	
	* Fix data types
	encode ???
	
	* Label all vars 
	lab var district "District"
	???
	???
	???
	
	* Save
	keeporder ???
	
	save "${data}/Intermediate/???.dta", replace

	
****************************************************************************end!
	
