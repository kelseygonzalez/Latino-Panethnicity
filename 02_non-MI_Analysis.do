* Panethnicity as a reactive identity: primary panethnic identification among 
* Latino-Hispanics in the United States
* https://doi.org/10.1080/01419870.2020.1752392

* Last Updated K Gonzalez  2/18/20 *
* kelseygonzalez@email.arizona.edu *
* Data is available for download at: https://www.pewresearch.org/hispanic/dataset/2013-national-survey-of-latinos/

* Purpose: Create appendix for non-imputed results at request of journal reviewers

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
*Models for non-imputed data using list-wise deletion
*********************************************************************************

mlogit IDENT ///	
	i.FEMALE i.AGE i.RACE ///
	ib3.INCOMECAT2 ib4.EDUCCAT2 ///
	ib2.PPARTY i.REGION   ///
	i.ORIGIN ib1.PRIMARY_LANGUAGE ib3.generation i.CITIZEN, b(1) nolog
estimates store model_b1_ld

mlogit IDENT ///	
	i.FEMALE i.AGE i.RACE ///
	ib3.INCOMECAT2 ib4.EDUCCAT2 ///
	ib2.PPARTY i.REGION   ///
	i.ORIGIN ib1.PRIMARY_LANGUAGE ib3.generation i.CITIZEN, b(3) nolog
estimates store model_b3_ld

*********************************************************************************
*Appendix 2
*********************************************************************************
esttab model_b1_ld model_b3_ld using appendix2.rtf, replace unstack wide b(a3) se(3) s(N aic bic) se nodep compress ///
	nogap varwidth(25) nonumber    ///
	label coeflabels(	FEMALE "Female" 3.PRIMARY_LANGUAGE "Spanish Dominant" ///
	1.BORNUSA_WITHPR "Born in the USA" CITIZEN "Citizen" 3.Q105 "No effect" ) ///
	refcat(2.REGION "Region (Ref: Northeast):" 2.ORIGIN "Region of Origin /// (Ref: Mexico):" ///
	1.RACE "Race (Ref: White):" 1.PPARTY "Political Party (Ref: Dem):" ///
	1.PRIMARY_LANGUAGE "Language(Ref: Bilingual):"  ///
	1.INCOMECAT2 "Annual Income (Ref: $75,000+)" 2.AGE "Age (Ref:18 to 29):" ///
	1.EDUCCAT2 "Education (Ref: College Grad):"  ///
	1.generation "Generation (Ref: 3rd Gen +)" 2.Q105 ///
	"Undoc Immigration has a … (Ref: positive effect):"	2.Q130 ///
	"You feel like a … (Ref: Typical American):" , nolabel) 
