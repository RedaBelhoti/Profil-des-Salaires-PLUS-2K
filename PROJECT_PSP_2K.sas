
/* Prise en main et nettoyage du fichier*/
/*visualisation des variables*/
proc contents data=siadcg22020;
run;
/*nettoyage de la bse : valeures manquantes*/
/*a-var qualitatives*/ 
proc freq data=siadcg22020; tables CFA/missing; run;
proc freq data=siadcg22020; tables Q1/missing; run;
proc freq data=siadcg22020; tables PHD/missing; run;
proc freq data=siadcg22020; tables CA9C/missing; run;
proc freq data=siadcg22020; tables CA10C/missing; run;
proc freq data=siadcg22020; tables CA11/missing; run;
proc freq data=siadcg22020; tables CA12/missing; run;

/*var quantitatives*/
proc univariate  data=siadcg22020; var AGE13; run;
proc univariate  data=siadcg22020; var SALPRSFIN; run;

/*solution des valeurs manquantes*/
data siadcg220201;
set siadcg22020;
if CA11 =. then delete ;/*suppr val manq*/
if CA12 =. then delete ;/*suppr val manq*/
run;

/*données aberrantes*/
/*var salaire*/
proc univariate data=siadcg22020;
var SALPRSFIN;
histogram SALPRSFIN;run;
/*var age*/
proc univariate data=siadcg22020;
var AGE13;
histogram AGE13;run;

/*solution des valeurs abberantes*/
/*prendre en comprte la var age à partir de 14 ans jusqu'au 35ans*/
/*pour la var salaire à partir du smic net en 2016 :1143€ 
et vu que 5% des salaires repésente un montatnt moins de 1142€*/
data siadcg220201;
set siadcg22020;
if  3500 =>SALPRSFIN <= 1143 then delete ;
if AGE13<14 and AGE13>35 then delete ;
run;

/* catégorie d'age*/

data siadcg220201;
set siadcg22020;
if AGE13=<20 then age=1;
else if AGE13>20 and AGE13=<25 then age=2;
else if AGE13>25 and AGE13=<30  then age=3;
else if AGE13>30 and AGE13=<35  then age=4;
run;

data base;
set siadcg220201;
run;

/*recodage et regroupement de la Variable PHD:diplome*/ 
data base;
set base; 
if phd="01" then phd1=1;
else if phd="02I" then phd1=2;
else if phd="02T" then phd1=2;
else if phd="03I" then phd1=3; 
else if  phd="03T" then phd1=3;
else if phd="04I" then phd1=3;
else if  phd="04T" then phd1=3; 
else if  phd="05" then phd1=3;
else if phd="06I" then phd1=4 ;
else if phd="07T" then phd1=4;
else if  phd="06T" then phd1=4;
else if phd="07I" then phd1=4;
else if phd="08" then phd1=5;
else if phd="09L"  then phd1=6;
else if phd="09M" then phd1=6 ;
else if phd="10L" then phd1=6 ;
else if phd="11L" then phd1=6 ;
else if phd="12L" then phd1=6 ;
else if phd="10M" then phd1=6 ;
else if phd="11M" then phd1=6; 
else if phd="12M" then phd1=6;
else if phd="13L" then phd1=7; 
else if phd="14L" then phd1=7; 
else if phd="13M" then phd1=7; 
else if phd="14M" then phd1=7; 
else if phd="15" then phd1=7; 
else if phd="16" then phd1=7; 
else if phd="17" then phd1=8; 
else if phd="18L" then phd1=8;
else if phd="18M" then phd1=8;
run;

