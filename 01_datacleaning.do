* Panethnicity as a reactive identity: primary panethnic identification among 
* Latino-Hispanics in the United States
* https://doi.org/10.1080/01419870.2020.1752392

* Last Updated K Gonzalez  12/04/18 *
* kelseygonzalez@email.arizona.edu *
* Data is available for download at: https://www.pewresearch.org/hispanic/dataset/2013-national-survey-of-latinos/

* Purpose: clean original data


*********************************************************************************
*Load Data
*********************************************************************************
clear all
capture log close
set more off
use "Dataset - Pew Research Center 2013 U.S. Latino Religion Survey.dta",clear 

********************************************************************************
* Dependent Variables 
********************************************************************************
label define yesno 1 "Yes" 0 "No"

*Q2 Which do you prefer, hispanic or latino? 
gen PREF = .
	replace PREF = 1 if Q2 == 1
	replace PREF = 2 if Q2 == 2
	replace PREF = 3 if Q2 == 3
	label val PREF Q2
	label var PREF "Which do you prefer, hispanic or latino?"

tab PREF Q2, m	
	
*RACE
gen RACE = .
	replace RACE = 1 if RACECOM == 1
	replace RACE = 2 if RACECOM == 2
	replace RACE = 3 if RACECOM == 3
	replace RACE = 6 if RACECOM == 4
	replace RACE = 5 if RACECOM == 5
	replace RACE = 4 if RACECOM == 6
	label def RACE 1 "White" 2 "Black" 3 "Asian" 4 "Hispanic/Latino" ///
		5 "Mixed Race" 6 "Other Race"
	label val RACE RACE
	label var RACE "Respondent's Race"
tab RACE RACECOM, m	
	
* Q111
*People sometimes use different terms to describe themselves. In general which 
*ONE of the following terms do you use to describe yourself MOST OFTEN?

clonevar IDENT = Q111
	recode IDENT 9=.
	label var IDENT "which of the following terms do you use to describe yourself"

********************************************************************************
* Dependent Variables 
********************************************************************************	

*Region of US
tab REGION

*Sex
gen FEMALE = GENDER
	recode FEMALE 1=0 2=1
	label def FEMALE 0"Male" 1"Female"
	label val FEMALE FEMALE
	label var FEMALE "Respondent Gender"	
tab FEMALE GENDER, m

*prim_language
gen PRIMARY_LANGUAGE = Primary_Language
	label val PRIMARY_LANGUAGE Primary_Language

	
*Age
gen AGE = Q421
	replace AGE = . if Q421 == 9
	replace AGE = 1 if (q420rec == 1) |(q420rec == 2) 
	replace AGE = 2 if (q420rec == 3) | (q420rec == 4) |(q420rec == 5) | ///
	(q420rec == 6)
	replace AGE = 3 if (q420rec == 7) | (q420rec == 8) |(q420rec == 9)
	replace AGE = 4 if (q420rec == 10) | (q420rec == 11) | (q420rec == 12) | ///
	(q420rec == 13) |(q420rec == 14) |(q420rec == 15) 
	label val AGE Q421
	label var AGE "Categorical Age of r"
sort AGE
by AGE: tab Q421 q420rec, m	
		
*Political affiliation
gen PPARTY = .
	replace PPARTY = 3 if PARTY == 3 | PARTY == 4					
	replace PPARTY = 1 if PARTY == 1 | PARTYLN == 1 
	replace PPARTY = 2 if PARTY == 2 | PARTYLN == 2 
	label def PPARTY 1	"Republican" 2	"Democrat" 	3	"Other/No Preference"
	label val PPARTY PPARTY	
	label var PPARTY	"Respondent Political Party (or 'lean' if uncertain)"
sort PPARTY
by PPARTY: tab PARTY PARTYLN
	
*Educational attainment(RECODE SOME COLLEGE AS OWN CATEGORY)	
gen EDUCCAT2 = .
	replace EDUCCAT2 = 1 if EDUC == 1 | EDUC == 2
	replace EDUCCAT2 = 2 if EDUC == 3 
	replace EDUCCAT2 = 3 if EDUC == 4 | EDUC == 5
	replace EDUCCAT2 = 4 if EDUC == 6 | EDUC == 7 | EDUC == 8
	label def EDUCCAT2 1 "Less than HS" 2 "HS" 3 "Some College(no 4-yr deg)" 4 "4-yr College or More"
	label val EDUCCAT2 EDUCCAT2
	label var EDUCCAT2 "Category of Education completed (RECODE)"
tab EDUC EDUCCAT2 , m
	
	
*Household income
gen INCOMECAT2 = .
	replace INCOMECAT2 = 1 if INCOME == 1 | INCOME == 2 | INCOME == 3
	replace INCOMECAT2 = 2 if INCOME == 4 | INCOME == 5 | INCOME == 6
	replace INCOMECAT2 = 3 if INCOME == 7 | INCOME == 8 | INCOME == 9
	label var INCOMECAT2 "Categories of income"
	label def INCOMECAT2 1 "0 to $30,000" 2 "$30,000 to $75,000" 3 "$75,000+"		
	label  val INCOMECAT2 INCOMECAT2		
