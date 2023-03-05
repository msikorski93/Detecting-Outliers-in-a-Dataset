--1. Overall Z-scores for each observation
--1a. numeric values
with tab1 as (
select
avg(width) as mean_w,
stdev(width) as std_w,

avg(depth) as mean_d,
stdev(depth) as std_d,

avg(height) as mean_h,
stdev(height) as std_h,

avg(weight) as mean_we,
stdev(weight) as std_we
from products)

select ref,
width,
abs(width - tab1.mean_w) / tab1.std_w as z_score_width,
depth,
abs(depth - tab1.mean_d) / tab1.std_d as z_score_depth,
height,
abs(height - tab1.mean_h) / tab1.std_h as z_score_height,
weight,
abs(weight - tab1.mean_we) / tab1.std_we as z_score_weight
from tab1, products;

--1b. boolean values

with tab1 as (
select
avg(width) as mean_w,
stdev(width) as std_w,

avg(depth) as mean_d,
stdev(depth) as std_d,

avg(height) as mean_h,
stdev(height) as std_h,

avg(weight) as mean_we,
stdev(weight) as std_we
from products)

select ref,
width,
case when abs(width - tab1.mean_w) / tab1.std_w > 3 then 'true' else 'false' end as z_score_width,
depth,
case when abs(depth - tab1.mean_d) / tab1.std_d > 3 then 'true' else 'false' end as z_score_depth,
height,
case when abs(height - tab1.mean_h) / tab1.std_h > 3 then 'true' else 'false' end as z_score_height,
weight,
case when abs(weight - tab1.mean_we) / tab1.std_we > 3 then 'true' else 'false' end as z_score_weight
from tab1, products;

--2. Number of outliers for each dimension

with tab1 as (
select
avg(width) as mean_w,
stdev(width) as std_w,

avg(depth) as mean_d,
stdev(depth) as std_d,

avg(height) as mean_h,
stdev(height) as std_h,

avg(weight) as mean_we,
stdev(weight) as std_we
from products)

select count(ref) as count_outliers, 'width' as dim
from tab1, products
where abs(width - tab1.mean_w) / tab1.std_w > 3
union all
select count(ref), 'depth'
from tab1, products
where abs(depth - tab1.mean_d) / tab1.std_d > 3
union all
select count(ref), 'height'
from tab1, products
where abs(height - tab1.mean_h) / tab1.std_h > 3
union all
select count(ref), 'weight'
from tab1, products
where abs(weight - tab1.mean_we) / tab1.std_we > 3;

--3. Number of rows having any outlier in feature

with tab1 as (
select
avg(width) as mean_w,
stdev(width) as std_w,

avg(depth) as mean_d,
stdev(depth) as std_d,

avg(height) as mean_h,
stdev(height) as std_h,

avg(weight) as mean_we,
stdev(weight) as std_we
from products)

select count(ref) as count_all_outliers
from tab1, products
where abs(width - tab1.mean_w) / tab1.std_w > 3
or abs(depth - tab1.mean_d) / tab1.std_d > 3
or abs(height - tab1.mean_h) / tab1.std_h > 3
or abs(weight - tab1.mean_we) / tab1.std_we > 3;