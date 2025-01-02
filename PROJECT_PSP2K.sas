/*TD1*/
/*2- Prise en main et nettoyage du fichier*/
/*visualisation des variables*/
proc contents data=tmp1.siadcg22020;
run;
/* I - nettoyage de la bse : valeures manquantes*/
/*a-var qualitatives*/ 
proc freq data=tmp1.siadcg22020; tables CFA/missing; run;
proc freq data=tmp1.siadcg22020; tables Q1/missing; run;
proc freq data=tmp1.siadcg22020; tables PHD/missing; run;
proc freq data=tmp1.siadcg22020; tables CA9C/missing; run;
proc freq data=tmp1.siadcg22020; tables CA10C/missing; run;
proc freq data=tmp1.siadcg22020; tables CA11/missing; run;
proc freq data=tmp1.siadcg22020; tables CA12/missing; run;

/*b-var quantitatives*/
proc univariate  data=tmp1.siadcg22020; var AGE13; run;
proc univariate  data=tmp1.siadcg22020; var SALPRSFIN; run;

/*solution des valeurs manquantes*/
data tmp1.siadcg22020;
set tmp1.siadcg22020;
if CA11 =. then delete ;/*suppr val manq*/
if CA12 =. then delete ;/*suppr val manq*/
run;

/*données aberrantes*/
/*var salaire*/
proc univariate data=tmp1.siadcg22020;
var SALPRSFIN;
histogram SALPRSFIN;run;
/*var age*/
proc univariate data=tmp1.siadcg22020;
var AGE13;
histogram AGE13;run;

/*solution des valeurs abberantes*/
/*prendre en comprte la var age à partir de 18 ans jusqu'au 35ans*/
/*pour la var salaire à partir du smic net en 2016 :1143€ 
et vu que 5% des salaires repésente un montatnt moins de 1142€*/
data tmp1.siadcg22020;
set tmp1.siadcg22020;
if  3575 =>SALPRSFIN <= 1143 then delete ;
if AGE13<14 and AGE13>35 then delete ;
run;

/*c- catégorie d'age*/

data tmp1.siadcg22020;
set tmp1.siadcg22020;
if AGE13=<20 then Tranche_age=1;
else if AGE13>20 and AGE13=<25 then Tranche_age=2;
else if AGE13>25  then Tranche_age=3;
run;
proc univariate  data=tmp1.siadcg22020; var Tranche_age; run;

/*3 - B) variable d’intérêt Y sous forme dichotomique : variable dummy
pour « obtention d’un salaire supérieur à 2000€ ». Situer le seuil de 2000€
dans la distribution des salaires.*/
data tmp1.siadcg22020;
set tmp1.siadcg22020;
if SALPRSFIN>2000 then salinf=1;else salinf=0;
run;
proc freq data=tmp1.siadcg22020; tables salinf; run;
/* 4 
a) Etudier les liens entre vos variables explicatives.*/
/*CFA Q1 PHD CA9C CA10C CA11 CA12 AGE13*/

proc freq data=tmp1.siadcg22020;
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

proc freq data=tmp1.siadcg22020;
tables salinf*CFA/chisq;
tables salinf*Q1/chisq;
tables salinf*PHD/chisq;
tables salinf*CA9C/chisq;
tables salinf*CA10C/chisq;
tables salinf*CA11/chisq;
tables salinf*CA12/chisq;
tables salinf*Tranche_age/chisq;
run;
/*base*/
data base;
set tmp1.siadcg22020;
run;

/*modalité à faibles occurrences */
data base;
set base; 
if phd="07I" then phd="06I";run;
data base;
set base; 
if phd="11M" or phd="12M" then phd="10M";run;
data base;
set base; 
if phd="17" or phd="18M" or phd="18L" then phd="18";run;
data base;
set base; 
if  phd="14L" then phd="13L";run;
data base;
set base; 
if  phd="14M" then phd="13M";run;
data base;
set base; 
if  phd="11L" then phd="10L";run;
data base;
set base; 
drop sale;
run;
/*recodage*/ 

data base;
set base; 
if phd="01" then phd1=1;
else if phd="02I" then phd1=2;
else if phd="02T" then phd1=2;
else if phd="03I" then phd1=2; 
else if  phd="03T" then phd1=2;
else if phd="04I" then phd1=2;
else if  phd="04T" then phd1=2; 
else if  phd="05" then phd1=2;
run;
data base;
set base; 
if phd="06I" then phd1=3 ;
else if phd="07T" then phd1=3;
else if  phd="06T" then phd1=3 ;
else if phd="07I" then phd1=3 ;
else if phd="08" then phd1=3;
else if phd="09L"  then phd1=3;
else if phd="09M" then phd1=3 ;
else if phd="10L" then phd1=3 ;
else if phd="11L" then phd1=3 ;
else if phd="12L" then phd1=3 ;
else if phd="10M" then phd1=3 ;
else if phd="11M" then phd1=3; 
else if phd="12M" then phd1=3;
run;
data base;
set base; 
if phd="13L" then phd1=4; 
else if phd="14L" then phd1=4; 
else if phd="13M" then phd1=4; 
else if phd="14M" then phd1=4; 
else if phd="15" then phd1=4; 
else if phd="16" then phd1=4; 
else if phd="18" then phd1=4;
run;
/*codage des variables*/
 *codage des variables en dummy;
