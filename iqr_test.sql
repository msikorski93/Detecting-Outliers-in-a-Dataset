--1. Create new table

create table dbo.products (
ref varchar(8),
width float(1),
depth float(1),
height float(1),
weight float(3));

--2. Find rows that do not meet condition D > W > H

select *
from products

full outer join

(select * from products
where depth >= width and width >= height) as t1
on products.ref=t1.ref
where t1.ref is null;

--3. Update these row(s)

update products
set width = 10, height = 5
where ref = 83298058;

--4. Display rows having any outlier in feature

declare @Q1_w float, @Q1_d float, @Q1_h float, @Q1_we float
declare @Q3_w float, @Q3_d float, @Q3_h float, @Q3_we float
declare @IQR_w float, @IQR_d float, @IQR_h float, @IQR_we float

--1. width quartiles
select @Q1_w = (select max(width)
from (
	select ref, width, ntile(4) over (order by width) as Q1_width
	from products) as quartile
where Q1_width = 1)

select @Q3_w = (select max(width)
from (
	select ref, width, ntile(4) over (order by width) as Q3_width
	from products) as quartile
where Q3_width = 3)

select @IQR_w = @Q3_w - @Q1_w

--2. depth quartiles
select @Q1_d = (select max(depth)
from (
	select ref, depth, ntile(4) over (order by depth) as Q1_depth
	from products) as quartile
where Q1_depth = 1)

select @Q3_d = (select max(depth)
from (
	select ref, depth, ntile(4) over (order by depth) as Q3_depth
	from products) as quartile
where Q3_depth = 3)

select @IQR_d = @Q3_d - @Q1_d

--3. height quartiles
select @Q1_h = (select max(height)
from (
	select ref, height, ntile(4) over (order by height) as Q1_height
	from products) as quartile
where Q1_height = 1)

select @Q3_h = (select max(height)
from (
	select ref, height, ntile(4) over (order by height) as Q3_height
	from products) as quartile
where Q3_height = 3)

select @IQR_h = @Q3_h - @Q1_h

--4. weight quartiles
select @Q1_we = (select max(weight)
from (
	select ref, weight, ntile(4) over (order by weight) as Q1_weight
	from products) as quartile
where Q1_weight = 1)

select @Q3_we = (select max(weight)
from (
	select ref, weight, ntile(4) over (order by weight) as Q3_weight
	from products) as quartile
where Q3_weight = 3)

select @IQR_we = @Q3_we - @Q1_we

select * from products
where width < (@Q1_w - 1.5 * @IQR_w) or width > (@Q3_w + 1.5 * @IQR_w)
or depth < (@Q1_d - 1.5 * @IQR_d) or depth > (@Q3_d + 1.5 * @IQR_d)
or height < (@Q1_h - 1.5 * @IQR_h) or height > (@Q3_h + 1.5 * @IQR_h)
or weight < (@Q1_we - 1.5 * @IQR_we) or weight > (@Q3_we + 1.5 * @IQR_we);

--5. Number of outliers for each dimension

declare @Q1_w float, @Q1_d float, @Q1_h float, @Q1_we float
declare @Q3_w float, @Q3_d float, @Q3_h float, @Q3_we float
declare @IQR_w float, @IQR_d float, @IQR_h float, @IQR_we float

--1. width quartiles
select @Q1_w = (select max(width)
from (
	select ref, width, ntile(4) over (order by width) as Q1_width
	from products) as quartile
where Q1_width = 1)

select @Q3_w = (select max(width)
from (
	select ref, width, ntile(4) over (order by width) as Q3_width
	from products) as quartile
where Q3_width = 3)

select @IQR_w = @Q3_w - @Q1_w

--2. depth quartiles
select @Q1_d = (select max(depth)
from (
	select ref, depth, ntile(4) over (order by depth) as Q1_depth
	from products) as quartile
where Q1_depth = 1)

select @Q3_d = (select max(depth)
from (
	select ref, depth, ntile(4) over (order by depth) as Q3_depth
	from products) as quartile
where Q3_depth = 3)

select @IQR_d = @Q3_d - @Q1_d

