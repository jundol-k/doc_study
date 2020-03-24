-- cross ����
create table cross_t1(
	label char(1) primary key
)

create table cross_t2(
	score int primary key
)

insert into cross_t1 (label) values ('A'), ('B');
insert into cross_t2 (score) values (1),(2),(3);

select * from cross_t1;
select * from cross_t2;

SELECT 
	CASE WHEN LABEL = 'A' THEN SUM(SCORE)
		 ELSE SUM(SCORE) * -1
		 END AS CALC
FROM CROSS_T1 
CROSS JOIN CROSS_T2
GROUP BY LABEL
ORDER BY LABEL;

-- NATURE ����
create table CATEGORIES(
 CATEGORY_ID SERIAL primary key
 , CATEGORY_NAME VARCHAR(255) not NULL
);

create table PRODUCTS
(
 PRODUCT_ID SERIAL primary key,
 PRODUCT_NAME VARCHAR(255) not null,
 CATEGORY_ID INT not null,
 foreign key (CATEGORY_ID) references CATEGORIES (CATEGORY_ID)
)

insert into CATEGORIES (CATEGORY_NAME) values ('Smart Phone'), ('Laptop'), ('Tablet');
insert into PRODUCTS (PRODUCT_NAME, CATEGORY_ID) values 
('iPhone', 1),
('Samsung Galaxy', 1),
('HP Elite', 2),
('Lenovo Thinkpad', 2),
('iPad', 3),
('Kindle Fire', 3);

select * from categories;
select * from products;

select * from products A natural join categories B;

select a.country_id, a.last_update, a.city_id , a.city, b.country from city a inner join country b on a.country_id = b.country_id ;
select * from country;

-- group by
select * from customer c2 inner join (
select customer_id from payment p group by customer_id) as A on c2.customer_id  = A.customer_id order by c2.customer_id ;

select CUSTOMER_ID, SUM(AMOUNT) as AMOUNT_SUM
from payment p 
group by customer_id 
order by SUM(AMOUNT) desc;


-- HAVING
select CUSTOMER_ID, SUM(AMOUNT) as AMOUNT_SUM
from PAYMENT
group by customer_id 
having SUM(AMOUNT) > 200;



-- grouping set
create table sales(
brand varchar not null,
segment varchar not null,
quantity int not null,
primary key (brand, segment)
);

insert into sales (brand, segment, quantity)
values 
('ABC', 'Premium', 100)
, ('ABC', 'Basic', 200)
, ('XYZ', 'Premium', 100)
, ('XYZ', 'Basic', 300);

select * from sales;

select brand, segment, sum(quantity) from sales group by brand, segment;
select brand, sum(quantity) from sales group by brand;
select segment, sum(quantity) from sales group by segment;
select sum(quantity) from sales;

-- grouping set �� ����ϸ� ���� ���� union all�� �̿��� �Ͱ� ���� ��� ������ �����ϴ�.
select brand, segment, sum(quantity) from sales group by 
grouping sets(
 (brand, segment)
 ,(brand)
 ,(segment)
 ,()
);

-- grouping �Լ� Ȱ���Ѵ�. �ش� �÷��� ���迡 ���Ǿ����� 0, �׷��� ������ 1�� �����Ѵ�.
select 
	grouping (brand) grouping_brand
	, grouping (segment) grouping_segment
	, sum(quantity) from sales group by 
grouping sets(
 (brand, segment)
 ,(brand)
 ,(segment)
 ,()
);

--> ���ڰ�
select 
	case when grouping (brand) = 0 and grouping(segment) = 0 then '�귣�庰+��޺�'
		 when grouping (brand) = 0 and grouping(segment) = 1 then '�귣�庰'
		 when grouping (brand) = 1 and grouping(segment) = 0 then '��޺�'
		 when grouping (brand) = 1 and grouping(segment) = 1 then '��ü�հ�'
		else ''
		end as "�������"
		,brand
		,segment 
	, sum(quantity) 
from sales group by 
grouping sets(
 (brand, segment)
 ,(brand)
 ,(segment)
 ,()
);


-- roll up
-- grouping �÷��� �հ踦 �����ϴµ� ���ȴ�.
select brand, segment, sum(quantity) from sales
group by 
	rollup (brand, segment)
order by brand, segment;

-- group by �� �հ� + rollup���� �� �տ� �� �÷� ������ �հ赵 ������ + ��ü �հ赵 ���Դ�.
select segment, sum(quantity) from sales
group by rollup (segment);

-- �κ� rollup
-- group by �� �հ� + �Ǿտ� �� �÷��� �հ� + ��ü �հ�� ������ �ʴ´�.
select brand, segment, sum(quantity) from sales
group by segment ,
	rollup (brand)
