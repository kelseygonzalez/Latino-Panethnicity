* Panethnicity as a reactive identity: primary panethnic identification among 
* Latino-Hispanics in the United States
* https://doi.org/10.1080/01419870.2020.1752392

* Last Updated K Gonzalez  2/18/20 *
* kelseygonzalez@email.arizona.edu *
* Data is available for download at: https://www.pewresearch.org/hispanic/dataset/2013-national-survey-of-latinos/

* Purpose: perform tests for multinomial logistic regressions


*********************************************************************************
*Load Data
*********************************************************************************
clear all
capture log close
set more off
use "Pew 2013 imputed.dta", clear

*********************************************************************************
*Testing
*********************************************************************************
*Testing for multicollinearity
mi convert flong
mi estimate: regress IDENT ///	
	i.FEMALE i.AGE i.RACE ///
	ib3.INCOMECAT2 ib4.EDUCCAT2 ///
	ib2.PPARTY i.REGION   ///
	i.ORIGIN ib1.PRIMARY_LANGUAGE ib3.generation i.CITIZEN ///
	i.OP_IMM i.OP_TYPICALAMERICAN i.commonality
mivif


*testing if categories should be combined 	
mlogit IDENT ///	
	i.FEMALE i.AGE i.RACE ///
	ib3.INCOMECAT2 ib4.EDUCCAT2 ///
	ib2.PPARTY i.REGION   ///
	i.ORIGIN ib1.PRIMARY_LANGUAGE ib3.generation i.CITIZEN ///
	i.OP_IMM i.OP_TYPICALAMERICAN i.commonality, b(1) nolog
mlogtest, combine  

*testing IIA 
mlogit IDENT ///	
	i.FEMALE i.AGE i.RACE ///
	ib3.INCOMECAT2 ib4.EDUCCAT2 ///
	ib2.PPARTY i.REGION   ///
	i.ORIGIN ib1.PRIMARY_LANGUAGE ib3.generation i.CITIZEN ///
	i.OP_IMM i.OP_TYPICALAMERICAN i.commonality, b(3) nolog 
mlogtest, smhsiao
mlogtest, hausman
