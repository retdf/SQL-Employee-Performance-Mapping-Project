-- 1.	Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database from the given resources.
create schema employee;
-- 3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM
    emp_record_table
ORDER BY EMP_ID , DEPT;
-- 4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
-- ●	less than two
-- ●	greater than four 
-- ●	between two and four
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING,
    
 CASE
        WHEN EMP_RATING < 2 THEN 'less than two'
        WHEN EMP_RATING > 4 THEN 'greater than four'
        WHEN EMP_RATING BETWEEN 2 AND 4 THEN 'between two and four'
        end as rating
from 
    emp_record_table;

 


-- 5.-- 	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
SELECT 
    FIRST_NAME,
    LAST_NAME,
    DEPT,
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS 'NAME'
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';
    
-- 6.	Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).

select  (count(EMP_ID)) as  'number of employees reporting' from emp_record_table;




-- 7.	Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, ROLE, DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'Finance' 
UNION SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, ROLE, DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'Healthcare';
-- 8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department

select EMP_ID,ROLE,DEPT,max(EMP_RATING) over(partition by DEPT) as 'Max_Emp_rating'
from emp_record_table
order by DEPT , EMP_ID;
-- 9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
select ROLE,
 max(salary) as 'Maximum Salary',
 min(salary) as 'Minimum Salary'
 from emp_record_table
 group  by ROLE;
--  10.	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
select EMP_ID,FIRST_NAME,LAST_NAME,EXP,
rank () over(order by exp desc) as 'Rank'
from emp_record_table;

-- 11.	Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
CREATE VIEW emp_record_view AS
    SELECT 
        EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
    FROM
        emp_record_table
    WHERE
        salary > 6000;
-- 12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, exp
FROM
    emp_record_table
WHERE
    exp > (SELECT 
            exp
        FROM
            emp_record_table
        WHERE
            exp = 9);
-- 13.	Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
delimiter //
create procedure employee_details()
begin 
select * from 
emp_record_table where exp > 3;
end //
delimiter ;
call  employee_details();
-- 14.	Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.

-- The standard being:
-- For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
-- For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
-- For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
-- For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
-- For an employee with the experience of 12 to 16 years assign 'MANAGER'.
DELIMITER $$ 
CREATE FUNCTION JOB_PROFILE(
	EXP  decimal(10,2)
    )
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
	
    DECLARE STANDARD VARCHAR(50) DEFAULT '';

    IF EXP <= 2 THEN
		SET STANDARD = "JUNIOR DATA SCIENTIST";
	ELSEIF EXP between 2 AND 5 THEN
		SET STANDARD = "ASSOCIATE DATA SCIENTIST";
	ELSEIF EXP BETWEEN 5 AND 10 THEN
		SET STANDARD = "SENIOR DATA SCIENTIST";
        ELSEIF EXP BETWEEN 10 AND 12 THEN
		SET STANDARD = "LEAD DATA SCIENTIST";
        ELSEIF EXP  BETWEEN 12 AND 16 THEN
        SET STANDARD = "MANAGER";
	END IF;
    
RETURN (STANDARD);
END $$
DELIMITER ; 

select EMP_ID,FIRST_NAME,LAST_NAME ,EXP,lower(JOB_PROFILE (exp)) as ' JOB POSITION'
from emp_record_table 
where exp < 20;



-- 15.	Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
create index idx_FIRST_NAME on emp_record_table(FIRST_NAME);
SELECT 
    *
FROM
    emp_record_table
WHERE
    FIRST_NAME = 'Eric';

-- 16.	Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EMP_RATING,
    SALARY,
    (salary * 0.05 * EMP_RATING) AS 'Bonus'
FROM
    emp_record_table;

-- 17-- Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
SELECT 
    continent, COUNTRY, AVG(Salary) AS 'AVG salary'
FROM
    emp_record_table
GROUP BY 1 , 2;





























 
 

 