--3. height quartiles
select @Q1_h = (select max(height)
from (
	select ref, height, ntile(4) over (order by height) as Q1_height
	from products) as quartile
where Q1_height = 1)

select @Q3_h = (select max(height)
from (
	select ref, height, ntile(4) over (order by height) as Q3_height
	from products) as quartile
where Q3_height = 3)

select @IQR_h = @Q3_h - @Q1_h

--4. weight quartiles
select @Q1_we = (select max(weight)
from (
	select ref, weight, ntile(4) over (order by weight) as Q1_weight
	from products) as quartile
where Q1_weight = 1)

select @Q3_we = (select max(weight)
from (
	select ref, weight, ntile(4) over (order by weight) as Q3_weight
	from products) as quartile
where Q3_weight = 3)

select @IQR_we = @Q3_we - @Q1_we

select count(ref) as count_outliers, 'width' as dim
from products
where width < (@Q1_w - 1.5 * @IQR_w) or width > (@Q3_w + 1.5 * @IQR_w)
union all
select count(ref), 'depth'
from products
where depth < (@Q1_d - 1.5 * @IQR_d) or depth > (@Q3_d + 1.5 * @IQR_d)
union all
select count(ref), 'height'
from products
where height < (@Q1_h - 1.5 * @IQR_h) or height > (@Q3_h + 1.5 * @IQR_h)
union all
select count(ref), 'weight'
from products
where weight < (@Q1_we - 1.5 * @IQR_we) or weight > (@Q3_we + 1.5 * @IQR_we);

--6. Check each observation for outliers

declare @Q1_w float, @Q1_d float, @Q1_h float, @Q1_we float
declare @Q3_w float, @Q3_d float, @Q3_h float, @Q3_we float
declare @IQR_w float, @IQR_d float, @IQR_h float, @IQR_we float

--1. width quartiles
select @Q1_w = (select max(width)
from (
	select ref, width, ntile(4) over (order by width) as Q1_width
	from products) as quartile
where Q1_width = 1)

select @Q3_w = (select max(width)
from (
	select ref, width, ntile(4) over (order by width) as Q3_width
	from products) as quartile
where Q3_width = 3)

select @IQR_w = @Q3_w - @Q1_w

--2. depth quartiles
select @Q1_d = (select max(depth)
from (
	select ref, depth, ntile(4) over (order by depth) as Q1_depth
	from products) as quartile
where Q1_depth = 1)

select @Q3_d = (select max(depth)
from (
	select ref, depth, ntile(4) over (order by depth) as Q3_depth
	from products) as quartile
where Q3_depth = 3)

select @IQR_d = @Q3_d - @Q1_d

--3. height quartiles
select @Q1_h = (select max(height)
from (
	select ref, height, ntile(4) over (order by height) as Q1_height
	from products) as quartile
where Q1_height = 1)

select @Q3_h = (select max(height)
from (
	select ref, height, ntile(4) over (order by height) as Q3_height
	from products) as quartile
where Q3_height = 3)

select @IQR_h = @Q3_h - @Q1_h

--4. weight quartiles
select @Q1_we = (select max(weight)
from (
	select ref, weight, ntile(4) over (order by weight) as Q1_weight
	from products) as quartile
where Q1_weight = 1)

select @Q3_we = (select max(weight)
from (
	select ref, weight, ntile(4) over (order by weight) as Q3_weight
	from products) as quartile
where Q3_weight = 3)

select @IQR_we = @Q3_we - @Q1_we

select ref,
width,
case when width < (@Q1_w - 1.5 * @IQR_w) or width > (@Q3_w + 1.5 * @IQR_w) then 'true' else 'false' end as width_outlier,
depth,
case when depth < (@Q1_d - 1.5 * @IQR_d) or depth > (@Q3_d + 1.5 * @IQR_d) then 'true' else 'false' end as depth_outlier,
height,
case when height < (@Q1_h - 1.5 * @IQR_h) or height > (@Q3_h + 1.5 * @IQR_h) then 'true' else 'false' end as height_outlier,
weight,
case when weight < (@Q1_we - 1.5 * @IQR_we) or weight > (@Q3_we + 1.5 * @IQR_we) then 'true' else 'false' end as weight_outlier
from products;