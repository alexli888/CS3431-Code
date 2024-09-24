CREATE TABLE Employee (
                          ID NUMBER PRIMARY KEY,
                          FName VARCHAR(50) NOT NULL,
                          LName VARCHAR(50) NOT NULL,
                          Salary DECIMAL(10, 2) NOT NULL CHECK ( Salary >= 0 ),
                          jobTitle VARCHAR(100) NOT NULL,
                          OfficeNum VARCHAR(10),
                          empRank NUMBER NOT NULL CHECK ( empRank IN (0,1,2)), -- Rank of the employee: 0 for Regular, 1 for Division Manager, 2 for General Manager
                          SupervisorID NUMBER,
                          AddressStreet VARCHAR(100) NOT NULL,
                          AddressCity VARCHAR(50) NOT NULL,
                          CONSTRAINT supervisorID_fk FOREIGN KEY (SupervisorID) REFERENCES Employee(ID)
);

CREATE TABLE Doctor (
                        EmployeeID NUMBER PRIMARY KEY,
                        Gender CHAR(1) NOT NULL CHECK ( Gender IN ('M', 'F')),
                        Specialty VARCHAR(100) NOT NULL,
                        GraduatedFrom VARCHAR(100) NOT NULL,
                        CONSTRAINT empID_fk FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
);

CREATE TABLE EquipmentTechnician (
                                     EmployeeID NUMBER PRIMARY KEY,
                                     CONSTRAINT empIDTech_fk FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
);

CREATE TABLE EquipmentType (
                               TypeID NUMBER PRIMARY KEY,
                               Description VARCHAR(255) NOT NULL,
                               Model VARCHAR(50) NOT NULL,
                               Instructions CLOB, -- CLOB is a character large object in Oracle SQL
                               NumberOfUnits NUMBER NOT NULL CHECK ( NumberOfUnits >= 0 )
);

CREATE TABLE CanRepairEquipment (
                                    EmployeeID NUMBER,
                                    EquipmentType NUMBER,
                                    CONSTRAINT canRepairEquipmentPK PRIMARY KEY (EmployeeID, EquipmentType),
                                    CONSTRAINT empIDCanRepair_fk FOREIGN KEY (EmployeeID) REFERENCES Employee(ID),
                                    CONSTRAINT eqType_fk FOREIGN KEY (EquipmentType) REFERENCES EquipmentType(TypeID)
);

CREATE TABLE Room (
                      Num NUMBER PRIMARY KEY,
                      OccupiedFlag CHAR(1) NOT NULL CHECK ( OccupiedFlag IN ('Y', 'N') )   -- Indicates if the room is occupied
);

CREATE TABLE Equipment (
                           SerialNum VARCHAR(50) PRIMARY KEY,
                           TypeID NUMBER NOT NULL,
                           PurchaseYear NUMBER NOT NULL,
                           LastInspection DATE,
                           RoomNumber NUMBER,
                           CONSTRAINT typeID_fk FOREIGN KEY (TypeID) REFERENCES EquipmentType(TypeID),
                           CONSTRAINT roomNUM_fk FOREIGN KEY (RoomNumber) REFERENCES ROOM(Num)
);

CREATE TABLE RoomService (
                             RoomNum NUMBER,
                             Service VARCHAR(250) NOT NULL, -- description of the service
                             CONSTRAINT roomService_pk PRIMARY KEY (RoomNum, Service),
                             CONSTRAINT roomServiceRoomNUM_fk FOREIGN KEY (RoomNum) REFERENCES Room(Num)
);

CREATE TABLE RoomAccess (
                            RoomNum NUMBER,
                            EmployeeID NUMBER,
                            CONSTRAINT roomAccess_pk PRIMARY KEY (RoomNum, EmployeeID),
                            CONSTRAINT roomAccessRoomNUM_fk FOREIGN KEY (RoomNum) REFERENCES Room(Num),
                            CONSTRAINT roomAccessEmpID_fk FOREIGN KEY (EmployeeID) REFERENCES Employee(ID)
);

