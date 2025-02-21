drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select*from users;

1.'what is the total amount each customer spent on zomato'?
 select a.userid,sum(b.price)as total_amt_spent from sales a inner join product b 
 on a.product_id = b.product_id group by a.userid ;
 
 2.'How many days has each customer visited Zomato'?
Select userid,count(distinct created_date) distinct_days from sales group by userid;

3'What was the first product purchased by each customer'?
 select*from (select*,rank()over(partition by userid order by created_date)rnk from sales)a where rnk=1;

4.'What is the most purchased item on the menu and how many times was it purchased by all the cx'?
Select userid, count(product_id) as times_purchased from sales where product_id = 
(select product_id from ( select *,row_number()over(partition by product_id order by userid )as times from sales) as bo 
order by times desc limit 1) group by userid order by userid ;

5.' which item was the most popular for each cx'?
  select a.userid,b.product_name from sales a inner join product b where a.product_id = b.product_id;
  
  select userid,product_name,count(drnk) from (select userid,product_name,dense_rank() over (partition by userid order by product_name) as 
  drnk from (select a.userid,b.product_name from sales a inner join product b where a.product_id = 
  b.product_id) as tool) as temp where userid = 1 group by userid ;
  
  select userid,count(product_id) as numb from sales group by userid,product_id;
  
  select * from(select userid,product_id,numb,dense_rank() over (partition by userid order by numb desc) as dnk from 
  (select userid,product_id,count(product_id) as numb from sales group by userid,product_id) as imet )
  as tum where dnk = 1;

  6.'Which item was 1st purchased  by the cx  after they become a gold member'?
select a.userid,b.product_id,a.gold_signup_date,b.created_date from  goldusers_signup a inner join sales b
 where a.userid = b.userid ;
 
 select * from (select a.userid,b.product_id,a.gold_signup_date,b.created_date from  goldusers_signup a inner join sales b
 where a.userid = b.userid) as it where created_date >= gold_signup_date ;
 
select * from (select userid,created_date,gold_signup_date,product_id,dense_rank() over 
 (partition by userid order by created_date asc) as dunk from  (select * from
 (select a.userid,b.product_id,a.gold_signup_date,b.created_date from  goldusers_signup 
 a inner join sales b where a.userid = b.userid) as it where created_date >= gold_signup_date) 
as wit)as pit where dunk = 1 ;
 
 7'which item was purchased just before the cx have become a gold member'?
 
select a.userid,a.gold_signup_date,b.created_date,b.product_id from goldusers_signup a inner join 
  sales b where a.userid = b.userid;
select * from (select userid,gold_signup_date,created_date,product_id,dense_rank() over(partition by
 userid order by created_date desc)as dumb from( select * from ( select a.userid,a.gold_signup_date,b.created_date,b.product_id
  from goldusers_signup a inner join sales b where a.userid = b.userid) as put where created_date 
  <= gold_signup_date) as pot) as punk where dumb =1;

8'what is the total orders and amount spent for each cx before they become a gold member'?

select * from (select a.userid,a.gold_signup_date,b.created_date,b.product_id from goldusers_signup a 
inner join sales b where a.userid = b.userid) as plum where created_date <= gold_signup_date ;

select userid ,count(product_id),sum(price) from(select a.userid,a.product_id,a.created_date,b.price from (select * from
 (select a.userid,a.gold_signup_date,b.created_date,b.product_id from goldusers_signup a 
inner join sales b where a.userid = b.userid) as plum where created_date <= gold_signup_date ) as a
inner join product b where a.product_id = b.product_id) as cash group by userid order by userid asc;

9.'If buying each product generates points for eg:Rs.5= 2 zomato points & each product has different
purchasing points for eg:P1=RS.5=1,P2=RS.10=5,P3=RS.5=1.Calculate points collected by each cx &
for which product most points have been given till now'?

select product_name,userid,sum(points) from (select *,
CASE  When price =980 then price/5 
when price=870 then price/10*5
when price=330 then price/5  else 0 END as points from (select
 a.product_id,a.userid,b.product_name,b.price from sales a inner join product b where 
 a.product_id = b.product_id) as pot) as pick group by userid,product_name;
 
 select * from( select*, dense_rank () over(partition by userid order by pnt desc) as dub from
  (select product_name,userid,sum(points) as pnt from (select *,
CASE  When price =980 then price/5 
when price=870 then price/10*5
when price=330 then price/5  else 0 END as points from (select
 a.product_id,a.userid,b.product_name,b.price from sales a inner join product b where 
 a.product_id = b.product_id) as pot) as pick group by userid,product_name) as tick) as pug where dub =1;



