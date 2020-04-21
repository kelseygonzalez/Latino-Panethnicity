* Panethnicity as a reactive identity: primary panethnic identification among 
* Latino-Hispanics in the United States
* https://doi.org/10.1080/01419870.2020.1752392

* Last Updated K Gonzalez  2/18/20 *
* kelseygonzalez@email.arizona.edu *
* Data is available for download at: https://www.pewresearch.org/hispanic/dataset/2013-national-survey-of-latinos/

* Purpose: impute cleaned data set


*********************************************************************************
*Load Data
*********************************************************************************
clear all
capture log close
set more off
use "Pew 2013 cleaned.dta",clear 
keep IDENT REGION commonality PRIMARY_LANGUAGE ORIGIN PPARTY generation INCOMECAT2 EDUCCAT2 CITIZEN FEMALE  AGE RACE totalwt
drop if IDENT == 4

*********************************************************************************
*Multiple Imputation
*********************************************************************************
misstable summ, all gen(m_) 
	mi set wide
	mi register imputed ///				
			RACE IDENT AGE PPARTY EDUCCAT2 INCOMECAT2 ORIGIN CITIZEN generation       
				  
	mi register regular ///
			REGION FEMALE PRIMARY_LANGUAGE
			
	mi query
	mi describe

	mi impute chained     ///
		(mlogit) IDENT ORIGIN PPARTY RACE ///
		(ologit)  generation INCOMECAT2 EDUCCAT2 AGE ///
		(logit) CITIZEN  ///
		= REGION FEMALE PRIMARY_LANGUAGE, augment add(26) rseed(747) 	

*drop refused/DK and "Depends" cases before analysis
drop if IDENT == .
drop if IDENT == 4

*********************************************************************************
*save
*********************************************************************************
save "Pew 2013 imputed.dta", replace 