CREATE TABLE Patient (
                         PatientSSN CHAR(11) PRIMARY KEY,
                         PatientFName VARCHAR(50) NOT NULL,
                         PatientLName VARCHAR(50) NOT NULL,
                         PatientAddress VARCHAR(255) NOT NULL,
                         PatientTelNum VARCHAR(20)
);

CREATE TABLE Admission (
                           AdmissionNum NUMBER PRIMARY KEY,
                           AdmissionDate DATE NOT NULL,
                           LeaveDate DATE,
                           TotalPayment NUMBER(10,2) NOT NULL CHECK ( TotalPayment >= 0 ),
                           InsurancePayment NUMBER(10,2) NOT NULL CHECK ( InsurancePayment >= 0 ),
                           PatientSSN CHAR(11) NOT NULL,
                           FutureVisitDate DATE,
                           CONSTRAINT admittedPatientSSN_fk FOREIGN KEY (PatientSSN) REFERENCES Patient(PatientSSN)
);

CREATE TABLE Examine (
                         DoctorID NUMBER,
                         AdmissionNUM NUMBER,
                         ExamComment CLOB NOT NULL, -- assume each examination must have some comment related to it
                         CONSTRAINT examination_pk PRIMARY KEY (DoctorID, AdmissionNUM),
                         CONSTRAINT examiningDoctorID_fk FOREIGN KEY (DoctorID) REFERENCES Doctor(EmployeeID),
                         CONSTRAINT examinationAdmissionNum_fk FOREIGN KEY (AdmissionNUM) REFERENCES Admission(AdmissionNum)
);

CREATE TABLE StayIn (
                        AdmissionNum NUMBER,
                        RoomNum NUMBER,
                        StartDate DATE NOT NULL,
                        EndDate DATE NOT NULL, -- assume since we are in a hospital, knowing duration of stay (start and end) is crucial
                        CONSTRAINT stayIn_pk PRIMARY KEY (AdmissionNum, RoomNum, StartDate),

                        CONSTRAINT stayInRoomAdmissionNum_fk FOREIGN KEY (AdmissionNum) REFERENCES Admission(AdmissionNum),
                        CONSTRAINT stayInRoomNum_fk FOREIGN KEY (RoomNum) REFERENCES Room(Num) -- not entirely sure.---------------------------
);
-- Employee, Doctor, EquipmentTechnician, EquipmentType, CanRepairEquipment, Room, Equipment, RoomService
-- RoomAccess, Patient, Admission, Examine, StayIn

