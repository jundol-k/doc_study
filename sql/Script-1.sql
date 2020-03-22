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