/*regrouepemen,t de la variable CA9C: position pro du père*/
data base;
set base; 
if ca9c=7 or ca9c=8 or ca9c=9 then ca9c=6;
if ca9c=5 or ca9c=6 then ca9c=5;
run;
/*regrouepement de la variable CA10C: position pro de La Mère*/
data base;
set base; 
if ca10c=7 or ca10c=8 or ca10c=9 then ca10c=6;
if ca10c=5 or ca10c=6 then ca10c=5;
run;
/*renomer
CA9C=1 ou CA10C=1 : ouvrier
CA9C=2 ou CA10C=2 :employé
CA9C=3 ou CA10C=3 :Techni_agent_vendeur
CA9C=4 ou CA10C=4 :Cadre_ingénieur
CA9C=5 ou CA10C=5 :Artisan_chef'E_Agri
CA9C=6 ou CA10C=6 :Ne_pas_citer
*/
data base; 
set base;
Drop sal salinf Tranche_age age_moins_20 DIPL DIPL0 DIPL1 DIPL2a DIPL2b DIPL2c DIPL3 DIPL4 DIPL5 DIPL5a DIPL5b DIPL6a DIPL6b DIPL6c DIPL7;
run;

/* variable d’intérêt Y sous forme dichotomique : variable dummy
pour « obtention d’un salaire supérieur à 2000€ ». Situer le seuil de 2000€
dans la distribution des salaires.*/
data base;
set base;
if SALPRSFIN>2000 then Y=1;else Y=0;
run;
/*salaire avant regrouepement*/
proc univariate data=base;
var SALPRSFIN;run;
/*salaire apres regrouepement*/
proc freq data=base; tables Y; run;

/* 4 
 Etudier les liens entre vos variables explicatives.*/
/*CFA Q1 PHD CA9C CA10C CA11 CA12 AGE13*/

proc freq data=base;
tables CFA*Q1/chisq;
tables CFA*PHD/chisq;
tables CFA*CA9C/chisq;
tables CFA*CA10C/chisq;
tables CFA*CA11/chisq;
tables CFA*CA12/chisq;
tables CFA*AGE13/chisq;

tables Q1*PHD/chisq;
tables Q1*CA9C/chisq;
tables Q1*CA10C/chisq;
tables Q1*CA12/chisq;
tables Q1*CA11/chisq;
tables Q1*AGE13/chisq;

tables PHD*CA9C/chisq;
tables PHD*CA10C/chisq;
tables PHD*CA11/chisq;
tables PHD*CA12/chisq;
tables PHD*AGE13/chisq;

tables CA9C*CA10C/chisq;
tables CA9C*CA11/chisq;
tables CA9C*CA12/chisq;
tables CA9C*AGE13/chisq;

tables CA10C*CA11/chisq;
tables CA10C*CA12/chisq;
tables CA10C*AGE13/chisq;

tables CA11*CA12/chisq;
tables CA11*AGE13/chisq;

tables CA12*AGE13/chisq;

run;

/* b- Etudier les liens entre vos variables explicatives et votre variable expliquée*/

proc freq data=base;
tables y*CFA/chisq;
tables y*Q1/chisq;
tables y*PHD/chisq;
tables y*CA9C/chisq;
tables y*CA10C/chisq;
tables y*CA11/chisq;
tables y*CA12/chisq;
tables y*age/chisq;
run;



/*codage des variables*/
 *codage des variables en dummy;

/*renomer
CA9C=1 ou CA10C=1 : ouvrier
CA9C=2 ou CA10C=2 :employé
CA9C=3 ou CA10C=3 :Techni_agent_vendeur
CA9C=4 ou CA10C=4 :Cadre_ingénieur
CA9C=5 ou CA10C=5 :Artisan_chef'E_Agri
CA9C=6 ou CA10C=6 :Ne_pas_citer
*/
/*position pro père*/

data base; set base; 
if ca9c=1 then P_ouvrier=1 ;else P_ouvrier=0;
if ca9c=2 then P_employe=1 ;else P_employe=0;
if ca9c=3 then P_Techni_agent_vendeur=1 ;else P_Techni_agent_vendeur=0;
if ca9c=4 then P_Cadre_ingenieur=1 ;else P_Cadre_ingenieur=0;
if ca9c=5 then P_Artisan_chef=1; else P_Artisan_chef=0;
run;
/*position pro mère*/
data base; set base; 
if ca10c=1 then M_ouvrier=1 ;else M_ouvrier=0;
if ca10c=2 then M_employe=1 ;else M_employe=0;
if ca10c=3 then M_Techni_agent_vendeur=1 ;else M_Techni_agent_vendeur=0;
if ca10c=4 then M_Cadre_ingenieur=1 ;else M_Cadre_ingenieur=0;
if ca10c=5 then M_Artisan_chef=1; else M_Artisan_chef=0;
run;