tab INCOME INCOMECAT2, m
	
*Latino national origin
gen ORIGIN = Q3REC
	replace ORIGIN = . if Q3REC == 99 
	replace ORIGIN = 6 if Q3REC == 97
	label def ORIGIN2 1 "Mexican" 2  "Puerto Rican" 3  "Cuban" 4  "Dominican" ///
	5  "Salvadoran" 6 "Other country"
	label val ORIGIN ORIGIN2 
	label var ORIGIN "Country of Origin" 
tab ORIGIN Q3REC	
	

	
*Citizenship
gen CITIZEN = .
	replace CITIZEN = 0 if Q4 == 3
	replace CITIZEN = 1 if Q4 == 1 | Q4 == 2 
	replace CITIZEN = 0 if Q412 == 2
	replace CITIZEN = 1 if Q412 == 1
	label val CITIZEN yesno
	label var CITIZEN "IS R a US Citizen? (natural born OR naturalized)"
sort CITIZEN
by CITIZEN: tab Q4 Q412, m

*Q105 
*Overall, what is the effect of UNDOCUMENTED or ILLEGAL immigration on
*(HISPANICS/LATINOS) already living in the U.S.? Would you say it’s
clonevar OP_IMM = Q105
fre OP_IMM 	


*Q130 Normal American 
*Overall, do you think of yourself as a typical American OR very different from a typicalAmerican?
clonevar OP_TYPICALAMERICAN = Q130
fre OP_TYPICALAMERICAN
		
*Q113 Latino Commonality
*How much do you think (INSERT ‘COUNTRY OF ORIGIN’ PLURAL FROM Q3/Q5 IF POSSIBLE)
*living in the U.S. and (LATINOS/HISPANICS) from different countries living in the U.S. today
*share values in common? Would you say…a lot in common, some in common, only a little in
*common, or almost nothing in common?
clonevar commonality = Q113
fre commonality 
	
gen common_dich = .
	replace common_dich = 1 if Q113 == 1
	replace common_dich = 1 if Q113 == 2
	replace common_dich = 0 if Q113 == 3
	replace common_dich = 0 if Q113 == 4
	replace common_dich = 2 if Q113 == 9
	label var common_dich "Ethnic group lot in common with other Latinos, dichotomized" 	
	label def common_dich 0 "differences with other Latinos" 1 "common with other latinos" 2 "DK/Refused"
	label val common_dich common_dich  
tab commonality common_dich, m

*Generation
*Born in USA
gen BORNUSA_WITHPR = .
	replace BORNUSA_WITHPR = 1 if Q4 == 1 | Q4 == 2
	replace BORNUSA_WITHPR = 0 if Q4 == 3
	label def birth 0 "abroad" 1 "USA/PR"
	label val BORNUSA_WITHPR birth
	label var BORNUSA_WITHPR "Was R Born in USA? (includes PR)"
tab Q4 BORNUSA_WITHPR, m
	
gen fatherbirth = .
	replace fatherbirth = 1 if Q411 == 1 | Q411 == 2
	replace fatherbirth = 0 if Q411 == 3
	label val fatherbirth birth
	label var fatherbirth "father Born in USA? (includes PR)"
tab Q411 fatherbirth, m

gen motherbirth = .
	replace motherbirth = 1 if Q410 == 1 | Q410 == 2
	replace motherbirth = 0 if Q410 == 3
	label val motherbirth birth
	label var motherbirth "mother born in USA? (includes PR)"
tab Q410 motherbirth, m

gen generation = . 
	replace generation = 1 if BORNUSA_WITHPR == 0
	replace generation = 2 if BORNUSA_WITHPR == 1 & fatherbirth == 0
	replace generation = 2 if BORNUSA_WITHPR == 1 & motherbirth == 0
	replace generation = 3 if motherbirth == 1 & fatherbirth == 1
	replace generation = 3 if motherbirth == 1 & fatherbirth == .
	replace generation = 3 if motherbirth == . & fatherbirth == 1
	label def generation 1 "1st gen" 2 "2nd gen" 3 "3rd+ gen "
	label val generation generation
	label var generation "Immigrant Generation"
tab BORNUSA_WITHPR generation, m 
sort generation
by generation: tab motherbirth fatherbirth, m

*to triple check because this is a tough variable.....
sort generation BORNUSA_WITHPR motherbirth fatherbirth 
list BORNUSA_WITHPR motherbirth fatherbirth if generation == 1
list BORNUSA_WITHPR motherbirth fatherbirth if generation == 2
list BORNUSA_WITHPR motherbirth fatherbirth if generation == 3


*********************************************************************************
*save
*********************************************************************************
save "Pew 2013 cleaned.dta", replace 

