PROC import DATA= WORK.BASE 
            OUTFILE= "C:\Users\redab\OneDrive\Bureau\baseevq.xls" 
            DBMS=EXCEL REPLACE;
     SHEET="baseevq"; 
RUN;
