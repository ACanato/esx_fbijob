USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_fbi','fbi',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_fbi','fbi',1)
;

INSERT INTO `jobs` (name, label) VALUES 
	('fbi','FBI')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('fbi',1,'recruit','Management and Program Analyst',20,'{}'),
	('fbi',2,'sergeant','Forensic Accountant',30,'{}'),
	('fbi',3,'lieutenant','Information Technology Specialist',40,'{}'),
	('fbi',4,'lieutenant','Forensic Psychologist',50,'{}'),
	('fbi',5,'lieutenant','Intelligence Analyst',60,'{}'),
	('fbi',6,'lieutenant','FBI Agent',70,'{}'),
	('fbi',6,'boss','Special Agent (Federal)',80,'{}')
;