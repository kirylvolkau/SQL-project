# T-SQL project
## General
The task was to :
1. Design a database for given streaming company wit ERD.
2. Write DDL queries to create it and DML to seed data + query to update value of servers. 
3. Write queries for extraction different kinds of data.
4. Offer some indexing structure
5. Write stored procedure for processing records.
6. Propose simple data warehouse model.
## Task 1 : Design, creation, seeding
<image src="ERD.png" height=600/>

Additional notes :
* Channels can be without categories.
*  We need to log all changes of `Viewing Requests` table (in `RequestStatusHistory` table).
*  Viewer is defined by Country, Email and Username (combination shouldbe unique).
*  Servers have Desctruction Date - nullable, filled when server is destroyed.
*  Servers should have CurrentUsersAmt always less or equal to their capacity.
*  Database is in the 3NF.

Files : 
* [`init.sql`]('init.sql') - file with database creation.
* [`seed.sql`]('seed.sql') - seeding database.
* [`update_servers.sql`]('update_servers.sql') - query to update amount of active users for each server.

## Task 2 : Index structure proposition
Some prerequisite knowledge : 
* Primary key is treated by MS SQL Server as a clustered unqiue index.
* Clustered index describes how data is actually stored.
* Non-clustered index describes how to navigate to the row and is stored separately from the database.
* In order to declare new clustered index we need to delete index, created by SQL server by default (PK).

### Propositions:
1. Servers - clustered, `(CurrentUsersAmt DESC, ExpirationDate ASC)` - task required to firstly fill servers with highest amount of users. Not unique. 
2. Viewers - leave PK as clustered unique index, add non-clustered not unique on `CountryId` - for statistics.
3. ViewingRequests - we address this table a lot by two combinations: `viewer – channel` and `channel-server`. They should be created as UNIQUE non-clustered indexes. PK should be left.
4. All other tables should be left as they are : junction tables already define primary keys as combination of their foreign keys, and small tables as country or statuses doesn’t need anything except for the primary key.

## Task 3 : Queries
Tose queries are kept in folder `Queries` with following name pattern `query[X].sql` where X is a number of a query as they are listed below : 
1.	For each viewer show channels that have never been requested by that viewer.
2. Identify channels for which the average viewing time per viewer exceeds average viewing time per user by 45%.
3. For each country list top 10 customers with largest ratio of total viewing time by total requests.
4. Identify 3 channels with largest share of short views among all completed views (status = 'open') A shot view is view for less than 15 sec.
5. Identify customers who have already viewed every channel for total at least an hour in 2018.

## Task 4 : procedure + basic trigger 
Procedure proceeds requests from old to new ones, if expiration date of channel is earlier than request date then it is rejected. If it finds server (we browse them by decreasing amount of current users and availability) then it increments its current users amount. If not - creates new one. After that it assigns request to the server and logs changes in request status. <br/>
File : [`Procedures/procedure.sql`]('Procedures/procedure.sql').

## Task 5 : Data warehouse model design
Steps : 
1. Denormalize original database to the 2NF.
2. Add `DurationInSeconds` property to viewing request. Calculated with help of `DATEDIFF`.
3. Use `Star` design:

<image src="ERD_warehouse.png" height=400>

## Notes and further corrections : 
1. Query to update servers doesn't update servers who doesn't have active requests waiting(so, amount of current user will not change if it decreases in real life).
2. Query #5 is not finished.
3. In procedure it wiuld be good to remove extra cursor inside and replace it with `TOP(1)` SQL select statement.
4. Place `UPDATE` statements into transactions (so, if anythin goes wrong it is possible to rollback).