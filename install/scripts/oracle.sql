-----------------------------------------------------------------------------
--  DATABASE SCHEMA
--
--  TABLE SWM_ROLES
--  Role's table
--
--  TABLE SWM_USER_STATES
--  States for users
--
--  TABLE SWM_USERS
--  User's table
--
--  TABLE SWM_CONNECTION_TYPES
--  Connection types table
--
--  TABLE SWM_CONN_TYPE_FIELDS
--  Connection types fields
--
--  TABLE SWM_USER_CONNECTIONS
--  User connection stored
--
--  TABLE SWM_USER_CONN_DETAILS
--  Details connection stored
--
-----------------------------------------------------------------------------

-- TABLE SWM_ROLES
CREATE TABLE SWM_ROLES
(
	ROLE_ID				NUMERIC(2,0)				NOT NULL,
	ROLENAME			VARCHAR2(100)				NOT NULL,
	RECORD_DATE			TIMESTAMP					NOT NULL
);

ALTER TABLE SWM_ROLES ADD CONSTRAINT SWM_ROLES_PK
PRIMARY KEY (ROLE_ID);

CREATE TRIGGER SWM_ROLES_BI_TR
BEFORE INSERT ON SWM_ROLES
FOR EACH ROW ENABLE
BEGIN
	SELECT SYSDATE INTO :NEW.RECORD_DATE FROM DUAL;
END;
/

-- TABLE SWM_USER_STATES
CREATE TABLE SWM_USER_STATES
(
	USER_STATE_ID		NUMERIC(2,0)				NOT NULL,
	DESCRIPTION			VARCHAR2(100)				NOT NULL
);

ALTER TABLE SWM_USER_STATES ADD CONSTRAINT SWM_USER_STATES_PK
PRIMARY KEY (USER_STATE_ID);

-- TABLE SWM_USERS
CREATE TABLE SWM_USERS
(
    USER_ID				NUMERIC(4,0)				NOT NULL,
    USERNAME		    VARCHAR2(20)				NOT NULL,
    USER_STATE_ID		NUMERIC(2,0)				NOT NULL,
    ROLE_ID				NUMERIC(2,0)				NULL,
    USER_PASSWORD		VARCHAR2(60)				NOT NULL,
    EMAIL				VARCHAR2(50)				NOT NULL,
    TOKEN				VARCHAR2(30)				NULL,
    RECORD_DATE			TIMESTAMP					NOT NULL
);

ALTER TABLE SWM_USERS ADD CONSTRAINT SWM_USERS_PK
PRIMARY KEY (USER_ID);

ALTER TABLE SWM_USERS ADD CONSTRAINT SWM_USERS_UNIQUE
UNIQUE (USERNAME);

ALTER TABLE SWM_USERS ADD CONSTRAINT SWM_USRS_FK_STATE
FOREIGN KEY (USER_STATE_ID) REFERENCES SWM_USER_STATES (USER_STATE_ID);

ALTER TABLE SWM_USERS ADD CONSTRAINT SWM_USERS_FK_ROLE
FOREIGN KEY (ROLE_ID) REFERENCES SWM_ROLES (ROLE_ID);

CREATE TRIGGER SWM_USERS_BI_TR
BEFORE INSERT ON SWM_USERS
FOR EACH ROW ENABLE
BEGIN
	SELECT SYSDATE INTO :NEW.RECORD_DATE FROM DUAL;
END;
/

-- TABLE SWM_CONN_IDENTIFIERS
CREATE TABLE SWM_CONN_IDENTIFIERS
(
	CONN_IDENTI_ID		NUMERIC(2,0)				NOT NULL,
	CONN_IDENTI_NAME	VARCHAR2(6)					NOT NULL
);

ALTER TABLE SWM_CONN_IDENTIFIERS ADD CONSTRAINT SWM_CONN_IDENTIFIERS_PK
PRIMARY KEY (CONN_IDENTI_ID);

-- TABLE SWM_CONNECTION_TYPES
CREATE TABLE SWM_CONNECTION_TYPES
(
	CONN_TYPE_ID		NUMERIC(2,0)				NOT NULL,
	CONN_TYPE_NAME		VARCHAR2(20)				NOT NULL
);

ALTER TABLE SWM_CONNECTION_TYPES ADD CONSTRAINT SWM_CONNECTION_TYPES_PK
PRIMARY KEY (CONN_TYPE_ID);

-- TABLE SWM_CONN_TYPE_FIELDS
CREATE TABLE SWM_CONN_TYPE_FIELDS
(
	CONN_TYPE_ID 		NUMERIC(3,0)				NOT NULL,
	CONN_IDENTI_ID		NUMERIC(2,0)				NOT NULL,
	FIELD_NAME			VARCHAR2(20)				NOT NULL,
	PLACEHOLDER			VARCHAR2(60)				NULL
);

ALTER TABLE SWM_CONN_TYPE_FIELDS ADD CONSTRAINT SWM_CONN_TYPE_FIELDS_PK
PRIMARY KEY (CONN_TYPE_ID, CONN_IDENTI_ID);

ALTER TABLE SWM_CONN_TYPE_FIELDS ADD CONSTRAINT SWM_CONN_TYPE_FIELDS_FK_TYPE
FOREIGN KEY (CONN_TYPE_ID) REFERENCES SWM_CONNECTION_TYPES (CONN_TYPE_ID);

ALTER TABLE SWM_CONN_TYPE_FIELDS ADD CONSTRAINT SWM_CONN_TYPE_FIELDS_FK_IDENTI
FOREIGN KEY (CONN_IDENTI_ID) REFERENCES SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID);

