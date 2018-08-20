create TEMPORARY table calculation(id char(10), qty tinyint);
insert into calculation values('a12a20aa12', 2);
insert into calculation values('j89h78fgfy', 2);
select sum(foodprice * qty) as total from food, calculation where `food`.`foodid` = `calculation`.id;