select product_name,sum(pnt)as totalpoint from (select*, dense_rank () over(partition by userid order by pnt desc) as dub from
  (select product_name,userid,sum(points) as pnt from (select *,
CASE  When price =980 then price/5 
when price=870 then price/10*5
when price=330 then price/5  else 0 END as points from (select
 a.product_id,a.userid,b.product_name,b.price from sales a inner join product b where 
 a.product_id = b.product_id) as pot) as pick group by userid,product_name) as tick) as pot group by 
 product_name  order by totalpoint desc limit 1;
 
 10'In the first one year after a cx joins the gold program (including their joined date) irrespective 
 of what the cx has purchased they earn 5 zomato points for every Rs.10 spent
 who earned more 1 or 3 and what was their points earnings in their 1st year'?
 
  
  select *, case when price = price then price/10*5 else 0 END as pint from 
 (select gold_signup_date,userid,created_date,c.product_id,price,dates from 
   (select a.gold_signup_date,a.userid,b.created_date,b.product_id,dates from (select gold_signup_date,
userid,date_add( gold_signup_date,Interval 1 year ) as dates from goldusers_signup) as a
  inner join sales b where a.userid = b.userid) as c inner join  product d where c.product_id =
  d.product_id) as pon where created_date between gold_signup_date and dates;
  
  select *, case when price = price then price/10*5 else 0 END as pint from 
 (select gold_signup_date,userid,created_date,c.product_id,price,dates from 
   (select a.gold_signup_date,a.userid,b.created_date,b.product_id,dates from (select gold_signup_date,
userid,date_add( gold_signup_date,Interval 1 year ) as dates from goldusers_signup) as a
  inner join sales b where a.userid = b.userid) as c inner join  product d where c.product_id =
  d.product_id) as pon where created_date between gold_signup_date and dates order by pint desc
  limit 1;
 
  
  11'Rank all the transaction of the cx'?
  
   select *, dense_rank() over(partition by userid order by created_date asc) as dib from
   (select a.userid,b.product_id,b.price,a.created_date from sales a inner join product b where a.product_id =
  b.product_id ) as pol;
  
  12'Rank all the transaction for each member whenever they are zomato gold member for every non
  gold member transaction mark as N/A'?
  
    select gold_signup_date,userid,created_date,product_id,
    case when created_date >= gold_signup_date then gold else 'n/a'END as hot from
   (select*,case when kran=kran then ran else 'N/A' END as gold from
   (select * ,dense_rank ()over (partition by userid order by  created_date desc) as ran
    from ( select *,case when gold_signup_date = gold_signup_date then created_date else null
    END  as kran from (Select a.gold_signup_date,b.userid,b.created_date,b.product_id from 
    goldusers_signup a right join sales b on a.userid = b.userid ) as nit ) as poit)as bot) as gut ;
    
    select *,case when gold_signup_date = gold_signup_date then gold_signup_date else null END
    from(select gold_signup_date,userid,created_date,product_id,
    case when created_date >= gold_signup_date then gold else 'n/a'END as hot from
   (select*,case when kran=kran then ran else 'N/A' END as gold from
   (select * ,dense_rank ()over (partition by userid order by  created_date desc) as ran
    from ( select *,case when gold_signup_date = gold_signup_date then created_date else null
    END  as kran from (Select a.gold_signup_date,b.userid,b.created_date,b.product_id from 
    goldusers_signup a right join sales b on a.userid = b.userid ) as nit ) as poit)as bot) as gut) 
    as jet ;
    select gold_signup_date,userid,created_date,product_id,hot from
     (select *,case when gold_signup_date = gold_signup_date then 'n/a'else null END
    from(select gold_signup_date,userid,created_date,product_id,
    case when created_date >= gold_signup_date then gold else 'n/a'END as hot from
   (select*,case when kran=kran then ran else 'N/A' END as gold from
   (select * ,dense_rank ()over (partition by userid order by  created_date desc) as ran
    from ( select *,case when gold_signup_date = gold_signup_date then created_date else null
    END  as kran from (Select a.gold_signup_date,b.userid,b.created_date,b.product_id from 
    goldusers_signup a right join sales b on a.userid = b.userid ) as nit ) as poit)as bot) as gut) 
    as jet) as hut ;
    