/*Nv etude père*/
data base; set base ;
if ca11=1 then NVP_non_diplome=1 ;else NVP_non_diplome=0;
if ca11=2 then NVP_cap_bep=1 ;else NVP_cap_bep=0;
if ca11=3 then NVP_Bac=1 ;else NVP_Bac=0;
if ca11=4 then NVP_Bac_plus_2=1 ;else NVP_Bac_plus_2=0;
if ca11=5 then NVP_Bac_plus_3_4=1 ;else NVP_Bac_plus_3_4=0;
if ca11=6 then NVP_Bac_plus_5=1 ;else NVP_Bac_plus_5=0;
if ca11=7 then NVP_Ne_pas_citer=1 ;else NVP_Ne_pas_citer=0;
run;

/*Nv etude Mère*/
data base; set base ;
if ca12=1 then NVM_non_diplome=1 ;else NVM_non_diplome=0;
if ca12=2 then NVM_cap_bep=1 ;else NVM_cap_bep=0;
if ca12=3 then NVM_Bac=1 ;else NVM_Bac=0;
if ca12=4 then NVM_Bac_plus_2=1 ;else NVM_Bac_plus_2=0;
if ca12=5 then NVM_Bac_plus_3_4=1 ;else NVM_Bac_plus_3_4=0;
if ca12=6 then NVM_Bac_plus_5=1 ;else NVM_Bac_plus_5=0;
if ca12=7 then NVM_Ne_pas_citer=1 ;else NVM_Ne_pas_citer=0;
run;
/* PLUS HAUT DIPLOME OBTENU */

/* renomer
phd1=1: non_diplome
phd1=2: cap_bep
phd1=3: Bac
phd1=4: Bac_plus_2_Bts_Dut
phd1=5: Bac_plus_2_3_sante
phd1=6: Bac_plus_3_4_hors_sante
phd1=7: Bac_plus_5_M2
phd1=8: Doctorat
*/


data base; set base;
if phd1=1 then non_diplome=1; else non_diplome=0;
if phd1=2 then cap_bep=1 ; else cap_bep=0;
if phd1=3 then Bac=1 ; else Bac=0;
if phd1=4 then Bac_plus_2_Bts_Dut=1 ; else Bac_plus_2_Bts_Dut=0;
if phd1=5 then Bac_plus_2_3_sante=1 ; else Bac_plus_2_3_sante=0;
if phd1=6 then Bac_plus_3_4_hors_sante=1 ; else Bac_plus_3_4_hors_sante=0;
if phd1=7 then Bac_plus_5_M2=1; else Bac_plus_5_M2=0;
if phd1=8 then Doctorat=1; else Doctorat=0;
run;

data base; set base;
if age=1 then age_inf_20=1; else age_inf_20=0;
if age=2 then age_21_25=1; else age_21_25=0;
if age=3 then age_26_30=1; else age_26_30=0;
if age=4 then age_31_35=1; else age_31_35=0;
run;

/*variable femmes*/
data base; set base; Femme=q1-1;run;
/*variable apprentissage */
data base; set base; Apprenti=cfa-1;run; 

/*choix des modalites de references*/
proc freq data=base; tables age; run;
proc freq data=base; tables phd1; run;
proc freq data=base; tables ca9c; run;


/*regression*/
/*SALPRSFIN*/
proc reg data=base plots(maxpoints=none);
model SALPRSFIN = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat /dw ;run;
/*Y*/
proc reg data=base plots(maxpoints=none);
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat /dw white ;run;


/*********choix des variables significatives ********/
proc reg data=base plots(maxpoints=none);
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35
					Femme /*Apprenti*/
							/*P_ouvrier P_employe P_Techni_agent_vendeur P_Cadre_ingenieur P_Artisan_chef*/ 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat /dw ;run;
