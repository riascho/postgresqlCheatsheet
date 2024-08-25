create table cars (
	car_uid UUID NOT NULL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19, 2) NOT NULL CHECK (price > 1000)
);

create table persons (
    person_uid UUID NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender VARCHAR(20) NOT NULL,
	email VARCHAR(100) UNIQUE,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL,
	car_uid UUID REFERENCES cars(car_uid),
	UNIQUE (car_uid), 
	UNIQUE (email)
);

insert into persons (person_uid, first_name, last_name, gender, email, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Fernanda', 'Beardon', 'Female', 'fernandab@is.gd', '1953-10-28', 'Comoros');
insert into persons (person_uid, first_name, last_name, gender, email, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Omar', 'Colmore', 'Male', null, '1921-04-03', 'Finland');
insert into persons (person_uid, first_name, last_name, gender, email, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'John', 'Matuschek', 'Male', 'john@feedburner.com', '1965-02-28', 'England');
insert into persons (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Emelyne', 'Roycroft', 'eroycroft0@freewebs.com', 'Female', '2012-11-25', 'Colombia');
insert into persons (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Leticia', 'Stilling', 'lstilling1@studiopress.com', 'Female', '2003-06-03', 'Indonesia');
insert into persons (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Audrye', 'Fretter', 'afretter2@seattletimes.com', 'Female', '1924-05-12', 'United States');
insert into persons (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Deeann', 'Mandal', 'dmandal3@imageshack.us', 'Female', '2007-04-21', 'Estonia');
insert into persons (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Delmer', 'Ayce', 'dayce4@wired.com', 'Non-binary', '1947-04-03', 'Indonesia');
insert into persons (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Elvina', 'Laurentin', 'elaurentin5@harvard.edu', 'Genderqueer', '2001-10-20', 'Ivory Coast');
insert into persons (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth) values (uuid_generate_v4(), 'Gwenore', 'Reichelt', null, 'Female', '1969-04-13', 'Latvia');

insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Land Rover', 'Sterling', '87665.38');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'GMC', 'Acadia', '17662.69');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Infiniti', 'JX', '15329.01');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Pontiac', 'LeMans', '7877.24');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Infiniti', 'QX', '25501.84');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'BMW', 'X5', '2214.49');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Audi', 'TT', '23672.38');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Mazda', 'B-Series Plus', '55051.61');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Mazda', 'B-Series', '7566.21');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Ford', 'Explorer', '87655.26');
insert into cars (car_uid, make, model, price) values (uuid_generate_v4(), 'Cadillac', 'CTS', '21133.40');