-- TABLE SWM_USER_CONNECTIONS
CREATE TABLE SWM_USER_CONNECTIONS
(
    USER_CONN_ID		NUMERIC(6,0)				NOT NULL,
	CONN_TYPE_ID 		NUMERIC(3,0)				NOT NULL,
    USER_ID				NUMERIC(4,0)				NOT NULL,
    CONNECTION_NAME		VARCHAR2(100)				NOT NULL,
    STATE       		CHAR(1)						NOT NULL,
    RECORD_DATE			TIMESTAMP					NOT NULL
);

ALTER TABLE SWM_USER_CONNECTIONS ADD CONSTRAINT SWM_USER_CONNECTIONS_PK
PRIMARY KEY (USER_CONN_ID);

ALTER TABLE SWM_USER_CONNECTIONS ADD CONSTRAINT SWM_USER_CONNECTIONS_FK_TYPE
FOREIGN KEY (CONN_TYPE_ID) REFERENCES SWM_CONNECTION_TYPES (CONN_TYPE_ID);

ALTER TABLE SWM_USER_CONNECTIONS ADD CONSTRAINT SWM_USER_CONNECTIONS_FK_USER
FOREIGN KEY (USER_ID) REFERENCES SWM_USERS (USER_ID);

CREATE TRIGGER SWM_USER_CONN_BI_TR
BEFORE INSERT ON SWM_USER_CONNECTIONS
FOR EACH ROW ENABLE
BEGIN
	SELECT SYSDATE INTO :NEW.RECORD_DATE FROM DUAL;
END;
/

-- TABLE SWM_USER_CONN_DETAILS
CREATE TABLE SWM_USER_CONN_DETAILS
(
    USER_CONN_ID		NUMERIC(6,0)				NOT NULL,
	CONN_IDENTI_ID		NUMERIC(2,0)				NOT NULL,
	FIELD_VALUE	  		VARCHAR2(50)				NULL
);

ALTER TABLE SWM_USER_CONN_DETAILS ADD CONSTRAINT SWM_USER_CONN_DETAILS_PK
PRIMARY KEY (USER_CONN_ID, CONN_IDENTI_ID);

ALTER TABLE SWM_USER_CONN_DETAILS ADD CONSTRAINT SWM_USER_CONN_DET_FK_ID
FOREIGN KEY (USER_CONN_ID) REFERENCES SWM_USER_CONNECTIONS (USER_CONN_ID);


-----------------------------------------------------------------------------
--  BASIC DATA REQUIRED
-----------------------------------------------------------------------------

INSERT INTO SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID, CONN_IDENTI_NAME)
VALUES (1, 'dbhost');

INSERT INTO SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID, CONN_IDENTI_NAME)
VALUES (2, 'dbuser');

INSERT INTO SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID, CONN_IDENTI_NAME)
VALUES (3, 'dbpass');

INSERT INTO SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID, CONN_IDENTI_NAME)
VALUES (4, 'dbname');

INSERT INTO SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID, CONN_IDENTI_NAME)
VALUES (5, 'driver');

INSERT INTO SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID, CONN_IDENTI_NAME)
VALUES (6, 'dbchar');

INSERT INTO SWM_CONN_IDENTIFIERS (CONN_IDENTI_ID, CONN_IDENTI_NAME)
VALUES (7, 'dbport');

INSERT INTO SWM_CONNECTION_TYPES (CONN_TYPE_ID, CONN_TYPE_NAME)
VALUES (1, 'TNS');

INSERT INTO SWM_CONNECTION_TYPES (CONN_TYPE_ID, CONN_TYPE_NAME)
VALUES (2, 'Basic');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (1, 'Alias', 4, 'type the alias in the tns file');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (1, 'User', 2, 'user');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (1, 'Password', 3, 'password');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (1, 'Driver', 5, 'database driver');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (2, 'Host', 1, 'hostname');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (2, 'User', 2, 'user');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (2, 'Password', 3, 'password');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (2, 'Database name', 4, 'the database name');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (2, 'Driver', 5, 'database driver');

INSERT INTO SWM_CONN_TYPE_FIELDS (CONN_TYPE_ID, FIELD_NAME, CONN_IDENTI_ID, PLACEHOLDER)
VALUES (2, 'Port', 7, 'port');

INSERT INTO SWM_ROLES (ROLE_ID, ROLENAME)
VALUES (1, 'Administrator');

INSERT INTO SWM_ROLES (ROLE_ID, ROLENAME)
VALUES (2, 'Moderator');

INSERT INTO SWM_ROLES (ROLE_ID, ROLENAME)
VALUES (3, 'Guest');

INSERT INTO SWM_USER_STATES (USER_STATE_ID, DESCRIPTION)
VALUES (1, 'Pending activation');

INSERT INTO SWM_USER_STATES (USER_STATE_ID, DESCRIPTION)
VALUES (2, 'Actived');

INSERT INTO SWM_USER_STATES (USER_STATE_ID, DESCRIPTION)
VALUES (3, 'Banned');

INSERT INTO SWM_USERS (USER_ID, USERNAME, USER_STATE_ID, ROLE_ID, USER_PASSWORD, EMAIL)
VALUES (1, 'admin', 2, 2, '$2y$10$6b/9w1L5GPdnpXT2NpdNIe/b4SzYJ9gfRaOYP2xUXWbZ3ekR1GyHi', 'admin@localhost');
