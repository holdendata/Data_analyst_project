-- Date 10/23/2022
--This is a data source from Maven's analytics , my goal is to solve their business problems with information regarding taxi trips 
-- The following queries cleaned 28 millions row of data 
--The completed project used data analysis to solve the following business questions: 
--•	What's the average number of trips we can expect this week?
--•	What's the average fare per trip we expect to collect?
--•	What's the average distance traveled per trip?
--•	How do we expect trip volume to change, relative to last week?
--•	Which days of the week and times of the day will be busiest?
--•	What will likely be the most popular pick-up and drop-off locations?

--First take a look at the complete data


SELECT count(*) as count
FROM  data_analyst_project..[2017_taxi_trips]




SELECT count(*) as count
FROM data_analyst_project..[2018_taxi_trips]

SELECT count(*) as count 
from data_analyst_project..[2019_taxi_trips]


SELECT count(*) as count 
FROM data_analyst_project..[2020_taxi_trips]

--checked: so total from four tables add up to 28 million rows 




SELECT *
FROM  data_analyst_project..[2017_taxi_trips]

SELECT * 
FROM data_analyst_project..[2018_taxi_trips]

SELECt *
from data_analyst_project..[2019_taxi_trips]


SELECT *
FROM data_analyst_project..[2020_taxi_trips]

-- looking at the data set first make sure that all columns are correct . following is the data dictionary 
--VendorID                A code indicating the LPEP provider that provided the record (1= Creative Mobile Technologies, LLC; 2= Verifone Inc.)         

--lpep_pickup_datetime      The date and time when the meter was engaged

--lpep_dropoff_datetime    The date and time when the meter was disengaged

--store_and_fwd_flag       This flag indicates whether the trip record was held in vehicle 
--memory before sending to the vendor, aka “store and forward,” 
--because the vehicle did not have a connection to the server (Y= store and forward trip; N= not a store and forward trip)

--RatecodeID   The final rate code in effect at the end of the trip (1= Standard rate; 2= JFK; 3= Newark; 4= Nassau or Westchester; 5= Negotiated fare; 6= Group ride)

--PULocationID  TLC Taxi Zone in which the taximeter was engaged

--DOLocationID    TLC Taxi Zone in which the taximeter was disengaged

--passenger_count   The number of passengers in the vehicle (this is a driver entered value)

--trip_distance  The elapsed trip distance in miles reported by the taximeter

--fare_amount   The time-and-distance fare calculated by the meter

--extra   Miscellaneous extras and surcharges (this only includes the $0.50 and $1 rush hour and overnight charges)

--mta_tax  $0.50 MTA tax that is automatically triggered based on the metered rate in use

--tip_amount   Tip amount (automatically populated for credit card tips - cash tips are not included)


--tolls_amount  Total amount of all tolls paid in trip

--improvement_surcharge $0.30 improvement surcharge assessed on hailed trips at the flag drop

--total_amount  The total amount charged to passengers (does not include cash tips)


--payment_type   A numeric code signifying how the passenger paid for the trip (1= Credit card; 2= Cash; 3= No charge; 4= Dispute; 5= Unknown; 6= Voided trip)

--trip_type  A code indicating whether the trip was a street-hail 
--or a dispatch that is automatically assigned based on the metered rate in 
--use but can be altered by the driver (1= Street-hail; 2= Dispatch)


--congestion_surcharge Congestion surcharge for trips that start, 
--end or pass through the congestion zone in Manhattan, south of 96th street
--($2.50 for non-shared trips in Yellow Taxis; $2.75 for non-shared trips in Green Taxis)


 -- data cleaning  steps 
--•	1.Let’s stick to trips that were NOT sent via “store and forward”
--•	2. I’m only interested in street-hailed trips paid by card or cash, with a standard rate
--•	3. We can remove any trips with dates before 2017 or after 2020, along with any trips with pickups or drop-offs into unknown zones
--•	4. Let’s assume any trips with no recorded passengers had 1 passenger
--•	5. If a pickup date/time is AFTER the drop-off date/time, let’s swap them
--•	6. We can remove trips lasting longer than a day, and any trips which show both a distance and fare amount of 0
--•	7. If you notice any records where the fare, taxes, and surcharges are ALL negative, please make them positive
--•	8. For any trips that have a fare amount but have a trip distance of 0, calculate the distance this way: (Fare amount - 2.5) / 2.5
--•	9. For any trips that have a trip distance but have a fare amount of 0, calculate the fare amount this way: 2.5 + (trip distance x 2.5)



