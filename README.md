## Veterinary Clinic – SQL Server Database Project
This project presents a database system for a veterinary clinic created in Microsoft SQL Server. The system allows management of pet owners, pets, 
veterinarians, visits, treatments, and prescriptions.


## Project Features
- management of owners and pets,
- veterinary visit management,
- assigning veterinarians to visits,
- storing treatments and treatment costs,
- prescription and medicine management,
- JSON data generation,
- operation logging using triggers,
- stored procedures with error handling,
- transactions ensuring data consistency,
- user-defined functions and views

## Main Procedures
1.FinishVisit
Completes a visit, assigns a veterinarian, and adds a treatment within a single transaction.

2.FinishVisitWithPrescription
Extended procedure that completes a visit and optionally adds a prescription by calling the child procedure AddPrescription.

3.VetStatistics
Generates statistics for a veterinarian based on completed visits and treatments, including total visits, total income, and average treatment cost. 

4.ExportAnimals_ToJson_BySpecies
Exports animal data into JSON format grouped by species using a cursor.


## Triggers

The project contains example triggers:

- preventing deletion of completed visits,
- logging inserted treatments,
- validating business operations.

The SQL script:
- automatically removes the existing database,
- creates a new database,
- creates all tables,
- inserts sample data,
- creates procedures, functions, and triggers.

Thanks to this approach, the project can be executed multiple times without manually cleaning the database.