-- Adding 10 patients
INSERT INTO PATIENT (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('124-12-4545', 'John', 'smith', '3-pname', '1234567890');
INSERT INTO PATIENT (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('123-45-6789', 'John', 'Doe', '123 Elm St', '555-1234');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('234-56-7890', 'Jane', 'Smith', '456 Oak St', '555-2345');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('345-67-8901', 'Emily', 'Brown', '789 Pine St', '555-3456');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('456-78-9012', 'Michael', 'Johnson', '101 Maple St', '555-4567');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('567-89-0123', 'David', 'Williams', '202 Cedar St', '555-5678');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('678-90-1234', 'Sarah', 'Jones', '303 Birch St', '555-6789');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('789-01-2345', 'Chris', 'Miller', '404 Spruce St', '555-7890');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('890-12-3456', 'Anna', 'Davis', '505 Redwood St', '555-8901');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('901-23-4567', 'James', 'Garcia', '606 Walnut St', '555-9012');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('012-34-5678', 'Karen', 'Martinez', '707 Ash St', '555-0123');
INSERT INTO "PATIENT" (PATIENTSSN, PATIENTFNAME, PATIENTLNAME, PATIENTADDRESS, PATIENTTELNUM) VALUES
    ('111-22-3333', 'John', 'Cena', '123 Sandy Cheeks St', '554-5123');

SELECT* FROM PATIENT;

---10 Rooms, at least 3 of these rooms have 2 or more services
-- Rooms
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (101, 'N');

INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (102, 'Y');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (103, 'N');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (104, 'N');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (105, 'Y');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (106, 'Y');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (107, 'N');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (108, 'N');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (109, 'Y');
INSERT INTO ROOM (NUM, OCCUPIEDFLAG) VALUES (110, 'Y');

SELECT * FROM ROOM;
-- Room services
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES (101, 'Cleaning');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(101, 'Food Service');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(102, 'Operating Room');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(103, 'Operating Room');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(104, 'Laundry');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(104, 'Cleaning');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(105, 'Cleaning');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(106, 'Food Service');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(107, 'Laundry');
INSERT INTO ROOMSERVICE(ROOMNUM, SERVICE) VALUES(107, 'Cleaning');

SELECT * FROM ROOMSERVICE;

-- 3 Equipment Types
INSERT INTO EQUIPMENTTYPE(TYPEID, DESCRIPTION, MODEL, INSTRUCTIONS, NUMBEROFUNITS) VALUES
    (1, 'X-Ray Machine', 'Model X100', 'Follow safety protocols', 3);
INSERT INTO EQUIPMENTTYPE(TYPEID, DESCRIPTION, MODEL, INSTRUCTIONS, NUMBEROFUNITS) VALUES
    (2, 'MRI Scanner', 'Model MRI200', 'Ensure patient is still', 3);
INSERT INTO EQUIPMENTTYPE(TYPEID, DESCRIPTION, MODEL, INSTRUCTIONS, NUMBEROFUNITS) VALUES
    (3, 'Ventilator', 'Model V300', 'Use for respiratory support', 3);

-- SELECT * FROM EQUIPMENTTYPE;

-- 9 Equipment Units with 3 of each type
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X100-001', 1, 2019, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 101);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X100-002', 1, 2020, TO_DATE('2023-02-20', 'YYYY-MM-DD'), 102);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X100-003', 1, 2023, TO_DATE('2022-02-12', 'YYYY-MM-DD'), 102);

INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X200-001', 2, 2021, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 109);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X200-002', 2, 2019, TO_DATE('2023-06-18', 'YYYY-MM-DD'), 105);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X200-003', 2, 2020, TO_DATE('2023-02-13', 'YYYY-MM-DD'), 103);

INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X300-001', 3, 2017, TO_DATE('2023-01-30', 'YYYY-MM-DD'), 108);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X300-002', 3, 2021, TO_DATE('2023-07-19', 'YYYY-MM-DD'), 107);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X300-003', 3, 2018, TO_DATE('2023-04-27', 'YYYY-MM-DD'), 110);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('A01-02X', 3, 2020, TO_DATE('2021-04-27', 'YYYY-MM-DD'), 110);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X300-012', 3, 2010, TO_DATE('2023-04-27', 'YYYY-MM-DD'), 110);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('X300-01456', 3, 2010, TO_DATE('2023-04-27', 'YYYY-MM-DD'), 110);
INSERT INTO EQUIPMENT(SERIALNUM, TYPEID, PURCHASEYEAR, LASTINSPECTION, ROOMNUMBER) VALUES
    ('A01-013', 3, 2011, TO_DATE('2021-04-27', 'YYYY-MM-DD'), 110);