/*stepwise*/
proc reg data=base plots(maxpoints=none);
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat /dw selection =stepwise ;run;
proc reg data=base plots(maxpoints=none);
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat /dw selection =backward ;run;
/************************************************************************************************************************************************************************************************/
/*modèle_Probit*/
proc logistic data=base;
class non_diplome cap_bep Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat age_inf_20 age_26_30 age_31_35 Femme Apprenti; 
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ link=probit;run;
/*modèle_Logit*/
proc logistic data=base;
class P_ouvrier P_employe P_Cadre_ingenieur P_Artisan_chef  age_31_35 ;
model Y (ref='0')= age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ link=LOGIT;run;

/*****************************************************************************************************************************************************************************************************/
/*Matrice de confusion*/
/*model Y*/
proc reg data=base plots(maxpoints=none);
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat   ;
OUTPUT OUT=confusion1 p=prev; run;quit;
									
DATA confusion_Y;
SET confusion1;
IF prev<0.5 THEN prev=0;
ELSE prev=1;
KEEP Y prev;
RUN;
PROC FREQ DATA=confusion_Y;
TABLES Y*prev;
RUN;
/*************************************************/
/*test de GLEISJER*/
proc reg data=base plots(maxpoints=none);
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat /dw ;
									output out=TabR r=residu;
run;
data gleisjer;
set TabR;
absresid = ABS(residu);
carresid = residu*residu;
run;

proc reg data=gleisjer;
model absresid= Y;
run;
proc reg data=gleisjer;
model carresid = Y;
run;
/*matrice de confusion********************/
/*model Y probit*/
proc logistic data=base;
model Y (ref='0')= age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ link=probit;
OUTPUT OUT=confusion2 p=prev; run;quit;
DATA confusion_Y_probit;
SET confusion2;
IF prev<=0.5 THEN prev=0;
ELSE prev=1;
KEEP Y prev;
RUN;
PROC FREQ DATA=confusion_Y_probit;
TABLES Y*prev;
RUN;
/*****************************/
/*pseudo R carré de Mcfadden */
proc qlim data=base;
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ discrete(d=probit);run;
proc qlim data=base;
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ discrete(d=logit);run;

/*****************************/
/*Test de wald et courbe de Roc */
 PROC LOGISTIC DATA=base desc ;
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ link=probit Rsquare outroc=rc;
test Apprenti=0;
test Femme=0;
test  P_ouvrier=P_employe=P_Cadre_ingenieur=P_Artisan_chef=0 ;
test age_inf_20=age_26_30=age_31_35=0 ;
test	non_diplome=cap_bep=Bac_plus_2_Bts_Dut=Bac_plus_2_3_sante=Bac_plus_3_4_hors_sante=Bac_plus_5_M2=Doctorat=0;
output out=predictionwald p=predw;
run ;
 PROC LOGISTIC DATA=base desc ;
model Y = age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ link=logit Rsquare outroc=rc;
test Apprenti=0;
test Femme=0;
test  P_ouvrier=P_employe=P_Cadre_ingenieur=P_Artisan_chef=0 ;
test age_inf_20=age_26_30=age_31_35=0 ;
test	non_diplome=cap_bep=Bac_plus_2_Bts_Dut=Bac_plus_2_3_sante=Bac_plus_3_4_hors_sante=Bac_plus_5_M2=Doctorat=0;
output out=predictionwald p=predw;
run ;
/*****************************/	

/*model Y Logit*/
proc logistic data=base;
model Y (ref='0')= age_inf_20 /*age_21_25*/ age_26_30 age_31_35 
					Femme Apprenti 
							P_ouvrier P_employe /*P_Techni_agent_vendeur*/ P_Cadre_ingenieur P_Artisan_chef 
									non_diplome cap_bep /*Bac*/ Bac_plus_2_Bts_Dut Bac_plus_2_3_sante Bac_plus_3_4_hors_sante Bac_plus_5_M2 Doctorat/ link=LOGIT;
OUTPUT OUT=confusion3 p=prev; run;quit;
									
DATA confusion_Y_Logit;
SET confusion3;
IF prev<=0.5 THEN prev=0;
ELSE prev=1;
KEEP Y prev;
RUN;
PROC FREQ DATA=confusion_Y_Logit;
TABLES Y*prev;
RUN;




/****************************************************************************************************************************************************************************************************/

