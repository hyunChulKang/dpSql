CREATE TABLE jobs ( --**
		job_id VARCHAR2(10),
		job_title VARCHAR2(35),
		min_salary NUMBER(6),
		max_salary NUMBER(6),
        CONSTRAINT pk_job_id PRIMARY KEY (job_id)
);

CREATE TABLE regions ( --**
		region_id NUMBER,
		region_name VARCHAR2(25),
        CONSTRAINT pk_region_id PRIMARY KEY (region_id)
);

CREATE TABLE countries ( --**
		country_id CHAR(2),
		country_name VARCHAR2(40),
		region_id NUMBER,
        CONSTRAINT pk_country_id PRIMARY KEY (country_id)
);
		ALTER TABLE countries ADD CONSTRAINT fk_region_id FOREIGN KEY (region_id) REFERENCES regions (region_id);

CREATE TABLE locations ( --**
		location_id NUMBER(4),
		street_address VARCHAR2(40),
		postal_code VARCHAR2(12),
		city VARCHAR2(30),
		state_provnce VARCHAR2(25),
		country_id CHAR(2),
        CONSTRAINT pk_location_id PRIMARY KEY (location_id)
);
		ALTER TABLE locations ADD CONSTRAINT fk_cnt_id FOREIGN KEY (fk_country_id) REFERENCES countries (country_id);

CREATE TABLE departments ( 
		department_id NUMBER(4),
		department_name VARCHAR2(30),
        CONSTRAINT pk_department_id PRIMARY KEY (department_id)
);
        ALTER TABLE departments ADD CONSTRAINT fk_loc_id FOREIGN KEY (fk_location_id) REFERENCES locations (location_id);
        
CREATE TABLE job_history (
		start_date DATE ,
		end_date DATE,
        CONSTRAINT pk_start_date PRIMARY KEY (start_date)
);
        ALTER TABLE job_history ADD CONSTRAINT fk_job_id FOREIGN KEY (job_id) REFERENCES jobs (job_id);
        ALTER TABLE job_history ADD CONSTRAINT fk_dept_id FOREIGN KEY (department_id) REFERENCES departments(department_id);
CREATE TABLE employees  (
		employee_id NUMBER(6),
		first_name VARCHAR2(20),
		last_name VARCHAR2(25),
		email VARCHAR2(25),
		phone_number VARCHAR2(20),
		hire_date DATE,
		salary NUMBER (8,2),
		commission_pct NUMBER(2,2),
        CONSTRAINT pk_employee_id PRIMARY KEY (employee_id)
);
        ALTER TABLE employees ADD CONSTRAINT fk_dept_id FOREIGN KEY (department_id) REFERENCES departments (department_id);
        ALTER TABLE departments ADD CONSTRAINT fk_mgrager_id FOREIGN KEY (manager_id) REFERENCES employees (employee_id);
		ALTER TABLE employees ADD CONSTRAINT fk_jobs_id FOREIGN KEY (job_id) REFERENCES jobs (job_id);
        ALTER TABLE job_history ADD CONSTRAINT fk_emp_id FOREIGN KEY (EMPLOYEE_ID) REFERENCES employees (EMPLOYEE_ID);
       
		
        
		
		



		
DROP TABLE 	regions;
DROP TABLE 	countries;
DROP TABLE 	locations;
DROP TABLE 	departments;
DROP TABLE 	job_history;
DROP TABLE 	jobs;
DROP TABLE 	employees;