data base; set base; 
if ca9c=1 then ca9c1=1 ;else ca9c1=0;
if ca9c=2 then ca9c2=1 ;else ca9c2=0;
if ca9c=3 then ca9c3=1 ;else ca9c3=0;
if ca9c=4 then ca9c4=1 ;else ca9c4=0;
if ca9c=5 then ca9c5=1; else ca9c5=0;
if ca9c=6 then ca9c6=1 ;else ca9c6=0;
if ca9c=7 then ca9c7=1 ;else ca9c7=0;run;
data base; set base;
if ca10c=1 then ca10c1=1 ;else ca10c1=0;
if ca10c=2 then ca10c2=1 ;else ca10c2=0;
if ca10c=3 then ca10c3=1 ;else ca10c3=0;
if ca10c=4 then ca10c4=1 ;else ca10c4=0;
if ca10c=5 then ca10c5=1; else ca10c5=0;
if ca10c=6 then ca10c6=1 ;else ca10c6=0;
if ca10c=7 then ca10c7=1 ;else ca10c7=0;run;
data base; set base ;
if ca11=1 then ca111=1 ;else ca111=0;
if ca11=2 then ca112=1 ;else ca112=0;
if ca11=3 then ca113=1 ;else ca113=0;
if ca11=4 then ca114=1 ;else ca114=0;
if ca11=5 then ca115=1; else ca115=0;
if ca11=6 then ca116=1 ;else ca116=0;
if ca11=7 then ca117=1 ;else ca117=0;run;
data base; set base;
if ca12=1 then ca121=1 ;else ca121=0;
if ca12=2 then ca122=1 ;else ca122=0;
if ca12=3 then ca123=1 ;else ca123=0;
if ca12=4 then ca124=1 ;else ca124=0;
if ca12=5 then ca125=1; else ca125=0;
if ca12=6 then ca126=1 ;else ca126=0;
if ca12=7 then ca127=1 ;else ca127=0;run;

data base; set base;
if phd1=1 then phd11=1; else phd11=0;
if phd1=2 then phd12=1 ; else phd12=0;
if phd1=3 then phd13=1 ; else phd13=0;
if phd1=4 then phd14=1 ; else phd14=0;run;

data base; set base;
if Tranche_age=1 then Tranche_age1=1; else Tranche_age1=0;
if Tranche_age=2 then Tranche_age2=1; else Tranche_age2=0;
if Tranche_age=3 then Tranche_age3=1; else Tranche_age3=0;run;


data base; set base; q0=q1-1;run;
/*variable femmes*/
data base; set base; cfa0=cfa-1;run; 

/*regression*/

proc reg data=base  plots(maxpoints=none);
model SALPRSFIN = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14 /dw ;run;

proc reg data=base  plots(maxpoints=none);;
model salinf = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14 /dw selection =stepwise;run;

proc reg data=base;
model salinf= Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14 /selection =backward ;run;

/*regression après le traitement*/
proc reg data=base  plots(maxpoints=none);;
model SALPRSFIN = Tranche_age1 Tranche_age3 q0 phd11 /*phd12*/ phd13 phd14/selection =stepwise;run;

/*TD2 question 7*/
proc univariate  data=base; 
var SALPRSFIN; run;

data base;
set base;
sd= 536.430221;
pz=(prev-2000)/sd;
run;

/* GLEISJER */
data gleisjer; 												
set BASE; 												
VAe=abs(resi); 											
e2 = resi**2;

		/* hypothèse 1 : l'écart type est proportionnel à ti */									
		proc reg data = gleisjer; 
		model VAe = prev; 																							
		RUN;

		/* hypothèse 2 : la variance est proportionnelle à ti */
		proc reg data = gleisjer; 
		model e2= prev; 																							
		RUN;

ods pdf close;

/*TD3 */

proc reg data=base ;
model salinf = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14 ;run;



proc logistic data=base;
class Tranche_age1 Tranche_age3 ;
model salinf = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14/ link=probit;
run;



proc logistic data=base;
class Tranche_age1 Tranche_age3 ;
model salinf = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7  /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14/ link=probit;
run;


proc logistic data=base;
class Tranche_age1 Tranche_age3 ;
model salinf = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14/ link=LOGIT;
run;

/*TD4*/
/* Q1 Modele Y*/
PROC REG DATA=base plots(maxpoints=none)
MODEL SALPRSFIN = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14 ;
OUTPUT OUT=confusion p=prev r=residu;
RUN;
QUIT;
data confus;
set confusion;
KEEP SALPRSFIN prev residu;
RUN;
DATA confusion1R;
SET confusion;
IF prev<0.5 THEN prev=0;
ELSE prev=1;
KEEP SALPRSFIN prev;
RUN;
PROC FREQ DATA=confusion1R;
TABLES SALPRSFIN*prev;
RUN;

/*proba probit*/
proc logistic data=base;
class Tranche_age1 Tranche_age3 ;
model salinf = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14/ link=probit ;
OUTPUT OUT=confusionprobit p=prev;
RUN;
QUIT;
data confusprobit;
set confusionprobit;
KEEP obs prev ;
RUN;

/*proba Logit*/
proc logistic data=base;
class Tranche_age1 Tranche_age3 ;
model salinf = Tranche_age1 Tranche_age3 q0 cfa0 /*ca9c1*/ ca9c2 ca9c3 ca9c4 ca9c5 ca9c6 ca9c7 /*ca10c1*/ ca10c2 ca10c3 ca10c4 ca10c5 ca10c6 ca10c7 /*ca121*/ ca122 ca123 ca124 ca125 ca126 ca127 /*ca111*/ ca112 ca113 ca114 ca115 ca116 ca117
phd11 /*phd12*/ phd13 phd14/ link=LOGIT ;
OUTPUT OUT=confusionLOGIT p=prev;
RUN;
QUIT;
data confusLOGIT;
set confusionLOGIT;
KEEP obs prev ;
RUN;
