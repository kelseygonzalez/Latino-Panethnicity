* Panethnicity as a reactive identity: primary panethnic identification among 
* Latino-Hispanics in the United States
* https://doi.org/10.1080/01419870.2020.1752392

* Last Updated K Gonzalez  2/18/20 *
* kelseygonzalez@email.arizona.edu *
* Data is available for download at: https://www.pewresearch.org/hispanic/dataset/2013-national-survey-of-latinos/

* Purpose: Create figure 2 of adjusted predictions

*********************************************************************************
*Load Data
*********************************************************************************
clear all
capture log close
set more off
use "Pew 2013 imputed.dta", clear

*********************************************************************************
*run model
*********************************************************************************	

mi estimate, post: mlogit IDENT ///	
	i.FEMALE i.AGE i.RACE ///
	ib3.INCOMECAT2 ib4.EDUCCAT2 ///
	ib2.PPARTY i.REGION   ///
	i.ORIGIN ib1.PRIMARY_LANGUAGE ib3.generation i.CITIZEN, b(1) nolog

mimrgns generation, predict(outcome(1)) predict(outcome(2)) predict(outcome(3)) cmdmargins vsquish
marginsplot
