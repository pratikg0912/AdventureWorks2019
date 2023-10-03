CREATE TABLE table_a(
col_a int)

INSERT INTO table_a (col_a)
VALUES (1)
INSERT INTO table_b (col_b)
VALUES (NULL)
INSERT INTO table_a (col_a)
VALUES (0)
INSERT INTO table_a (col_a)
VALUES (NULL)

select * from table_a
select * from table_b

select a.col_a as a, b.col_b as b
from table_a a
full outer join table_b b on a.col_a = b.col_b








