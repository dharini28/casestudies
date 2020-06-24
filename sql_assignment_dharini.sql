create schema Assignment;

use assignment;
# Import the CSV files
-- the csv files are imported in sql using table data import wizard
####################################################################################################
# Date attribute in all 6 tables are in text format, we are converting to date format
-- bajaj_auto
UPDATE `bajaj_auto`
SET `date` = STR_TO_DATE(`date`,'%d-%M-%Y');

alter table bajaj_auto 
modify column `date` date;

-- eicher_motors
UPDATE `eicher_motors`
SET `date` = STR_TO_DATE(`date`,'%d-%M-%Y');

alter table eicher_motors
modify column `date` date;

-- hero_motorcorp
UPDATE `hero_motocorp`
SET `date` = STR_TO_DATE(`date`,'%d-%M-%Y');

alter table hero_motocorp
modify column `date` date;

-- infosys
UPDATE `infosys`
SET `date` = STR_TO_DATE(`date`,'%d-%M-%Y');

alter table infosys
modify column `date` date;

-- tcs
UPDATE `tcs`
SET `date` = STR_TO_DATE(`Date`,'%d-%M-%Y');

alter table tcs 
modify column `date` date;

-- tvs_motors
UPDATE `tvs_motors`
SET `date` = STR_TO_DATE(`date`,'%d-%M-%Y');

alter table tvs_motors
modify column `date` date;

-- Date columns in all 6 tables are converted from text to date format

###################################################################################################

# Question 1 #
-- create table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. 
-- (This has to be done for all 6 stocks)

## 1.BAJAJ1 ##
create table bajaj1 as
(select `Date`,`Close Price`,
 CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 20 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 19 PRECEDING) 
	ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 50 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 49 PRECEDING) 
	ELSE NULL 
END AS `50 Day MA`
from bajaj_auto);

select * from bajaj1;

## 2.EICHER1 ##
create table eicher1 as
(select `Date`,`Close Price`,
 CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 20 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 19 PRECEDING) 
	ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 50 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 49 PRECEDING) 
	ELSE NULL 
END AS `50 Day MA`
from eicher_motors);

select * from eicher1;

## 3.HERO1 ##
create table hero1 as
(select `Date`,`Close Price`,
 CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 20 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 19 PRECEDING) 
	ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 50 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 49 PRECEDING) 
	ELSE NULL 
END AS `50 Day MA`
from hero_motocorp);

select * from hero1;

## 4.INFOSYS1 ##
create table infosys1 as
(select `Date`,`Close Price`,
 CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 20 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 19 PRECEDING) 
	ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 50 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 49 PRECEDING) 
	ELSE NULL 
END AS `50 Day MA`
from infosys);

select * from infosys1;

## 5.TCS1 ##
create table tcs1 as
(select `Date`,`Close Price`,
 CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 20 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 19 PRECEDING) 
	ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 50 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 49 PRECEDING) 
	ELSE NULL 
END AS `50 Day MA`
from tcs);

select * from tcs1;

## 6.TVS1 ##
create table tvs1 as
(select `Date`,`Close Price`,
 CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 20 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 19 PRECEDING) 
	ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
	ROW_NUMBER() OVER (ORDER BY DATE asc) >= 50 THEN 
		avg(`Close Price`) over(order by Date asc ROWS 49 PRECEDING) 
	ELSE NULL 
END AS `50 Day MA`
from tvs_motors);

select * from tvs1;

##################################################################################################

# Question 2 #
-- Create a master table containing the date and close price of all the six stocks.
-- (Column header for the price is the name of the stock)

create table master_stocks as
(select bajaj_auto.date as Date,
 bajaj_auto.`close price` as bajaj, tcs.`close price` as tcs,
 tvs_motors.`close price` as tvs, infosys.`close price` as infosys,
 eicher_motors.`close price` as eicher, hero_motocorp.`close price` as hero    
from  bajaj_auto
inner join tcs on bajaj_auto.date = tcs.date
inner join tvs_motors on bajaj_auto.date = tvs_motors.date
inner join infosys on bajaj_auto.date = infosys.date
inner join eicher_motors on bajaj_auto.date = eicher_motors.date
inner join hero_motocorp on bajaj_auto.date = hero_motocorp.date
);

select * from master_stocks
order by date;

##############################################################################################################