order by brand, segment;


-- cube
-- ������ grouping �÷��� ������ �հ踦 �����ϴµ� ���ȴ�.
select brand, segment, sum(quantity)
from sales
group by 
	cube (brand, segment)
order by brand, segment;


-- �м��Լ�
-- Ư�� ���� ������ ��� �Ǽ��� ��ȭ ���� �ش� ���վȿ��� �հ� �� ī��Ʈ ���� ����� �� �ִ� �Լ�

create table product_group (
	group_id serial primary key,
	group_name varchar (255) not null
)

create table product (
	product_id serial primary key,
	product_name varchar (255) not null,
	price decimal (11,2),
	group_id int not null,
	foreign key (group_id)
	references product_group (group_id)
);

insert into product_group (group_name)
values 
 ('SmartPhone'),
 ('Laptop'),
 ('Tablet');

insert into product (product_name, group_id, price)
values
 ('Microsoft Lumia', 1, 200),
 ('Htc One', 1, 400),
 ('Nexus', 1, 500),
 ('iPhone', 1, 900),
 ('HP Elite',2, 1200),
 ('Lenovo Thinkpad', 2, 700),
 ('Sony VAIO', 2, 700),
 ('Dell Vostro', 2, 800),
 ('iPad', 3, 700),
 ('Kindle Fire', 3, 150),
 ('Samsung Galaxy Tab', 3, 200);

select * from product_group;
select * from product;

select COUNT(*) from product;
-- �����Լ��� �Ѱ� > �����Լ��� ������ ������� ����Ѵ�.

select count(*) over(), A.* from product A;


-- AVG �Լ�
select AVG (PRICE) over(), count(*) over(), A.* from product A;

select B.group_name , AVG(price) from product A
inner join product_group B
on A.group_id = B.group_id 
group by B.group_name;

select 
	A.product_name, A.price, B.group_name , AVG(price) over (partition by b.group_name) 
from product A
inner join product_group B
on A.group_id = B.group_id;

-- order by ���� ��������
select 
	A.product_name, A.price, B.group_name , AVG(price) over (partition by b.group_name order by A.price ) 
from product A
inner join product_group B
on A.group_id = B.group_id;


--- ROW_NUMBER, RANK, DENSE_RANK
-- row_number : ���� ������ �־ ������ ���������� ������ �ű��.
select 
	A.product_name ,
	B.group_name ,
	A.price ,
	row_number () over (partition  by b.group_name  order by a.price )
from product A
inner join product_group B
on A.group_id = B.group_id 

-- rank - ���� ������ ���� �����鼭 ���� ���� �ǳʶڴ� (ex: 1, 1, 3, 4 ...)
select 
	A.product_name ,
	B.group_name ,
	A.price ,
	rank () over (partition  by b.group_name  order by a.price desc)
from product A
inner join product_group B
on A.group_id = B.group_id

-- DENSE_RANK - ���� ������ ���� �����鼭 ���� ���� �ǳʶ��� ���� (ex: 1, 1, 2, 3, ...)
select 
	A.product_name ,
	B.group_name ,
	A.price ,
	dense_rank () over (partition  by b.group_name  order by a.price desc)
from product A
inner join product_group B
on A.group_id = B.group_id


-- FIRST_VALUE, LAST_VALUE
-- FIRST_VALUE - ù��° ���� �̴´�.
select
	A.product_name , B.group_name , A.price ,
	first_value (A.price) over (partition by B.group_name order by A.price) as LOWEST_PRICE_PER_GROUP
from product A
inner join product_group B
on a.group_id  = b.group_id 

-- LAST_VALUE - ������ ���� �̴´�.
select
	A.product_name , B.group_name , A.price ,
	LAST_value (A.price) over 						-- ���� �������� ������ PRICE ���� ����Ѵ�.
	(partition by B.group_name order by A.price		-- GROUP_NAME �÷� �������� PRICE �÷����� ������ �� �߿���
	range between unbounded preceding 				-- ��Ƽ���� ù��° �ο����
	and unbounded following							-- ��Ƽ���� ������ �ο����
	) as LOWEST_PRICE_PER_GROUP
from product A
inner join product_group B
on a.group_id  = b.group_id


-- LAG, LEAD
-- LAG - ���� ���� ���� ã�´�.
select
	A.product_name , B.group_name , A.price ,
	lag (A.price , 1) over (partition by B.group_name order by A.price) as PREV_PRICE,
	A.price - lag (PRICE, 1) over (partition by group_name order by A.price) as CUR_PREV_DIFF