--We start with the 2017 data set ,let's finish data cleaning step 1-4 with this query
USE data_analyst_project
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW 
taxi_clean_2017
AS 
(SELECT * 
FROM data_analyst_project..[2017_taxi_trips]
WHERE store_and_fwd_flag = '"N"' 
--not sent via 'store and forward', 
and trip_type ='1'-- street hailer trip 
and (payment_type ='1' or payment_type='2') -- paid by credit card or cash
and RatecodeID='1'-- stadnard rate 
and lpep_pickup_datetime> '2017' and lpep_pickup_datetime <'2018' and lpep_dropoff_datetime<'2018' and lpep_dropoff_datetime >'2017' 
-- want pick up and drop off time in 2017 only 
and PULocationID <> '264' and PULocationID<> '265' --remove any unknown zones for pick up 
and DOLocationID <> '264' and DOLocationID <> '265')
GO
--remove any unknown zones for drop off 


select * 
from data_analyst_project..taxi_clean_2017
where passenger_count = '0'

update data_analyst_project..taxi_clean_2017
set passenger_count = '1'
where passenger_count='0' 
--the 1-4 cleaning steps were done for 2017 data set I cretaed a view for 2017 cleaning data set 

--repeat this process for 2018 , 2019 ,2020




--for 2018 
USE data_analyst_project
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW 
taxi_clean_2018
AS 
(SELECT * 
FROM data_analyst_project..[2018_taxi_trips]
WHERE store_and_fwd_flag = '"N"' 
--not sent via 'store and forward', 
and trip_type ='1'-- street hailer trip 
and (payment_type ='1' or payment_type='2') -- paid by credit card or cash
and RatecodeID='1'-- stadnard rate 
and cast(lpep_pickup_datetime as datetime) >  '2018' 
and cast(lpep_pickup_datetime as datetime) <'2019' 
and cast( lpep_dropoff_datetime as datetime) <'2019'
and cast( lpep_dropoff_datetime  as datetime) >'2018' 
-- want pick up and drop off time in 2018 only 
and PULocationID <> '264' and PULocationID<> '265' --remove any unknown zones for pick up 
and DOLocationID <> '264' and DOLocationID <> '265')
GO


select * 
from data_analyst_project..taxi_clean_2018 --10591 rows were showing 0 passengers 
where passenger_count = '0'

update data_analyst_project..taxi_clean_2018  --10591 rows updated 
set passenger_count = '1'
where passenger_count='0' 




-- cleaning for 2019 
USE data_analyst_project
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW 
taxi_clean_2019
AS 
(SELECT * 
FROM data_analyst_project..[2019_taxi_trips]
WHERE store_and_fwd_flag = '"N"' 
--not sent via 'store and forward', 
and trip_type ='1'-- street hailer trip 
and (payment_type ='1' or payment_type='2') -- paid by credit card or cash
and RatecodeID='1'-- stadnard rate 
and cast(lpep_pickup_datetime as datetime) >  '2019' 
and cast(lpep_pickup_datetime as datetime) <'2020' 
and cast( lpep_dropoff_datetime as datetime) <'2020'
and cast( lpep_dropoff_datetime  as datetime) >'2019' 
-- want pick up and drop off time in 2019 only 
and PULocationID <> '264' and PULocationID<> '265' --remove any unknown zones for pick up 
and DOLocationID <> '264' and DOLocationID <> '265')
GO


select * 
from data_analyst_project..taxi_clean_2019--9792 rows were having 0 passenger 
where passenger_count = '0'

update data_analyst_project..taxi_clean_2019  --9792 rows updated 
set passenger_count = '1'
where passenger_count='0' 






--cleaning for 2020 

USE data_analyst_project
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW 
taxi_clean_2020
AS 
(SELECT * 
FROM data_analyst_project..[2020_taxi_trips]
WHERE store_and_fwd_flag = '"N"' 
--not sent via 'store and forward', 
and trip_type ='1'-- street hailer trip 
and (payment_type ='1' or payment_type='2') -- paid by credit card or cash
and RatecodeID='1'-- stadnard rate 
and cast(lpep_pickup_datetime as datetime) >  '2020' 
and cast(lpep_pickup_datetime as datetime) <'2021' 
and cast( lpep_dropoff_datetime as datetime) <'2021'
and cast( lpep_dropoff_datetime  as datetime) >'2020' 
-- want pick up and drop off time in 2019 only 
and PULocationID <> '264' and PULocationID<> '265' --remove any unknown zones for pick up 
and DOLocationID <> '264' and DOLocationID <> '265')
GO