# Question 3 #
-- Use the table created in Part(1) to generate buy and sell signal. 
-- Store this in another table named 'bajaj2'. Perform this operation for all stocks.
## 1.bajaj2 ##

create table bajaj2 as
(select `Date`, `Close Price`,
CASE 
	WHEN (`20 Day MA`>`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) < (lag(`50 Day MA`,1) over (order by date)))
        then 'BUY'
    WHEN (`20 Day MA`<`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) > (lag(`50 Day MA`,1) over (order by date)))
		then 'SELL'
    ELSE 'HOLD'
END AS `Signal` 
from bajaj1);

select * from bajaj2
order by date;

## 2.EICHER2 ##

create table eicher2 as
(select `Date`, `Close Price`,
CASE 
	WHEN (`20 Day MA`>`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) < (lag(`50 Day MA`,1) over (order by date)))
        then 'BUY'
    WHEN (`20 Day MA`<`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) > (lag(`50 Day MA`,1) over (order by date)))
		then 'SELL'
    ELSE 'HOLD'
END AS `Signal` 
from eicher1);

select * from eicher2
order by date;

## 3.HERO2 ##

create table hero2 as
(select `Date`, `Close Price`,
CASE 
	WHEN (`20 Day MA`>`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) < (lag(`50 Day MA`,1) over (order by date)))
        then 'BUY'
    WHEN (`20 Day MA`<`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) > (lag(`50 Day MA`,1) over (order by date)))
		then 'SELL'
    ELSE 'HOLD'
END AS `Signal` 
from hero1);

select * from hero2
order by date;

## 4. INFOSYS2 ##

create table infosys2 as
(select `Date`, `Close Price`,
CASE 
	WHEN (`20 Day MA`>`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) < (lag(`50 Day MA`,1) over (order by date)))
        then 'BUY'
    WHEN (`20 Day MA`<`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) > (lag(`50 Day MA`,1) over (order by date)))
		then 'SELL'
    ELSE 'HOLD'
END AS `Signal` 
from infosys1);

select * from infosys2
order by date;

## 5. TCS2 ##

create table tcs2 as
(select `Date`, `Close Price`,
CASE 
	WHEN (`20 Day MA`>`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) < (lag(`50 Day MA`,1) over (order by date)))
        then 'BUY'
    WHEN (`20 Day MA`<`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) > (lag(`50 Day MA`,1) over (order by date)))
		then 'SELL'
    ELSE 'HOLD'
END AS `Signal` 
from tcs1);

select * from tcs2
order by date;

## 6. TVS2 ##

create table tvs2 as
(select `Date`, `Close Price`,
CASE 
	WHEN (`20 Day MA`>`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) < (lag(`50 Day MA`,1) over (order by date)))
        then 'BUY'
    WHEN (`20 Day MA`<`50 Day MA`)
    and ((lag(`20 Day MA`,1) over (order by date)) > (lag(`50 Day MA`,1) over (order by date)))
		then 'SELL'
    ELSE 'HOLD'
END AS `Signal` 
from tvs1);

select * from tvs2
order by date;

##############################################################################################################

# Question 4 #
-- Create a User defined function, that takes the date as input and returns the signal 
-- for that particular day (Buy/Sell/Hold) for the Bajaj stock

delimiter $$
create function udfBajajStock(input_date date)
  returns varchar(25)
  deterministic
begin  
  declare output_signal varchar(20);
 
  select bajaj2.signal into output_signal
  from bajaj2
  where date = input_date;
 
  return output_signal ;
  end
 
$$ delimiter ;

select udfBajajStock('2015-08-24') as stock_signal;

##########################################################################################
-- stock analysis
## bajaj
select *
from bajaj2
where `signal` = 'Buy';

select *
from bajaj2
where `signal` = 'sell';

## eicher
select *
from eicher2
where `signal` = 'Buy';

select *
from eicher2
where `signal` = 'sell';

## hero
select *
from hero2
where `signal` = 'Buy';

select *
from hero2
where `signal` = 'sell';

## infosys
select *
from infosys2
where `signal` = 'Buy';

select *
from infosys2
where `signal` = 'sell';

## tcs
select *
from tcs2
where `signal` = 'Buy';

select *
from tcs2
where `signal` = 'sell';

## tvs
select *
from tvs2
where `signal` = 'Buy';

select *
from tvs2
where `signal` = 'sell';

###############################################################################################
-- end