-- At least 5 patients have 2 or more admissions (visits)
-- Patient 1: 3 admissions
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-01-10', 'YYYY-MM-DD'), 5000, 3000, '123-45-6789', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (2, TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-02-20', 'YYYY-MM-DD'), 3000, 2000, '123-45-6789', NULL);
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (3, TO_DATE('2024-03-05', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'), 4000, 2500, '123-45-6789', TO_DATE('2024-04-20', 'YYYY-MM-DD'));

-- Patient 2: 2 admissions
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (4, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'), 10000, 2500, '234-56-7890', NULL);
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (5, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-07', 'YYYY-MM-DD'), 12500, 3200, '234-56-7890', NULL);

-- Patient 3: 2 admissions
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (6, TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2025-04-18', 'YYYY-MM-DD'), 6000, 3500, '345-67-8901', TO_DATE('2024-05-01', 'YYYY-MM-DD'));
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (7, TO_DATE('2024-05-10', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), 3000, 2000, '345-67-8901', NULL);

-- Patient 4: 2 admissions
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (8, TO_DATE('2024-05-05', 'YYYY-MM-DD'), TO_DATE('2024-05-10', 'YYYY-MM-DD'), 7000, 4000, '456-78-9012', NULL);
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (9, TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), 10000, 7000, '456-78-9012', TO_DATE('2024-07-01', 'YYYY-MM-DD'));

-- Patient 5: 2 admissions
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (10, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-10', 'YYYY-MM-DD'), 9000, 6000, '567-89-0123', NULL);
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (11, TO_DATE('2024-06-20', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), 4500, 3000, '567-89-0123', TO_DATE('2024-07-15', 'YYYY-MM-DD'));
-- PATIENT 6:

INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (12, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-10', 'YYYY-MM-DD'), 9000, 6000, '111-22-3333', NULL);
INSERT INTO ADMISSION(ADMISSIONNUM, ADMISSIONDATE, LEAVEDATE, TOTALPAYMENT, INSURANCEPAYMENT, PATIENTSSN, FUTUREVISITDATE) VALUES
    (13, TO_DATE('2024-06-20', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), 4500, 3000, '111-22-3333', TO_DATE('2024-07-15', 'YYYY-MM-DD'));
-----------------------------------------------
-- EMPLOYEES----- 21 of them

-- 2 General Managers
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (20, 'James', 'Wright', 120000, 'General Manager', 'G101', 2, NULL, '808 Magnolia St', 'City T');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (21, 'Amelia', 'Scott', 125000, 'General Manager', 'G102', 2, NULL, '909 Aspen St', 'City U');

-- 4 division managers
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (10, 'Kamala', 'Harris', 420000, 'Division Manager', 'X101', 1, 20, '404 Bitch St', 'City Z');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (16, 'Ava', 'Harris', 80000, 'Division Manager', 'D101', 1, 20, '404 Beech St', 'City P');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (17, 'William', 'Clark', 85000, 'Division Manager', 'D102', 1, 20, '505 Sycamore St', 'City Q');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (18, 'Sophia', 'Young', 82000, 'Division Manager', 'D103', 1, 20, '606 Alder St', 'City R');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (19, 'Ethan', 'King', 83000, 'Division Manager', 'D104', 1, 21, '707 Sequoia St', 'City S');


-- 5 doctors
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (1, 'John', 'Doe', 100000, 'Doctor', 'A101', 0, 10, '123 Elm St', 'City A');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (2, 'Jane', 'Smith', 105000, 'Doctor', 'A102', 0, 10, '456 Oak St', 'City B');



INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (3, 'Emily', 'Jones', 110000, 'Doctor', 'A103', 0, 17, '789 Pine St', 'City C');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (4, 'Michael', 'Brown', 95000, 'Doctor', 'A104', 0, 18, '101 Maple St', 'City D');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (5, 'Emma', 'Johnson', 115000, 'Doctor', 'A105', 0, 19, '202 Birch St', 'City E');


-- 5 Technicans
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (6, 'Tom', 'Wilson', 70000, 'Technician', 'B101', 0, 16, '303 Cedar St', 'City F');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (7, 'Anna', 'Taylor', 72000, 'Technician', 'B102', 0, 17, '404 Walnut St', 'City G');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (8, 'Lucas', 'Anderson', 68000, 'Technician', 'B103', 0, 17, '505 Spruce St', 'City H');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (9, 'Sophia', 'Lee', 73000, 'Technician', 'B104', 0, 18, '606 Fir St', 'City I');

INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (40, 'David', 'Martin', 71000, 'Technician', 'B105', 0, 19, '707 Ash St', 'City J');


-- 5 Cleaners
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (11, 'Liam', 'Thomas', 40000, 'Cleaner', 'C101', 0, 16, '808 Chestnut St', 'City K');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (12, 'Olivia', 'Garcia', 42000, 'Cleaner', 'C102', 0, 17, '909 Willow St', 'City L');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (13, 'Noah', 'Moore', 41000, 'Cleaner', 'C103', 0, 17, '101 Poplar St', 'City M');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (14, 'Isabella', 'Jackson', 43000, 'Cleaner', 'C104', 0, 18, '202 Redwood St', 'City N');
INSERT INTO EMPLOYEE(ID, FNAME, LNAME, SALARY, JOBTITLE, OFFICENUM, EMPRANK, SUPERVISORID, ADDRESSSTREET, ADDRESSCITY) VALUES
    (15, 'Mason', 'White', 42000, 'Cleaner', 'C105', 0, 19, '303 Cypress St', 'City O');


-- DOCTOR
INSERT INTO DOCTOR (EMPLOYEEID, GENDER, SPECIALTY, GRADUATEDFROM) VALUES
    (1, 'M', 'General Surgery', 'WPI'); /*WPI has no medical school...*/
INSERT INTO DOCTOR (EMPLOYEEID, GENDER, SPECIALTY, GRADUATEDFROM) VALUES
    (2, 'M', 'Neurology', 'WPI');
INSERT INTO DOCTOR (EMPLOYEEID, GENDER, SPECIALTY, GRADUATEDFROM) VALUES
    (3, 'F', 'Pediatrics', 'Harvard Medical School');
INSERT INTO DOCTOR (EMPLOYEEID, GENDER, SPECIALTY, GRADUATEDFROM) VALUES
    (4, 'F', 'General Surgery', 'Tufts Medical School');
INSERT INTO DOCTOR (EMPLOYEEID, GENDER, SPECIALTY, GRADUATEDFROM) VALUES
    (5, 'M', 'General Surgery', 'John Hopkins Medical School');

-- EquipmentTechnician
INSERT INTO EQUIPMENTTECHNICIAN (EMPLOYEEID) VALUES (6);
INSERT INTO EQUIPMENTTECHNICIAN (EMPLOYEEID) VALUES (7);
INSERT INTO EQUIPMENTTECHNICIAN (EMPLOYEEID) VALUES (8);
INSERT INTO EQUIPMENTTECHNICIAN (EMPLOYEEID) VALUES (9);
INSERT INTO EQUIPMENTTECHNICIAN (EMPLOYEEID) VALUES (10);

-- canRepairEquipment
INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (6, 3);
INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (6, 2);

INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (7, 1);
INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (7, 2);

INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (8, 1);
INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (8, 2);

INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (9, 1);
INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (9, 2);

INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (10, 1);
INSERT INTO CANREPAIREQUIPMENT (EMPLOYEEID, EQUIPMENTTYPE) VALUES (10, 2);
-- RoomAccess : 101 - 110

-- Doctors' access to Operating Rooms
INSERT INTO RoomAccess (ROOMNUM, EMPLOYEEID) VALUES (102, 1);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 2);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 3);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 4);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 5);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 1);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 2);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 3);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 4);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 5);