select * 
from data_analyst_project..taxi_clean_2020--2583 rows have 0 passenger 
where passenger_count = '0'

update data_analyst_project..taxi_clean_2020  --2583 rows updated 
set passenger_count = '1'
where passenger_count='0' 

-- data cleaning step 1-4 finished for data set 2017-2020 







-- look at the data first 
SELECT * 
FROM  dbo.taxi_clean_2017
where lpep_pickup_datetime>lpep_dropoff_datetime

--Next I need to check if any pick up time is after drop off time 
--49 rows returned where pick up time is greather than drop off time 

--this query would swap values in two columns when one is grater than the other 

UPDATE data_analyst_project..taxi_clean_2017 
SET lpep_pickup_datetime=lpep_dropoff_datetime,
lpep_dropoff_datetime=lpep_pickup_datetime
WHERE lpep_pickup_datetime >lpep_dropoff_datetime


-- step 5 completed for 2017 data set, great!! 


--repeat for 2018-2020 data set 
SELECT * 
FROM  dbo.taxi_clean_2018
where lpep_pickup_datetime>lpep_dropoff_datetime--27 rows returned where pick up time is after drop off time 

SELECT * 
FROM  dbo.taxi_clean_2019
where lpep_pickup_datetime>lpep_dropoff_datetime --12 rows 

SELECT * 
FROM  dbo.taxi_clean_2020--1 row 
where lpep_pickup_datetime>lpep_dropoff_datetime


UPDATE data_analyst_project..taxi_clean_2018 
SET lpep_pickup_datetime=lpep_dropoff_datetime,
lpep_dropoff_datetime=lpep_pickup_datetime
WHERE lpep_pickup_datetime >lpep_dropoff_datetime


UPDATE data_analyst_project..taxi_clean_2019
SET lpep_pickup_datetime=lpep_dropoff_datetime,
lpep_dropoff_datetime=lpep_pickup_datetime
WHERE lpep_pickup_datetime >lpep_dropoff_datetime


UPDATE data_analyst_project..taxi_clean_2020 
SET lpep_pickup_datetime=lpep_dropoff_datetime,
lpep_dropoff_datetime=lpep_pickup_datetime
WHERE lpep_pickup_datetime >lpep_dropoff_datetime


-- data cleaning step 5 finished for all data set 2017-2020 ! great !
--We swap values for columns where recorded pick up happens after drop off. 





--next , step 6 we need to remove trips lasting longer than a day, 
--and any trips which show both a distance and fare amount of 0

DELETE 
FROM  data_analyst_project..taxi_clean_2017
WHERE DATEDIFF(HOUR,lpep_pickup_datetime,lpep_dropoff_datetime)>24



DELETE 
FROM data_analyst_project..taxi_clean_2017
WHERE CAST(trip_distance as float)=0 and CAST (fare_amount as float) = 0


DELETE 
FROM  data_analyst_project..taxi_clean_2018
WHERE DATEDIFF(HOUR,lpep_pickup_datetime,lpep_dropoff_datetime)>24



DELETE 
FROM data_analyst_project..taxi_clean_2018
WHERE CAST(trip_distance as float)=0 and CAST (fare_amount as float) = 0



DELETE 
FROM  data_analyst_project..taxi_clean_2019
WHERE DATEDIFF(HOUR,lpep_pickup_datetime,lpep_dropoff_datetime)>24



DELETE 
FROM data_analyst_project..taxi_clean_2019
WHERE CAST(trip_distance as float)=0 and CAST (fare_amount as float) = 0



DELETE 
FROM  data_analyst_project..taxi_clean_2020
WHERE DATEDIFF(HOUR,lpep_pickup_datetime,lpep_dropoff_datetime)>24



DELETE 
FROM data_analyst_project..taxi_clean_2020
WHERE CAST(trip_distance as float)=0 and CAST (fare_amount as float) = 0
--SETP 6 completed 3128 rows were deleted for 2017 data set 
--step 6 completed 2403 rows deleted for 2018
--step 6 completed 2279 rows deleted for 2019
--step 6 completed 792 rows deletetd for 2020









-- step 7 If you notice any records where the fare, taxes, and surcharges are ALL negative, please make them positive 
 UPDATE data_analyst_project..taxi_clean_2017
 set fare_amount=ABS(CAST(fare_amount AS float)),
 extra=ABS(CAST(extra as float)), 
 mta_tax=ABS(cast(mta_tax as float)),
 tip_amount=ABS(cast(tip_amount as float) ) ,
 improvement_surcharge=ABS(cast(improvement_surcharge as float)),
 total_amount=ABS(cast(total_amount as float)),
 trip_distance= ABS(cast(trip_distance as float)),
 tolls_amount=ABS(cast(tolls_amount as float)) 
 WHERE CAST(fare_amount AS float) <0 or CAST(extra as float) <0 or cast(mta_tax as float) < 0 or cast(trip_distance as float) <0

 SELECT * 
 FROM data_analyst_project..taxi_clean_2017
 where  CAST(fare_amount AS float) <0 AND CAST(extra as float) <0 AND cast(mta_tax as float) < 0
 -- great!! step 7 completed for 2017 data with 310 rows updated used a abs function to convert values to positive 


  UPDATE data_analyst_project..taxi_clean_2018
 set fare_amount=ABS(CAST(fare_amount AS float)),
 extra=ABS(CAST(extra as float)), 
 mta_tax=ABS(cast(mta_tax as float)),
 tip_amount=ABS(cast(tip_amount as float) ) ,
 improvement_surcharge=ABS(cast(improvement_surcharge as float)),
 total_amount=ABS(cast(total_amount as float)),
 trip_distance= ABS(cast(trip_distance as float)),
 tolls_amount=ABS(cast(tolls_amount as float)) 
  WHERE CAST(fare_amount AS float) <0 or CAST(extra as float) <0 or cast(mta_tax as float) < 0 or cast(trip_distance as float) <0
  --270 rows updated for 2018 




  
  UPDATE data_analyst_project..taxi_clean_2019
 set fare_amount=ABS(CAST(fare_amount AS float)),
 extra=ABS(CAST(extra as float)), 
 mta_tax=ABS(cast(mta_tax as float)),
 tip_amount=ABS(cast(tip_amount as float) ) ,
 improvement_surcharge=ABS(cast(improvement_surcharge as float)),
 total_amount=ABS(cast(total_amount as float)),
 trip_distance= ABS(cast(trip_distance as float)),
 tolls_amount=ABS(cast(tolls_amount as float)) 
  WHERE CAST(fare_amount AS float) <0 or CAST(extra as float) <0 or cast(mta_tax as float) < 0 or cast(trip_distance as float) <0
  --74 rows updated for 2019


    
  UPDATE data_analyst_project..taxi_clean_2020
 set fare_amount=ABS(CAST(fare_amount AS float)),
 extra=ABS(CAST(extra as float)), 
 mta_tax=ABS(cast(mta_tax as float)),
 tip_amount=ABS(cast(tip_amount as float) ) ,
 improvement_surcharge=ABS(cast(improvement_surcharge as float)),
 total_amount=ABS(cast(total_amount as float)),
 trip_distance= ABS(cast(trip_distance as float)),
 tolls_amount=ABS(cast(tolls_amount as float)) 
  WHERE CAST(fare_amount AS float) <0 or CAST(extra as float) <0 or cast(mta_tax as float) < 0 or cast(trip_distance as float) <0
  --5 rows updated for 2020


  --great!! step 7 for data cleaning is completed for 2017-2020 data set , all negative values for trip distance, fares , extra chargers have been conbverted to 
  --positive by using the abs function 










 -- we need to perform step 8 on 2017 data set 
 -- For any trips that have a fare amount but have a trip distance of 0, calculate the distance this way: (Fare amount - 2.5) / 2.5 


 SELECT  * 
 from data_analyst_project..taxi_clean_2017
 WHERE fare_amount<> '0'AND trip_distance ='0'



 UPDATE data_analyst_project..taxi_clean_2017
 set trip_distance  =(cast(fare_amount as float) - 2.5) / 2.5 
 WHERE fare_amount<> '0'AND trip_distance ='0'
 --there is an issue here , for all the trips with fare amount not equal to 0 and trip distance equal to 0, 
 --the fare amount is 2.5, that would yield 0 for the trip distance 
 --It seems that there is a base pay for starting the meter, so as long as the meter is activiated, the charge is $ 2.5 regradless of distacne 


 -- again, repeat this for 2018-2020
  SELECT  * 
 from data_analyst_project..taxi_clean_2018
 WHERE fare_amount<> '0'AND trip_distance ='0'
 
 UPDATE data_analyst_project..taxi_clean_2018
 set trip_distance  =(cast(fare_amount as float) - 2.5) / 2.5 
 WHERE fare_amount<> '0'AND trip_distance ='0'  --If this query is sucessful , we shall see fare amount being 2.5 when trip distance is 0 
 -- and it is , so we are good 


  SELECT  * 
 from data_analyst_project..taxi_clean_2019
 WHERE fare_amount<> '0'AND trip_distance ='0'
 
 UPDATE data_analyst_project..taxi_clean_2019
 set trip_distance  =(cast(fare_amount as float) - 2.5) / 2.5 
 WHERE fare_amount<> '0'AND trip_distance ='0'


  SELECT  * 
 from data_analyst_project..taxi_clean_2020
 WHERE fare_amount<> '0'AND trip_distance ='0'

 UPDATE data_analyst_project..taxi_clean_2020
 set trip_distance  =(cast(fare_amount as float) - 2.5) / 2.5 
 WHERE fare_amount<> '0'AND trip_distance ='0'









 -- ok onto step 9 
 -- For any trips that have a trip distance but have a fare amount of 0, calculate the fare amount this way: 2.5 + (trip distance x 2.5)


 SELECT  * 
 from
 data_analyst_project..taxi_clean_2017
 WHERE  trip_distance <> '0' and fare_amount ='0' --have a trip distance but have a fare amount of 0
 -- return 775 rows 

 
 SELECT  * 
 from
 data_analyst_project..taxi_clean_2017
 WHERE fare_amount ='0'

 update data_analyst_project..taxi_clean_2017
 set fare_amount=2.5+ (cast(trip_distance as float)*2.5)
 where  trip_distance <> '0' and fare_amount ='0'

 

 
 SELECT  * 
 from
 data_analyst_project..taxi_clean_2018
 WHERE  trip_distance <> '0' and fare_amount ='0' --have a trip distance but have a fare amount of 0
 -- return 387 rows 


 update data_analyst_project..taxi_clean_2018
 set fare_amount=2.5+ (cast(trip_distance as float)*2.5)
 where  trip_distance <> '0' and fare_amount ='0'-- this works, all trips with a 0 for fare amount have been updated with a balance calculated by the formula 

 
 SELECT  * 
 from
 data_analyst_project..taxi_clean_2019
 WHERE  trip_distance <> '0' and fare_amount ='0' --have a trip distance but have a fare amount of 0
 -- return 723 rows 


 update data_analyst_project..taxi_clean_2019
 set fare_amount=2.5+ (cast(trip_distance as float)*2.5)
 where  trip_distance <> '0' and fare_amount ='0'

 
 SELECT  * 
 from
 data_analyst_project..taxi_clean_2020
 WHERE  trip_distance <> '0' and fare_amount ='0' --have a trip distance but have a fare amount of 0
 -- return 413 rows 


 update data_analyst_project..taxi_clean_2020
 set fare_amount=2.5+ (cast(trip_distance as float)*2.5)
 where  trip_distance <> '0' and fare_amount ='0'


 --nice !! step 9  cleaning done for 2017,2018,2019,2020  data set 



SELECT * 
FROM data_analyst_project..taxi_clean_2020


SELECT  avg(cast(trip_distance as float))
from data_analyst_project..taxi_clean_2017

SELECT  avg(cast(trip_distance  as float))
from data_analyst_project..taxi_clean_2018

SELECT  avg(cast(trip_distance as float))
from data_analyst_project..taxi_clean_2019

SELECT  avg(cast(trip_distance  as float))
from data_analyst_project..taxi_clean_2020

SELECT count(*) 
from data_analyst_project..taxi_clean_2017
where DOLocationID=74

SELECT count(*) 
from data_analyst_project..taxi_clean_2018
where DOLocationID=74

SELECT count(*) 
from data_analyst_project..taxi_clean_2019
where DOLocationID=74

SELECT count(*) 
from data_analyst_project..taxi_clean_2020
where DOLocationID=74