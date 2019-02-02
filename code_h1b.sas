/*
COOKD= Cooks  influence statistic
COVRATIO=standard influence of observation on covariance of betas
DFFITS=standard influence of observation on predicted value
H=leverage, 
LCL=lower bound of a % confidence interval for an individual prediction. This includes the variance of the error, as well as the variance of the parameter estimates.
LCLM=lower bound of a % confidence interval for the expected value (mean) of the dependent variable
PREDICTED | P= predicted values
RESIDUAL | R= residuals, calculated as ACTUAL minus PREDICTED
RSTUDENT=a studentized residual with the current observation deleted
STDI=standard error of the individual predicted value
STDP= standard error of the mean predicted value
STDR=standard error of the residual
STUDENT=studentized residuals, which are the residuals divided by their standard errors
UCL= upper bound of a % confidence interval for an individual prediction
UCLM= upper bound of a % confidence interval for the expected value (mean) of the dependent variable
* Cooks  statistic lies above the horizontal reference line at value 4/n *; 
* DFFITSEstatistic is greater in magnitude than 2sqrt(n/p);
* Durbin watson around 2 *;
* VIF over 10 multicolinear **;

Prpose : Project
CWID : 10442200
*/

/*loading dataset in work environment*/
proc import datafile = "D:/sem1/Multivariate/652_project/cleaned_data_final_2.csv" 
out = work.h1b 
dbms = csv;
run;
/*
n=ranuni(8);
proc sort data=h1b;
by n;
data training testing;
set h1b nobs=nobs;
if _n_<=.6*nobs then output training;
else output testing;
run;*/

/*APPLYING MULTIPLE REGRESSION USING STEPWISE SELECTION*/
ODS GRAPHICS ON;
proc reg data=h1b outest=h1b_out;
    model CASE_STATUS= CASE_SUBMITTED_MONTH CASE_SUBMITTED_YEAR DECISION_MONTH DECISION_YEAR EMPLOYER_NAME EMPLOYER_STATE SOC_NAME 
	NAICS_CODE FULL_TIME_POSITION PREVAILING_WAGE WILLFUL_VIOLATOR WORKSITE_STATE
	WORKSITE_POSTAL_CODE  / sle=.05 SS1 SS2 STB /*standardized beta */    VIF selection=stepwise;
      OUTPUT OUT=h1b_OUT_1  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit
     STDP=C_spredicted  STDR=C_s_residual  STUDENT=C_student     ;  
    
quit;


/*APPLYING CORREALTION TO KNOW WHICH VARIABLES ARE HIGHLY CORRELATED*/
proc corr data=h1b out=corr;
var CASE_SUBMITTED_MONTH CASE_SUBMITTED_YEAR DECISION_MONTH DECISION_YEAR EMPLOYER_NAME EMPLOYER_STATE SOC_NAME 
	NAICS_CODE FULL_TIME_POSITION PREVAILING_WAGE WILLFUL_VIOLATOR WORKSITE_STATE
	WORKSITE_POSTAL_CODE CASE_STATUS;
run; 

/*APPLYING PRICIPAL COMPONENT ANALYSIS*/
proc princomp data=H1B out=h1b_pca;
var CASE_SUBMITTED_MONTH CASE_SUBMITTED_YEAR DECISION_MONTH DECISION_YEAR EMPLOYER_NAME EMPLOYER_STATE SOC_NAME 
	NAICS_CODE FULL_TIME_POSITION PREVAILING_WAGE     
	WILLFUL_VIOLATOR WORKSITE_STATE WORKSITE_POSTAL_CODE CASE_STATUS;
run;

/*PCA USING FACTOR ANALYSIS*/
proc factor data=H1B out=h1b_pca_factor method=prin scree;
var CASE_SUBMITTED_MONTH CASE_SUBMITTED_YEAR DECISION_MONTH DECISION_YEAR EMPLOYER_NAME EMPLOYER_STATE SOC_NAME 
	NAICS_CODE FULL_TIME_POSITION PREVAILING_WAGE     
	WILLFUL_VIOLATOR WORKSITE_STATE WORKSITE_POSTAL_CODE CASE_STATUS;
run;

/*applying logistic regression*/ 
proc logistic data=h1b outest=betas covout  plots(only)=roc;
class PW_UNIT_OF_PAY;
model CASE_STATUS(event='1')= CASE_SUBMITTED_MONTH CASE_SUBMITTED_YEAR DECISION_MONTH DECISION_YEAR EMPLOYER_NAME 
	EMPLOYER_STATE SOC_NAME NAICS_CODE FULL_TIME_POSITION PREVAILING_WAGE WILLFUL_VIOLATOR WORKSITE_STATE
	WORKSITE_POSTAL_CODE
	/ selection=stepwise slentry=0.05 slstay=0.35 details lackfit;

	output out=pred p=phat lower=lcl upper=ucl 
	predprob=(individual crossvalidate);
run;

/* divide in test train dataset */
n=ranuni(8);
proc sort data=h1b;
  by n;
  data training testing;
   set h1b nobs=nobs;
   if _n_<=.7*nobs then output training;
    else output testing;
run;

/*training the model*/
proc logistic data=training plots=all;
model case_status(event="1") = CASE_SUBMITTED_MONTH  DECISION_MONTH  EMPLOYER_NAME 
	EMPLOYER_STATE SOC_NAME NAICS_CODE  PREVAILING_WAGE WILLFUL_VIOLATOR WORKSITE_STATE
	WORKSITE_POSTAL_CODE;
score data=testing out=mypreds;
run;

/*scoring the model*/
proc logistic data=training plots=all;
model CASE_STATUS(event="1") =  CASE_SUBMITTED_MONTH CASE_SUBMITTED_YEAR DECISION_MONTH DECISION_YEAR EMPLOYER_NAME 
	EMPLOYER_STATE SOC_NAME NAICS_CODE FULL_TIME_POSITION PREVAILING_WAGE WILLFUL_VIOLATOR WORKSITE_STATE
	WORKSITE_POSTAL_CODE ;
score data=testing out=mypreds;
run;


