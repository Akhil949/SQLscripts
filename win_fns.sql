Create database windowsfunction

USE windowsfunction
GO

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

INSERT INTO employees (employee_id, employee_name, department, salary, hire_date)
VALUES
(1, 'Amit', 'HR', 50000, '2022-01-15'),
(2, 'Neha', 'HR', 55000, '2023-03-10'),
(3, 'Suresh', 'HR', 48000, '2021-11-20'),
(4, 'Rohit', 'HR', 52000, '2022-09-05'),

(5, 'Raj', 'Finance', 60000, '2021-07-23'),
(6, 'Ravi', 'Finance', 62000, '2022-09-01'),
(7, 'Kiran', 'Finance', 58000, '2021-02-14'),
(8, 'Sunita', 'Finance', 61000, '2023-01-11'),

(9, 'Priya', 'IT', 70000, '2020-12-02'),
(10, 'Anjali', 'IT', 67000, '2021-11-19'),
(11, 'Vikas', 'IT', 69000, '2022-05-20'),
(12, 'Sanjay', 'IT', 72000, '2023-04-30'),
(13, 'Meena', 'IT', 68000, '2021-03-15');

Select * from employees

ALTER TABLE employees
ADD city VARCHAR(50);

UPDATE employees SET city = 'Hyderabad' WHERE employee_id IN (1,2,3);
UPDATE employees SET city = 'Mumbai' WHERE employee_id IN (4,5,6);
UPDATE employees SET city = 'Bangalore' WHERE employee_id IN (7,8,9);
UPDATE employees SET city = 'Hyderabad' WHERE employee_id IN (10,11);
UPDATE employees SET city = 'Chennai' WHERE employee_id IN (12,13);

-- below query will throuw an error because where FROM will be executed first then WHERE but there is no rn column 
-- in employees. so to overcome this we use subquery
select employee_name,department, salary , city,
ROW_NUMBER() over (partition by department,city order by salary desc) as rn 
from employees as t
where rn = 2


-- so to overcome above query error we use subquery and we are achieving it
-- first inner query will execute first then outer query FROM then WHERE
-- this method will work because we are already getting rn column from inner query
-- we won't get error

select * from -- this * will return all columns from inner query
(
select employee_name,department, salary , city,
ROW_NUMBER() over (partition by department,city order by salary desc) as rn 
from employees
)as t
where rn = 2

--to make it more readable we can use CTE

WITH emp_rn as
(
select employee_name,department, salary , city,
ROW_NUMBER() over (partition by department,city order by salary desc) as rn 
from employees
)
Select * from emp_rn where rn=2