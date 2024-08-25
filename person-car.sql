create table cars (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19, 2) NOT NULL
);

create table persons (
    id BIGSERIAL NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender VARCHAR(20) NOT NULL,
	email VARCHAR(100) UNIQUE,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL,
	car_id BIGINT REFERENCES cars(id),
	UNIQUE (car_id)
);

insert into persons (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('Fernanda', 'Beardon', 'Female', 'fernandab@is.gd', '1953-10-28', 'Comoros');
insert into persons (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('Omar', 'Colmore', 'Male', null, '1921-04-03', 'Finland');
insert into persons (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('John', 'Matuschek', 'Male', 'john@feedburner.com', '1965-02-28', 'England');
insert into persons (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Emelyne', 'Roycroft', 'eroycroft0@freewebs.com', 'Female', '2012-11-25', 'Colombia');
insert into persons (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Leticia', 'Stilling', 'lstilling1@studiopress.com', 'Female', '2003-06-03', 'Indonesia');
insert into persons (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Audrye', 'Fretter', 'afretter2@seattletimes.com', 'Female', '1924-05-12', 'United States');
insert into persons (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Deeann', 'Mandal', 'dmandal3@imageshack.us', 'Female', '2007-04-21', 'Estonia');
insert into persons (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Delmer', 'Ayce', 'dayce4@wired.com', 'Non-binary', '1947-04-03', 'Indonesia');
insert into persons (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Elvina', 'Laurentin', 'elaurentin5@harvard.edu', 'Genderqueer', '2001-10-20', 'Ivory Coast');
insert into persons (first_name, last_name, email, gender, date_of_birth, country_of_birth) values ('Gwenore', 'Reichelt', null, 'Female', '1969-04-13', 'Latvia');

insert into cars (make, model, price) values ('Land Rover', 'Sterling', '87665.38');
insert into cars (make, model, price) values ('GMC', 'Acadia', '17662.69');
insert into cars (make, model, price) values ('Infiniti', 'JX', '15329.01');
insert into cars (make, model, price) values ('Pontiac', 'LeMans', '7877.24');
insert into cars (make, model, price) values ('Infiniti', 'QX', '25501.84');
insert into cars (make, model, price) values ('BMW', 'X5', '2214.49');
insert into cars (make, model, price) values ('Audi', 'TT', '23672.38');
insert into cars (make, model, price) values ('Mazda', 'B-Series Plus', '55051.61');
insert into cars (make, model, price) values ('Mazda', 'B-Series', '7566.21');
insert into cars (make, model, price) values ('Ford', 'Explorer', '87655.26');
insert into cars (make, model, price) values ('Cadillac', 'CTS', '21133.40');