-- Cleaners' access to rooms 102 and 103 (Operating Rooms)
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 11);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 12);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 13);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 14);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (102, 15);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 11);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 12);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 13);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 14);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (103, 15);

-- Laundry and Cleaning staff access to rooms 101, 104, 105, 107
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 11);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 12);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 13);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 14);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 15);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (104, 11);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (104, 12);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (104, 13);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (104, 14);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (104, 15);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (105, 11);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (105, 12);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (105, 13);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (105, 14);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (105, 15);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (107, 11);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (107, 12);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (107, 13);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (107, 14);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (107, 15);

-- Food service staff access to room 101
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 1);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 2);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 3);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 4);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 5);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 6);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 7);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 8);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 9);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 10);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 16);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 17);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 18);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 19);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 20);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (101, 21);

INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 1);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 2);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 3);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 4);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 5);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 6);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 7);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 8);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 9);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 10);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 16);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 17);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 18);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 19);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 20);
INSERT INTO ROOMACCESS (ROOMNUM, EMPLOYEEID) VALUES (106, 21);

-- EXAMINE
INSERT INTO EXAMINE (DOCTORID, ADMISSIONNUM, EXAMCOMMENT) VALUES
    (1, 1, 'Nice Cock');
INSERT INTO EXAMINE (DOCTORID, ADMISSIONNUM, EXAMCOMMENT) VALUES
    (2, 2, 'Overweight');
