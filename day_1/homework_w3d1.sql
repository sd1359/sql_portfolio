/* MVP Questions */
/* 1. Find all the employees who work in the ‘Human Resources’ department. */

SELECT *
FROM employees
WHERE department = 'Human Resources'

/* 2. Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department. */

SELECT
first_name, last_name, country
FROM employees
WHERE department = 'Legal'

/* 3. Count the number of employees based in Portugal. */

SELECT
COUNT(id) AS number_of_portugal_employees
FROM employees
WHERE country = 'Portugal'

/* 4. Count the number of employees based in either Portugal or Spain. */

SELECT
COUNT (id) as number_of_portugal_and_spain_employees
FROM employees
WHERE country = 'Portugal' OR country = 'Spain'

/* 5. Count the number of pay_details records lacking a local_account_no. */

SELECT
COUNT(id)
FROM pay_details
WHERE local_account_no IS NULL

/* 6. Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last). */

SELECT first_name, last_name
FROM employees
ORDER BY last_name ASC NULLS LAST

/* 7. How many employees have a first_name beginning with ‘F’? */

SELECT 
COUNT(id) AS first_names_starts_with_f
FROM employees
WHERE first_name ILIKE 'F%'

/* 8. Count the number of pension enrolled employees not based in either France or Germany. */

SELECT
COUNT(id)
FROM employees
WHERE country NOT IN ('France', 'Germany') AND pension_enrol = TRUE

/* 9. Obtain a count by department of the employees who started work with the corporation in 2003. */

SELECT
department, COUNT(id) AS employees_2003_start
FROM employees
WHERE start_date BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY department

/* 10. Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. Order the table alphabetically by department, and then in ascending order of fte_hours. */

SELECT
department, fte_hours, COUNT(id) AS number_of_employees_in_department
FROM employees
GROUP BY department, fte_hours
ORDER BY department ASC NULLS LAST, 
fte_hours ASC NULLS LAST

/* 11. Obtain a table showing any departments in which there are two or more employees lacking a stored first name. Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department. */

SELECT
department, COUNT(id) 
FROM employees
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY COUNT(id) DESC NULLS LAST,
department ASC NULLS LAST

/* 12. [Tough!] Find the proportion of employees in each department who are grade 1. */

SELECT 
  department, 
  SUM(CAST(grade = '1' AS INT)) / CAST(COUNT(id) AS REAL) AS prop_grade_1 
FROM employees 
GROUP BY department

           /* 13. Do a count by year of the start_date of all employees, ordered most recent year last. */

SELECT 
  EXTRACT(YEAR FROM start_date) AS year, 
  COUNT(id) AS num_employees_started 
FROM employees 
GROUP BY EXTRACT(YEAR FROM start_date) 
ORDER BY year ASC NULLS LAST


/* 14. Return the first_name, last_name and salary of all employees together with a new column called salary_class with a value 'low' where salary is less than 40,000 and value 'high' where salary is greater than or equal to 40,000. */

SELECT 
  first_name, 
  last_name, 
  CASE 
    WHEN salary < 40000 THEN 'low'
    WHEN salary IS NULL THEN NULL
    ELSE 'high' 
  END AS salary_class
FROM employees

/* 15. The first two digits of the local_sort_code (e.g. digits 97 in code 97-09-24) in the pay_details table are indicative of the region of an account. Obtain counts of the number of pay_details records bearing each set of first two digits? Make sure that the count of NULL local_sort_codes comes at the top of the table, and then order all subsequent rows first by counts in descending order, and then by the first two digits in ascending order */

SELECT
  SUBSTRING(local_sort_code, 1, 2) AS first_two_digits,
  COUNT(id) AS count_records
FROM pay_details
GROUP BY SUBSTRING(local_sort_code, 1, 2)
ORDER BY 
  CASE 
    WHEN SUBSTRING(local_sort_code, 1, 2) IS NULL THEN 1
    ELSE 0
  END DESC,
  count_records DESC,
  first_two_digits ASC
  
  /* Second Method */
  
  SELECT
  first_two_digits,
  count_records
FROM (
  SELECT
    CASE 
      WHEN SUBSTRING(local_sort_code, 1, 2) IS NULL THEN 1
      ELSE 0
    END AS is_null,
    SUBSTRING(local_sort_code, 1, 2) AS first_two_digits,
    COUNT(id) AS count_records
  FROM pay_details
  GROUP BY SUBSTRING(local_sort_code, 1, 2)
) AS temp_table
ORDER BY is_null DESC, count_records DESC, first_two_digits ASC

SELECT
  first_two_digits,
  count_records
FROM (
  SELECT
    SUBSTRING(local_sort_code, 1, 2) IS NULL, 
    SUBSTRING(local_sort_code, 1, 2),
    COUNT(id)
  FROM pay_details
  GROUP BY SUBSTRING(local_sort_code, 1, 2)
) temp_table(is_null, first_two_digits, count_records)
ORDER BY is_null DESC NULLS LAST, count_records DESC, first_two_digits ASC

/* 16. Return only the numeric part of the local_tax_code in the pay_details table, preserving NULLs where they exist in this column. */

SELECT
  local_tax_code,
  REGEXP_REPLACE(local_tax_code, '\D','','g') AS numeric_part_tax_code
FROM pay_details 









