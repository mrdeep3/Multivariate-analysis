#Clean Memory
rm(list=ls())

#Read Data Set
H1b<-read.csv("D:/sem1/Multivariate/652_project/h1b-disclosure-dataset/H1B Disclosure Dataset Files/1. Master H1B Dataset.csv",na.strings=c(""),stringsAsFactors = FALSE)
#View(H1b)

#removing missing values
#na.omit(H1b)

#combining date month and year
H1b$CASE_SUBMITTED_DATE<-as.Date(with(H1b, paste(H1b$CASE_SUBMITTED_YEAR, H1b$CASE_SUBMITTED_MONTH, H1b$CASE_SUBMITTED_DAY, sep='-')),
                                "%Y-%m-%d")
H1b$CASE_DECISION_DATE<-as.Date(with(H1b, paste(H1b$DECISION_YEAR, H1b$DECISION_MONTH, H1b$DECISION_DAY, sep='-')),
                               "%Y-%m-%d")

#dropping unwanted columns
H1b<-H1b[,-c(1:6, 13, 17:22),drop=FALSE]
#View(H1b)
na.omit(H1b)
#View(H1b)

H1b <- H1b[H1b$EMPLOYER_COUNTRY %in% c("UNITED STATES OF AMERICA"),]
H1b <- H1b[H1b$VISA_CLASS %in% c("H1B"),]
H1b <- H1b[H1b$PW_UNIT_OF_PAY %in% c("Year"),]


#converting character values to numeric
H1b$FULL_TIME_POSITION<-ifelse(H1b$FULL_TIME_POSITION=="Y",1,0)
H1b$H.1B_DEPENDENT<-ifelse(H1b$H.1B_DEPENDENT=="Y",1,0)
H1b$WILLFUL_VIOLATOR<-ifelse(H1b$WILLFUL_VIOLATOR=="Y",1,0)
H1b$CASE_STATUS<-ifelse(H1b$CASE_STATUS=="CERTIFIED",1,0)

#state label

H1b$EMPLOYER_STATE<-factor(H1b$EMPLOYER_STATE,levels=c("AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL",
                                                       "GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA",
                                                       "MD","ME","MI","MN","MO","MP","MS","MT","NC","ND","NE",
                                                       "NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI",
                                                       "SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"), labels=c(1,2,3,4,5,6,7,8,9,
                                                                                                                      10,11,12,13,14,15,
                                                                                                                      16,17,18,19,20,21,
                                                                                                                      22,23,24,25,26,27,
                                                                                                                      28,29,30,31,32,33,
                                                                                                                      34,35,36,37,38,39,
                                                                                                                      40,41,42,43,44,45,
                                                                                                                      46,47,48,49,50,51,
                                                                                                         52,53,54,55,56))



H1b$WORKSITE_STATE<-factor(H1b$WORKSITE_STATE,levels=c("AK","AL","AR","AS","AZ","CA","CO","CT","DC","DE","FL",
                                                       "GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA",
                                                       "MD","ME","MI","MN","MO","MP","MS","MT","NC","ND","NE",
                                                       "NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","RI",
                                                       "SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"), labels=c(1,2,3,4,5,6,7,8,9,
                                                                                                                              10,11,12,13,14,15,
                                                                                                                              16,17,18,19,20,21,
                                                                                                                              22,23,24,25,26,27,
                                                                                                                              28,29,30,31,32,33,
                                                                                                                              34,35,36,37,38,39,
                                                                                                                              40,41,42,43,44,45,
                                                                                                                              46,47,48,49,50,51,
                                                                                                                              52,53,54,55,56))

H1b$EMPLOYER_NAME <- as.numeric(factor(H1b$EMPLOYER_NAME))


H1b$SOC_NAME <- as.numeric(factor(H1b$SOC_NAME))

View(H1b)



write.csv(H1b,"D:/sem1/Multivariate/652_project/cleaned_data_final_2.csv")
