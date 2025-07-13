

select * from mysql;

-- Build a country Map Table -

Create table Country_Name (Country_Code int unique, Country_Name Varchar(50));

desc country_Name;
Insert into Country_Name values (1,"India"),
								(14,"Australia"),
                                (30,"Brazil"),
                                (37,"Canada"),
                                (94,"Indonesia"),
                                (148,"New Zealand"),
                                (162,"Philippines"),
                                (166,"Qater"),
                                (184,"Singapore"),
                                (191,"Sri Lanka"),
                                (208,"Turkey"),
                                (214,"United Arab Emirates"),
                                (215,"United Kingdom"),
                                (216,"United States Of America");
select * from Country_Name;

insert into country_Name values(189,"South Africa");

select * from zomato;


alter table zomato modify column Datekey_Opening Date;

desc zomato;

 -- Build a Calendar Table using the Column Datekey -- 
 
 Create View Calender1 as select datekey_Opening,
						year(Datekey_Opening) as "Year1",
                        month(Datekey_Opening) as "Month1",
                        monthname(Datekey_Opening) as "Month_Fullname",
                        quarter(datekey_Opening) as "Quarter1",
                        concat(year(datekey_opening),"-",monthname(datekey_opening)) as "Year_Month",
                        weekday(datekey_Opening) as "Weekday",
                        dayname(datekey_Opening) as "Weekdayname",
case when monthname(datekey_opening)='January' then 'FM10' 
when monthname(datekey_opening)='February' then 'FM11'
when monthname(datekey_opening)='March' then 'FM12'
when monthname(datekey_opening)='April'then'FM1'
when monthname(datekey_opening)='May' then 'FM2'
when monthname(datekey_opening)='June' then 'FM3'
when monthname(datekey_opening)='July' then 'FM4'
when monthname(datekey_opening)='August' then 'FM5'
when monthname(datekey_opening)='September' then 'FM6'
when monthname(datekey_opening)='October' then 'FM7'
when monthname(datekey_opening)='November' then 'FM8'
when monthname(datekey_opening)='December'then 'FM9'
end Financial_months,
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters from zomato;
                        
select * from calender1 order by datekey_Opening asc;
 
 drop view calender1;

-- Find the Numbers of Resturants based on City and Country. --

Select * from zomato;
select * from country_name;
select c.country_name,count(s.RestaurantID) as "Total_Restaurants" from
zomato as s join country_name as c on
s.Country_Code =c.Country_Code group by country_name order by Total_Restaurants desc;

Select City,Count(restaurantid) as "Total_Counts" from zomato group by city order by Total_Counts desc limit 10;

select c.country_name,s.city,count(s.RestaurantID) as "Total_Restaurants" from
zomato as s join country_name as c on
s.Country_Code =c.Country_Code group by country_name order by Total_Restaurants desc;

SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

use zomato;

select * from zomato;

select year(datekey_Opening) as year1,quarter(datekey_Opening) as quarter1,monthname(datekey_opening) as "Month_Fullname",
count(restaurantid) as "Total_Restaurants" from zomato group by year1,quarter1,Month_fullname order by year1,quarter1,Month_fullname asc;

select year(Datekey_opening) as year1,count(restaurantid) from zomato group by year1 order by year1 asc;

select quarter(Datekey_opening) as quarter1,count(restaurantid) from zomato group by quarter1 order by quarter1 asc;

select monthname(datekey_opening) as month_fullname,count(restaurantid) as total_counts from zomato group by month_fullname order by month_fullname asc;


--- Count of Resturants based on Average Ratings --

select round(avg(rating),2) as avg_rating from zomato;

select rating from zomato;

select case 
when rating <=1 then "0-1" 
when rating <=2 then "1.1-2" 
when rating <=3 then "2.1-3" 
when Rating<=4 then "3.1-4" 
when rating<=5 then "4.1-5"
end as rating_bucket,count(restaurantid) 
from zomato
group by rating_bucket
order by rating_bucket;

---  Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets ---
select * from zomato;
select * from calender1;
select * from country_name;

Create view USD_Cost as select c.country_name,s.Currency,s.Average_Cost_for_two from 
country_name as c join zomato as s on s.Country_Code= c.Country_Code;

select * from usd_cost;

select country_name,count(country_name) as Total_Restaurants,case 
when Currency = "Indian Rupee" then round(sum(Average_Cost_for_two/85.85),2)
when Currency = "Botswana Pula" then round(sum(Average_Cost_for_two/13.8423),2)
when currency = "Brazilian Real" then round(sum(Average_Cost_for_two/5.7499),2)
when currency = "British Pound" then round(sum(Average_Cost_for_two/0.77549),2)
when Currency = "Emirati Dirham" then round(sum(Average_Cost_for_two/3.6725),2)
when Currency = "Indonesian Rupiah" then round(sum(Average_Cost_for_two/16938.9),2)
when Currency = "New Zealand Dollar" then round(sum(Average_Cost_for_two/1.79666),2)
when Currency = "Qatari Riyal" then round(sum(Average_Cost_for_two/3.6452),2)
when Currency = "South African Rand" then round(sum(Average_Cost_for_two/19.4025),2)
when Currency = "Sri Lankan Rupee" then round(sum(Average_Cost_for_two/296.3472),2)
when Currency = "Turkish Lira" then round(sum(Average_Cost_for_two/37.5095),2)
when Currency = "US Dollar" then sum(Average_Cost_for_two/1)
end as USD_Avg_Cost from USD_Cost group by country_name order by USD_Avg_cost desc;

