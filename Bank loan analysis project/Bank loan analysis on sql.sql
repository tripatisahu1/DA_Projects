  create database project1;
  use project1;
  select * from sales_csv;
  
  
  select count(*)total_row from sales_csv;
  select count(*)home_ownership from sales_csv;
  
  /*1) kpi'1 query by abhinav  */
  select
  year,
  sum(loan_amnt)as total_loan
  from sales_csv
  group by year
  order by 1;
  
  
  /*2) revoling balance by grade and sub-grade*/
  select 
  grade,
  sub_grade,
 sum( `Finance_2.revol_bal`)as revol_bal
  from sales_csv
  group by grade,sub_grade
  order by grade;
  
  /*3)verification status */
  select 
  verification_status as verification,
concat(format(sum(`Finance_2.total_pymnt`)/1000,2),' K') as total_payment
  from sales_csv
  group by verification
  order by 1;
  

  
 /*4)state wise last_credit*/
  select
  addr_state,
  `Finance_2.last_credit_pull_d` as last_credit_d,
  loan_status
  from sales_csv;
  
  /*5)home onwership vs last payment date*/
  select
  home_ownership as home_ownership,
  CONCAT(FORMAT(SUM(`finance_2.last_pymnt_d` )/1000,2),' K')as last_payment_date
  from sales_csv
  group by home_ownership,`finance_2.last_pymnt_d`
  order by (last_payment_date)desc ; 
  
  /*extra query*/
  /*1)PURPOSE*/
  select 
  purpose,
  count(loan_status)as count_of_loan_status,
  concat(format(avg(loan_amnt)/1000,2),' k') as average_of_loan_amount
  from sales_csv
  group by purpose; 
  
  select
   year,
   home_ownership,
  loan_amnt,
  loan_status
  from sales_csv
  order by year;
  
  /*TOTAL REVOL*/
  select 
  CONCAT(FORMAT(sum(`finance_2.revol_bal`)/1000,2),'K') as TOTAL_REVOL
  from sales_csv;
  
  /*TOTAL LOAN*/
  SELECT
 CONCAT(FORMAT(SUM(loan_amnt)/1000,2),'K') as total_laon
  from sales_csv;
  
  /*NO. OF CUSTOMER*/
  SELECT 
  COUNT(MEMBER_ID) AS NO_OF_CUSTOMER
  FROM SALES_CSV;
  
  /*TOTAL FUNDED AMOUNT*/
  SELECT
  CONCAT(format(SUM(FUNDED_AMNT)/1000,2),'K') AS TOTAL_FUND_AMNT
  FROM SALES_CSV;
  
  
  
  

  
  
  