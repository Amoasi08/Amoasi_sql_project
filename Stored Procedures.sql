--STEP 1 : Write a Query
--For US Customers Find the Total Number of Customers and the Average Score

--STEP 2: Create your Stored Procedure
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
    SELECT
        COUNT(*) TotalCustomers,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA'
END

--Step 3: Execute the Stored Procedure
EXEC GetCustomerSummary

-- For German Customers Find the Total Number of Customers and the Average Score
/*We are just repeating ourselves so we can create a parameter for this*/

-- We can Create a Parameter
--PARAMETER using @
CREATE PROCEDURE GetCustomerSummary @Country NVARCHAR(50) AS
BEGIN
    SELECT
        COUNT(*) TotalCustomers,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;
END

--Step 3: Execute the Stored Procedure
EXEC GetCustomerSummary @Country = 'Germany'

--Finally: With this all we have to do is to input our parameter, then EXECUTE the stored procedure.
--NOTE: We can create a Default PARAMETER is work with. #Example 
--ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
-- and use 'EXEC GetCustomerSummary'
--But if you want to use the parameter then go with 
-- "EXEC GetCustomerSummary @Country = 'Germany'"



-- MULTI QUERY IN THE STORED PROCEDURE
-- I COPIED FROM LINE 4 TO LINE 26 and Add a new QUERY(TOTAL Number of Orders and Total Sales)

  CREATE PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    SELECT
        COUNT(*) TotalCustomers,
        AVG(Score) AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;
  
  --Find the total Number of Orders and Total Sales
    SELECT 
        COUNT(OrderID) TotalOrders,
        SUM(Sales) TotalSales
    FROM Sales.Orders o
    JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END

--Step 3: Execute the Stored Procedure
EXEC GetCustomerSummary @Country 
EXEC GetCustomerSummary @Country = 'Germany'
 


--VARIABLES 
--Let copy line 46 to line 66
--We then add our variables to it

--DECLARE is used to start a variable

CREATE PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;
  
    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR)

--Find the total Number of Orders and Total Sales
    SELECT 
        COUNT(OrderID) TotalOrders,
        SUM(Sales) TotalSales
    FROM Sales.Orders o
    JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END

--Step 3: Execute the Stored Procedure
EXEC GetCustomerSummary @Country 
EXEC GetCustomerSummary @Country = 'Germany'


--CONTROL THE FLOW
--IF ELSE statement

-- Prepare & Cleanup Data
IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
BEGIN
    PRINT ('Updating the Null')
    UPDATE Sales.Customers
    SET Score = 0
    WHERE Score IS NULL AND Country = @Country
END

ELSE
BEGIN   
    PRINT ('NO Null Score found')
END


-- Now let's fix line 108 - line 120 into our Stored Procedure
-- Let's go ahead and do that 

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN

DECLARE @TotalCustomers INT, @AvgScore FLOAT;
IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
BEGIN
    PRINT ('Updating the Null')
    UPDATE Sales.Customers
    SET Score = 0
    WHERE Score IS NULL AND Country = @Country
END

ELSE
BEGIN   
    PRINT ('NO Null Score found')
END

    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

PRINT 'Total Customers from ' + @Country + ':' + CAST(@TotalCustomers AS NVARCHAR);
PRINT 'Average Score from ' + @Country + ':' + CAST(@AvgScore AS NVARCHAR)

--Find the total Number of Orders and Total Sales
    SELECT 
        COUNT(OrderID) TotalOrders,
        SUM(Sales) TotalSales
    FROM Sales.Orders o
    JOIN Sales.Customers c
    ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END

--Step 3: Execute the Stored Procedure
EXEC GetCustomerSummary @Country 
EXEC GetCustomerSummary @Country = 'Germany'



--ERROR HANDLING
--TRY CATCH
-- Syntax
BEGIN TRY
END TRY

BEGIN CATCH 
END CATCH