Create view Restaurants1 as select case 
when Currency = "Indian Rupee" then round(Average_Cost_for_two/85.85,2)
when Currency = "Botswana Pula" then round(Average_Cost_for_two/13.8423,2)
when currency = "Brazilian Real" then round(Average_Cost_for_two/5.7499,2)
when currency = "British Pound" then round(Average_Cost_for_two/0.77549,2)
when Currency = "Emirati Dirham" then round(Average_Cost_for_two/3.6725,2)
when Currency = "Indonesian Rupiah" then round(Average_Cost_for_two/16938.9,2)
when Currency = "New Zealand Dollar" then round(Average_Cost_for_two/1.79666,2)
when Currency = "Qatari Riyal" then round(Average_Cost_for_two/3.6452,2)
when Currency = "South African Rand" then round(Average_Cost_for_two/19.4025,2)
when Currency = "Sri Lankan Rupee" then round(Average_Cost_for_two/296.3472,2)
when Currency = "Turkish Lira" then round(Average_Cost_for_two/37.5095,2)
when Currency = "US Dollar" then Average_Cost_for_two/1
end as USD_Avg_Cost from USD_Cost;

select * from restaurants order by usd_avg_cost desc;
select case 
when USD_Avg_Cost <=100 then "0-100"
when USD_Avg_Cost <=250 then "101-250"
when USD_Avg_Cost <=500 then "251-500"
end as "Avg_Bucket",sum(USD_Avg_Cost) from restaurants;


--- Percentage of Resturants based on "Has_Table_booking"---
select * from zomato;

select has_table_booking,count(Has_Table_booking) as Total_Restaurants,
concat(round(count(Has_Table_booking)/(select count(Has_Table_booking) from zomato)*100,2),"%") as Restaurant_Percentage from zomato group by Has_Table_booking;

--- 8.Percentage of Resturants based on "Has_Online_delivery" ---

select Has_Online_delivery,count(Has_Online_delivery) as Total_Restaurants,
concat(round(count(Has_online_delivery)/(select count(Has_online_delivery) from zomato)*100,2),"%") as Restaurant_Percentage from zomato group by Has_Online_delivery;

--- Top 5 City wise Restaurants----

select city,count(Restaurantid) as total_restaurants from zomato group by city order by total_restaurants desc limit 5;

------ highest voting % country ----
select * from country_name;
select * from zomato;


select c.country_name,concat(round(max(s.votes)/100,2),"%") as highest_voting from
country_name as c join zomato as s on
c.Country_Code = s.Country_Code group by country_name order by highest_voting desc limit 5;


--- top 5 cuisines wise Restaurants ---
select * from zomato;

select cuisines,count(Restaurantid) as total_restaurants from zomato group by Cuisines order by total_restaurants desc limit 10;

use zomato;

--- Total Countries -------------

Select count(*) from country_name;

-------- Total Cities --------
select * from zomato;
Select Count(distinct city ) as Total_Cities from zomato;

----- Average Rating ---------
Select round(Avg(Rating),2) as Avg_Rating from zomato;

--------- Total Votes -------
select * from zomato;

select sum(Votes) as Total_Votes from zomato;

------- Avg Rating above Restaurants with Cities --------
select * from zomato;
select City,Count(*) as Total_Restaurants from zomato where rating > (Select avg(Rating) from zomato) group by city order by Total_Restaurants desc;

------- Avg Rating below restaurants with Cities ------
select City,Count(*) as Total_Restaurants from zomato where rating < (Select avg(Rating) from zomato) group by city order by Total_Restaurants desc;

-------- Ranking wise Restaurantsname -------------
select * from zomato;
with Restaurants as (select restaurantname,count(*) as Total_Restaurants from zomato group by restaurantname order by total_Restaurants desc)
select restaurantname,Total_Restaurants, dense_rank() over (order by Total_Restaurants desc) as Ranking from restaurants;

----- Differenct Restaurants year wise --------

select * from zomato;
create view cy2 as select year(Datekey_Opening) as year1,count(restaurantid) as Total_Restaurants from zomato group by year1 order by total_Restaurants;

with ly as (Select year(datekey_opening) as year1,count(*) as Total_Restaurants from zomato group by year1 order by year1)
select year1,Total_Restaurants,lag(Total_Restaurants,1) over (order by Total_Restaurants desc) as Next_Year_Restaurants from ly;

with ny as (Select year(datekey_opening) as year1,count(*) as Total_Restaurants from zomato group by year1 order by year1)
select year1,Total_Restaurants,lead(Total_Restaurants,1) over (order by year1) as Next_Year_Restaurants from ny;

select * from cy2;

with cy2 as (select year1,Total_Restaurants,lead(total_Restaurants,1) over (order by year1) as Ny from cy2)
select year1,Total_Restaurants,Ny,ny-Total_Restaurants as Diff_Restaurants_Count from cy2;

----------- In & Out Operator -------------------------------
select * from calender1;
select year(datekey_Opening) as year1, count(*) as Total_Restaurants from zomato group by year1 order by year1;
call zomato_Restaurant(2011, @2011);
select @2011;

use zomato;

call zomato_Restaurant(2013,@2013);
select @2013;


























































































































