from product A
inner join product_group b
on A.group_id = B.group_id 

-- LEAD - ���� ���� ���� ã�´�.
select
	A.product_name , B.group_name , A.price ,
	LEAD (A.price , 1) over (partition by B.group_name order by A.price) as NEXT_PRICE,
	A.price - LEAD (PRICE, 1) over (partition by group_name order by A.price) as CUR_NEXT_DIFF
from product A
inner join product_group b
on A.group_id = B.group_id


-- part03. �ǽ� ����
-- rental ���̺��� �̿��Ͽ� ��, ����, ������, ��ü ������ �������� rental_id ���� ��Ż�� �Ͼ Ƚ���� ����϶�
select * from rental;

select
	to_char(rental_date, 'YYYY') 
	,count(*) 
from rental group by to_char(rental_date, 'YYYY')

select
	to_char(rental_date, 'YYYYMM') 
	,count(*) 
from rental 
group by to_char(rental_date, 'YYYYMM') 
order by to_char(rental_date, 'YYYYMM')

select
	to_char(rental_date, 'YYYYMMDD') 
	,count(*) 
from rental 
group by to_char(rental_date, 'YYYYMMDD')
order by to_char(rental_date, 'YYYYMMDD')

select count(*)
from rental;

select 
	to_char(rental_date, 'YYYY') Y,
	to_char(rental_date, 'MM') M,
	to_char(rental_date, 'DD') D,
	count(*)
from rental
group by 
	rollup (
		to_char(rental_date, 'YYYY'),
		to_char(rental_date, 'MM'),
		to_char(rental_date, 'DD')
	)


	
select a.customer_id, count(*) rental_count
from rental A
group by A.customer_id
order by rental_count desc;

select 
	a.customer_id,
	row_number () over (order by count(a.rental_id) desc) rental_rank,
	count(*) rental_count,
	B.first_name ,
	B.last_name 
from rental A
inner join customer B
on A.customer_id = B.customer_id 
group by A.customer_id, B.first_name, B.last_name 
order by rental_rank
limit 1


-- ���� �����ڿ� ��������
-- union ����
-- �� ���� select ������ �ߺ��Ǵ� ������ ���� �ִٸ� �ߺ��� ���ŵȴ�.
create table sales2007_1(
	name varchar(50),
	amount numeric(15,2)
);

insert into sales2007_1 values 
('Mike', 150000.25),
('Jon', 132000.75),
('Mary', 100000);

create table sales2007_2 (
	name varchar(50),
	amount numeric(15,2)
);

insert into sales2007_2 values
('Mkie', 12000.25),
('Jon', 142000.75),
('Mary', 100000);

select * from sales2007_1
union
select * from sales2007_2
order by amount;

-- union all ����
-- union ���� �ߺ��� �����͵� ��� ����Ѵ�.
select * from sales2007_1
union all
select * from sales2007_2
order by amount desc;

-- intersect ����
-- �� �� �̻��� select ������ ��� ������ �ϳ��� ��� �������� �����Ѵ�.
-- ������ ����
create table employees(
	employee_id serial primary key,
	employee_name varchar(255) not null
);

create table keys(
	employee_id int primary key,
	effective_date date not null,
	foreign key (employee_id) references employees (employee_id)
);

create table hipos(
	employee_id int primary key,
	effective_date date not null,
	foreign key (employee_id) references employees (employee_id)
);

insert into employees (employee_name)
values
 ('Joyce Edwards'),
 ('Diane Collins'),
 ('Alice Stewart'),
 ('Julie Sanchez'),
 ('Heather Morris'),
 ('Teresa Rogers'),
 ('Doris Reed'),
 ('Gloria Cook'),
 ('Evelyn Morgan'),
 ('Jean Bell');

insert into keys
values
 (1, '2000-02-01'),
 (2, '2001-06-01'),
 (5, '2002-01-01'),
 (7, '2005-06-01');

insert into hipos
values
 (9, '2000-01-01'),
 (2, '2002-06-01'),
 (5, '2006-06-01'),
 (10, '2005-06-01');

select * from employees;
select * from keys;
select * from hipos;


select 
	employee_id 
from keys
intersect
select
	employee_id 
from hipos;

-- intersect ����� inner join ������ ����� �����ϴ�.
-- ������ �ǹ����� �� ������ ����.

select 
	employee_id 
from keys
intersect
select
	employee_id 
from hipos
order by employee_id desc;


-- except ����
-- ������ select ���� ��� ���տ��� �Ʒ��� �ִ� select ���� ��� ������ ������ ����� �����Ѵ�.
-- ������

