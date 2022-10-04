-- Project background: My role in this project is the senior data analyst in Maven Airlines •	
--My task is to recommend a data-driven strategy for 
--increasing Maven Airlines' satisfaction rate and present 
--it in the form of a single page report or dashboard.


Select * -- first look at the overall dataset 
from data_analyst_project..airline_passenger_satisfaction$

select count(*)
from data_analyst_project..airline_passenger_satisfaction$  --129880 customers total 



select count(*) 
from data_analyst_project..airline_passenger_satisfaction$
where Satisfaction like '%Neutral%'  -- 73452 customers with a neutrel or disatisfaction 73452/129880=56% 

--now I want to look at average rating for each catergory and see which column had the lowest rating 
select avg(Seat_Comfort) as seat_comfort, 
avg(Departure_and_Arrival_Time_Convenience) as delayrating, 
avg(Ease_of_Online_Booking)as online_booking,
avg(Check_in_Service)as check_in_service,
avg(Online_Boarding) as online_boarding,
avg(Gate_Location) as gate_location,
avg(On_board_Service) as on_board_service,
avg(Leg_Room_Service) as legroom ,
avg(Cleanliness) as cleanliness, 
avg(Food_and_drink) as food_drink,
avg(in_flight_Service) as in_flight_serivice,
avg(in_flight_Wifi_Service) as wifi,
avg(In_flight_Entertainment) as entertainment,
avg(Baggage_Handling) as Baggage  

FROM data_analyst_project..airline_passenger_satisfaction$ --We can see that online 
--booking had a rating of 2.75 and Wifi service had a 2.72 
--We are not sure if these variables contribute to low satifactory rate from our passengers 

-- We need to do correlation analysis 


SELECT 
Gender,
COUNT(ID) as cutomer_count,Type_of_Travel
FROM  
data_analyst_project..airline_passenger_satisfaction$
where Satisfaction like '%Neutral%'
group by Gender,Type_of_Travel --Male 35822 female 37630 dissatisfied 
--within the same gender we look at how the type of travel can impact the disatiaction count so far no noticeable evidence 
--indicate that the type of travel can be a influencing factor 


SELECT  
Class, 
COUNT(ID) as cutomer_count


from data_analyst_project..airline_passenger_satisfaction$
where Satisfaction like '%Neutral%'
group by Class
  --Most people that give a neutral or dissatified when they were in economy class, 47366 from economy class
  --7092 from economy plus
  --18994 from business class 



  -- Correlation analysis 
  -- We would like to count the number of dissatisfied passengers and see which variable/column made them to be dissatified 
  -- hypothesis: if the chosen variable is the cause for overall customers dissatifaction , we shall see customres that gave a lower rating for 
  --this section should also say they were overall dissatified 

  SELECT  Departure_and_Arrival_Time_Convenience, 
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Departure_and_Arrival_Time_Convenience
 order by Departure_and_Arrival_Time_Convenience

  SELECT  Departure_and_Arrival_Time_Convenience, 
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Departure_and_Arrival_Time_Convenience
 order by Departure_and_Arrival_Time_Convenience
 -- no correlation was found
 --we see that out of all the customers that gave a 5 star rating for delay, 57% of them had a bad overall experience 
 -- 19409 customers gave 1 star for delay , only 50% of them claimed to have a bad overall experience 
 --19409 one star rating 


 -- check Ease_of_Online_Booking
   SELECT Ease_of_Online_Booking,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Ease_of_Online_Booking
 order by Ease_of_Online_Booking

  SELECT  Ease_of_Online_Booking,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Ease_of_Online_Booking
 order by Ease_of_Online_Booking
 --0  33% --weak correlation 
 --1 62% of all the people that gave 1 star rating for online booking were overally dissatified 
 --2 69% of all people that gave 2 star were overally dis
 --3 69%
 --4 46%
 --21886 one star rating 


   SELECT Check_in_Service,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Check_in_Service
 order by Check_in_Service

  SELECT  Check_in_Service,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Check_in_Service
 order by Check_in_Service

 -- seeing strong correlation ,32210 customers gave 1,2 stars for check_ in service , 75% of them 
 --went on to give bad overall rating 16108 one star rating 

 --Online_Boarding


 SELECT Online_Boarding,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Online_Boarding
 order by Online_Boarding

  SELECT  Online_Boarding,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Online_Boarding
 order by Online_Boarding 
 --strong correlation customers that gave poor rating (1-2 star) for online_boarding 35195.
 --87% of them went on to give poor rating for overall service 
 -- recommend leadersip to adjust online boarding 13261 one star rating

 --Gate_Location

  SELECT Gate_Location,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Gate_Location
 order by Gate_Location

  SELECT  Gate_Location,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Gate_Location
 order by Gate_Location

 -- weak corrrelation for gate location ,21991 one star rating



 --On_board_Service
 SELECT On_board_Service,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by On_board_Service
 order by On_board_Service

  SELECT  On_board_Service,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by On_board_Service
 order by On_board_Service  
 --25542/33138=77%
 --strong correlation 
 --14787 one star rating



 --Seat_Comfort

 SELECT Seat_Comfort,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Seat_Comfort
 order by Seat_Comfort

  SELECT  Seat_Comfort,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Seat_Comfort
 order by Seat_Comfort

 --strong correlation 77% 15108 one star rating

 --Leg_Room_Service

 SELECT Leg_Room_Service,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Leg_Room_Service
 order by Leg_Room_Service

  SELECT  Leg_Room_Service,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Leg_Room_Service
 order by Leg_Room_Service


 --strong correlation 12895 one star rating



 --Cleanliness 

  SELECT Cleanliness ,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Cleanliness 
 order by Cleanliness 

  SELECT  Cleanliness ,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Cleanliness 
 order by Cleanliness --16729 one star ratinng 

 --medium correlation

 --Food_and_Drink 

 
  SELECT Food_and_Drink ,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Food_and_Drink 
 order by Food_and_Drink 

  SELECT  Food_and_Drink ,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Food_and_Drink 
 order by Food_and_Drink 
 --medium to low correlation
 --16051 one star rating 


 --In_flight_Service

  SELECT In_flight_Service ,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by In_flight_Service
 order by In_flight_Service

  SELECT  In_flight_Service ,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by In_flight_Service
 order by In_flight_Service --16277/23172 =70%  medium correlation 
 --8862 one star rating 


 --In_flight_Wifi_Service
  SELECT In_flight_Wifi_Service ,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by In_flight_Wifi_Service
 order by In_flight_Wifi_Service

  SELECT  In_flight_Wifi_Service,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by In_flight_Wifi_Service
 order by In_flight_Wifi_Service
 --22328 one star rating 

 --medium correlation 


 --In_flight_Entertainment
  SELECT In_flight_Entertainment,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by In_flight_Entertainment
 order by In_flight_Entertainment

  SELECT In_flight_Entertainment,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by In_flight_Entertainment
 order by In_flight_Entertainment
 --15675 one star rating 

 --Strong correlation 85% for 1 star 



 --Baggage_Handling

   SELECT Baggage_Handling,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  where Satisfaction like '%Neutral%'
  group by Baggage_Handling
 order by Baggage_Handling

  SELECT Baggage_Handling,
  COUNT(ID) as cutomer_count
  FROM data_analyst_project..airline_passenger_satisfaction$
  
  group by Baggage_Handling
 order by Baggage_Handling

 --meidum correlation 9028 one star rating 




 --question: Which service yield the highest one star rating ? 
 --19409 one star rating  for departure and arrival delay, -21886 one star rating for online booking 21991 gate location 
 --22328 one star rating for wifi service 

 --question: which service with the highest yield rate for overall dissatisfaction? 


 --questions: what were the main causes for low customers satisfaction rate
 --check in service, online boarding, on board service ,seat comfort, leg room service, in flight entertainment 
 --focus on in flgiht entertainment and online boarding 
 -- online boarding and in flight service yielded 30000+ dissatisfied count 
 --focus on improving online boarding and in flight services 