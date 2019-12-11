CREATE TABLE employees  (
		employees_id VARCHAR2(6) PRIMARY KEY,
		firest_name VARCHAR2(20),
		last_name VARCHAR2(25),
		email VARCHAR2(25),
		phone_number VARCHAR2(20),
		hire_date DATE,
		salary NUMBER (8,2),
		commission_pct NUMBER(2,2),
		department_id NUMBER(4),
		 CONSTRAINT fk_job_id FOREIGN KEY (job_id) REFERENCES jobs (job_id),
		 CONSTRAINT fk_mgr_id FOREIGN KEY (manager_id) REFERENCES employees (employees_id),
		 CONSTRAINT fk_dept_id FOREIGN KEY (department_id) REFERENCES departments (department_id)
);

CREATE TABLE jobs ( --**
		job_id VARCHAR2(10) PRIMARY KEY,
		job_title VARCHAR2(35),
		min_salary NUMBER(6),
		max_salary NUMBER(6)
);

CREATE TABLE job_history (
		start_date DATE PRIMARY KEY,
		end_date DATE,
		job_id VARCHAR2(10),
		department_id NUMBER (4),
		CONSTRAINT fk_job_id FOREIGN KEY (job_id) REFERENCES jobs (job_id),
		CONSTRAINT fk_emp_id FOREIGN KEY (employees_id) REFERENCES employees (employees_id),
		CONSTRAINT fk_dept_id FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE departments ( 
		department_id NUMBER(4) PRIMARY KEY,
		department_name VARCHAR2(30),
		managre_id NUMBER(6),
		location_id NUMBER(4),
		CONSTRAINT fk_mgr_id FOREIGN KEY (manager_id) REFERENCES employees (manager_id),
		CONSTRAINT fk_loc_id FOREIGN KEY (location_id) REFERENCES locations (location_id)
		
);

CREATE TABLE locations ( --**
		location_id NUMBER(4) PRIMARY KEY,
		street_address VARCHAR2(40),
		postal_code VARCHAR2(12),
		city VARCHAR2(30),
		state_provnce VARCHAR2(25),
		country_id CHAR(2),
		CONSTRAINT fk_cnt_id FOREIGN KEY (country_id) REFERENCES countries (country_id)
		
);

CREATE TABLE countries ( --**
		country_id CHAR(2)PRIMARY KEY,
		country_name VARCHAR2(40),
		region_id NUMBER,
		CONSTRAINT fk_region_id FOREIGN KEY (region_id) REFERENCES regions (region_id)
);

CREATE TABLE regions ( --**
		region_id NUMBER PRIMARY KEY,
		region_name VARCHAR2(25)
);

DROP TABLE 	regions;
DROP TABLE 	countries;
DROP TABLE 	locations;
DROP TABLE 	departments;
DROP TABLE 	job_history;
DROP TABLE 	jobs;
DROP TABLE 	employees;