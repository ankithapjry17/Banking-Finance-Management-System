CREATE DATABASE BankSystem2;
GO
USE BankSystem2;
GO

-- BANK
CREATE TABLE BANK (
    Bank_Id INT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(100)
);

-- BRANCH
CREATE TABLE BRANCH (
    Branch_Id INT PRIMARY KEY,
    Bank_Id INT FOREIGN KEY REFERENCES BANK(Bank_Id),
    Branch_Name VARCHAR(100),
    Location VARCHAR(100)
);

-- CUSTOMER
CREATE TABLE CUSTOMER (
    Customer_Id INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Date_of_Birth DATE
);

-- ACCOUNT
CREATE TABLE ACCOUNT (
    Acc_No INT PRIMARY KEY,
    Customer_Id INT FOREIGN KEY REFERENCES CUSTOMER(Customer_Id),
    Branch_Id INT FOREIGN KEY REFERENCES BRANCH(Branch_Id),
    Acc_type VARCHAR(50),
    Balance DECIMAL(18, 2)
);

-- ACCOUNT TRANSACTION
CREATE TABLE ACCOUNT_TRANSACTION (
    Trans_Id INT PRIMARY KEY,
    Acc_No INT FOREIGN KEY REFERENCES ACCOUNT(Acc_No),
    Trans_Date DATE,
    Trans_type VARCHAR(50),
    Amount DECIMAL(18, 2)
);

-- LOAN
CREATE TABLE LOAN (
    Loan_Id INT PRIMARY KEY,
    Customer_Id INT FOREIGN KEY REFERENCES CUSTOMER(Customer_Id),
    Branch_Id INT FOREIGN KEY REFERENCES BRANCH(Branch_Id),
    Loan_type VARCHAR(50),
    Loan_Amount DECIMAL(18, 2),
    Interest_Rate FLOAT,
    Loan_term INT
);

-- EMI
CREATE TABLE EMI (
    EMI_Id INT PRIMARY KEY,
    Loan_Id INT FOREIGN KEY REFERENCES LOAN(Loan_Id),
    EMI_Amount DECIMAL(18, 2),
    EMI_Due_Date DATE,
    Payment_Status VARCHAR(50)
);

GO
-- First, drop trigger if it exists
IF OBJECT_ID('trg_CheckWithdrawalLimit', 'TR') IS NOT NULL
    DROP TRIGGER trg_CheckWithdrawalLimit;
GO

CREATE TRIGGER trg_CheckWithdrawalLimit
ON ACCOUNT_TRANSACTION
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if any withdrawal exceeds the balance
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN ACCOUNT a ON i.Acc_No = a.Acc_No
        WHERE i.Trans_type = 'Withdraw' AND i.Amount > a.Balance
    )
    BEGIN
        RAISERROR ('Transaction failed: Insufficient funds.', 16, 1);
        RETURN;
    END

    -- If valid, perform the insert
    INSERT INTO ACCOUNT_TRANSACTION (Trans_Id, Acc_No, Trans_Date, Trans_type, Amount)
    SELECT Trans_Id, Acc_No, Trans_Date, Trans_type, Amount
    FROM INSERTED;

    -- Update the account balance
    UPDATE a
    SET a.Balance = 
        CASE 
            WHEN i.Trans_type = 'Deposit' THEN a.Balance + i.Amount
            WHEN i.Trans_type = 'Withdraw' THEN a.Balance - i.Amount
            ELSE a.Balance
        END
    FROM ACCOUNT a
    JOIN INSERTED i ON a.Acc_No = i.Acc_No;
END
GO

CREATE PROCEDURE AddCustomer
    @Customer_Id INT,
    @Name VARCHAR(100),
    @Address VARCHAR(255),
    @Phone VARCHAR(15),
    @Email VARCHAR(100),
    @Date_of_Birth DATE
AS
BEGIN
    INSERT INTO CUSTOMER VALUES (@Customer_Id, @Name, @Address, @Phone, @Email, @Date_of_Birth);
END
GO

CREATE PROCEDURE OpenAccount
    @Acc_No INT,
    @Customer_Id INT,
    @Branch_Id INT,
    @Acc_type VARCHAR(50),
    @Balance DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO ACCOUNT VALUES (@Acc_No, @Customer_Id, @Branch_Id, @Acc_type, @Balance);
END
GO

CREATE PROCEDURE MakeTransaction
    @Trans_Id INT,
    @Acc_No INT,
    @Trans_Date DATE,
    @Trans_type VARCHAR(50),
    @Amount DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO ACCOUNT_TRANSACTION VALUES (@Trans_Id, @Acc_No, @Trans_Date, @Trans_type, @Amount);
END
GO

CREATE PROCEDURE AddLoan
    @Loan_Id INT,
    @Customer_Id INT,
    @Branch_Id INT,
    @Loan_type VARCHAR(50),
    @Loan_Amount DECIMAL(18,2),
    @Interest_Rate FLOAT,
    @Loan_term INT
AS
BEGIN
    INSERT INTO LOAN VALUES (@Loan_Id, @Customer_Id, @Branch_Id, @Loan_type, @Loan_Amount, @Interest_Rate, @Loan_term);
END
GO

CREATE PROCEDURE AddEMI
    @EMI_Id INT,
    @Loan_Id INT,
    @EMI_Amount DECIMAL(18, 2),
    @EMI_Due_Date DATE,
    @Payment_Status VARCHAR(50)
AS
BEGIN
    INSERT INTO EMI VALUES (@EMI_Id, @Loan_Id, @EMI_Amount, @EMI_Due_Date, @Payment_Status);
END
GO

CREATE PROCEDURE GetTransactionHistory
    @Acc_No INT
AS
BEGIN
    SELECT * FROM ACCOUNT_TRANSACTION
    WHERE Acc_No = @Acc_No
    ORDER BY Trans_Date DESC;
END
GO

CREATE PROCEDURE GetAccountBalance
    @Acc_No INT
AS
BEGIN
    SELECT Balance FROM ACCOUNT WHERE Acc_No = @Acc_No;
END
GO

CREATE PROCEDURE GetEMIStatus
    @Loan_Id INT
AS
BEGIN
    SELECT * FROM EMI WHERE Loan_Id = @Loan_Id;
END
GO

CREATE PROCEDURE AddBank
    @Bank_Id INT,
    @Name VARCHAR(100),
    @Location VARCHAR(100)
AS
BEGIN
    INSERT INTO BANK (Bank_Id, Name, Location)
    VALUES (@Bank_Id, @Name, @Location);
END
GO


select * from BANK;
select*from BRANCH;
select*from customer;
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_CATALOG = 'BankSystem2' -- Your database name
ORDER BY 
    TABLE_NAME, ORDINAL_POSITION;


	select * from Bank

	select * from Branch

	select * from CUSTOMER

	select * from ACCOUNT

	select * from ACCOUNT_TRANSACTION

	select * from LOAN

	select * from EMI