INSERT INTO EXAMINE (DOCTORID, ADMISSIONNUM, EXAMCOMMENT) VALUES
    (3, 3, 'Eat more dairy');
INSERT INTO EXAMINE (DOCTORID, ADMISSIONNUM, EXAMCOMMENT) VALUES
    (4, 4, 'Take frequent breaks');
INSERT INTO EXAMINE (DOCTORID, ADMISSIONNUM, EXAMCOMMENT) VALUES
    (5, 5, 'Socialize more');

INSERT INTO EXAMINE (DOCTORID, ADMISSIONNUM, EXAMCOMMENT) VALUES
    (5, 12, 'Eat less junk food');
INSERT INTO EXAMINE (DOCTORID, ADMISSIONNUM, EXAMCOMMENT) VALUES
    (5, 13, 'lose weight');


-- STAYIN
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (1, 101, TO_DATE('2024-08-25', 'YYYY-MM-DD'), TO_DATE('2024-09-01', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (2, 102, TO_DATE('2024-08-28', 'YYYY-MM-DD'), TO_DATE('2024-09-05', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (3, 103, TO_DATE('2024-09-01', 'YYYY-MM-DD'), TO_DATE('2024-09-10', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (4, 104, TO_DATE('2024-09-02', 'YYYY-MM-DD'), TO_DATE('2024-09-09', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (5, 105, TO_DATE('2024-09-03', 'YYYY-MM-DD'), TO_DATE('2024-09-10', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (6, 106, TO_DATE('2024-09-05', 'YYYY-MM-DD'), TO_DATE('2024-09-12', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (7, 107, TO_DATE('2024-09-07', 'YYYY-MM-DD'), TO_DATE('2024-09-14', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (8, 108, TO_DATE('2024-09-08', 'YYYY-MM-DD'), TO_DATE('2024-09-15', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (9, 109, TO_DATE('2024-09-09', 'YYYY-MM-DD'), TO_DATE('2024-09-16', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (10, 110, TO_DATE('2024-09-10', 'YYYY-MM-DD'), TO_DATE('2024-09-17', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (11, 101, TO_DATE('2024-09-11', 'YYYY-MM-DD'), TO_DATE('2024-09-18', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (12, 104, TO_DATE('2024-09-11', 'YYYY-MM-DD'), TO_DATE('2024-09-18', 'YYYY-MM-DD'));
INSERT INTO STAYIN (ADMISSIONNUM, ROOMNUM, STARTDATE, ENDDATE) VALUES
    (13, 105, TO_DATE('2024-09-11', 'YYYY-MM-DD'), TO_DATE('2024-09-18', 'YYYY-MM-DD'));
------- Q1 ---------
-- Report all tuples for doctors graduated from WPI
SELECT *
FROM DOCTOR
WHERE DOCTOR.GRADUATEDFROM = 'WPI';

------- Q2 ---------
-- For a given division manager (say, ID = 10), report all regular employees that are
-- supervised by this manager. Display the employees ID, names, and salary.
SELECT E.ID, E.FNAME, E.LNAME, e.SALARY
FROM EMPLOYEE E
WHERE E.SUPERVISORID = 10 AND E.EMPRANK = 0;

------- Q3 ---------
-- For each patient, report the sum of amounts paid by the insurance company for that
-- patient, i.e., report the patients SSN, and the sum of insurance payments over all visits
SELECT P.PATIENTSSN, sum(INSURANCEPAYMENT) AS TotalInsurancePayout
FROM PATIENT P, ADMISSION A
WHERE P.PATIENTSSN = A.PATIENTSSN
GROUP BY P.PATIENTSSN;

------- Q4 ---------
--Report the number of visits done for each patient, i.e., for each patient, report the
--patient SSN, first and last names, and the count of visits done by this patient.

SELECT P.PATIENTSSN, P.PATIENTFNAME, P.PATIENTTELNUM, count(ADMISSIONNUM)
FROM Patient P, Admission A
Where P.PATIENTSSN = A.PatientSSN
GROUP BY P.PATIENTSSN, P.PATIENTFNAME, P.PATIENTTELNUM;

------- Q5 ---------
--Report the room number that has an equipment unit with serial number ‘A01-02X’.
SELECT E.ROOMNUMBER
FROM EQUIPMENT E
WHERE E.SERIALNUM = 'A01-02X';


------- Q6 ---------
-- Report the employee who has access to the largest number of rooms.
-- We need the employee ID, and the number of rooms they can access.
-- Note: If there are several employees with the same maximum number, then report all of these employees.
SELECT RoomAccess.EmployeeID, COUNT(RoomAccess.RoomNum) AS RoomCount
FROM RoomAccess
GROUP BY RoomAccess.EmployeeID
HAVING COUNT(RoomAccess.RoomNum) = (
    SELECT MAX(RoomCount)
    FROM (SELECT COUNT(RoomNum) AS RoomCount
          FROM RoomAccess
          GROUP BY EmployeeID)
);

------- Q7 ---------
-- Report the number of regular employees, division managers, and general managers in
-- the hospital.
SELECT
    CASE  -- For Type Column
        WHEN empRank = 0 THEN 'Regular Employees'
        WHEN empRank = 1 THEN 'Division Managers'
        WHEN empRank = 2 THEN 'General Managers'
        END AS Type,

    COUNT(*) AS Count -- For Count Column
FROM Employee
GROUP BY empRank
ORDER BY empRank;

------- Q8 ---------
--For patients who have a scheduled future visit (which is part of their most recent visit),
--report that patient's SSN, first name, and last name, and the visit date.
--Do not report patients who do not have a scheduled visit.
SELECT P.PATIENTSSN, P.PATIENTFNAME, P.PATIENTLNAME,A.ADMISSIONDATE
FROM Admission A, Patient P
WHERE P.PatientSSN = A.PatientSSN
  AND A.FutureVisitDate IS NOT NULL;

------- Q9 ---------
--Report all equipment types that have less than two technicians that can maintain them.
SELECT EQUIPMENTTYPE
FROM CANREPAIREQUIPMENT
GROUP BY EQUIPMENTTYPE
HAVING Count(EMPLOYEEID) < 2;

------- Q10 ---------
SELECT FUTUREVISITDATE
FROM Admission
WHERE PatientSSN = '111-22-3333'
ORDER BY AdmissionDate DESC
    FETCH FIRST 1 ROWS ONLY;
------- Q11 ---------
SELECT E.DOCTORID
FROM EXAMINE E, ADMISSION A
WHERE A.PATIENTSSN = '111-22-3333'
GROUP BY A.PATIENTSSN, E.DOCTORID
HAVING count(*) > 2;

-- SHOULD BE ID = 5
------- Q12 ---------
SELECT TYPEID
FROM EQUIPMENT
WHERE purchaseyear = 2010
INTERSECT
SELECT TYPEID
FROM EQUIPMENT
WHERE purchaseyear = 2011;
