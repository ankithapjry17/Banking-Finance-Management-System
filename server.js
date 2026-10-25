const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { sql, poolPromise } = require('./db'); // Keep your working DB module
const path = require('path');

const app = express();
const port = 8081;

// Middleware
app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

// ✅ Serve static files from public
app.use(express.static(path.join(__dirname, 'public')));

// ✅ Serve index.html when user visits root
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});


(async () => {
  try {
    const pool = await poolPromise;
    app.locals.db = pool;
    console.log("✅ Database connected.");
  } catch (err) {
    console.error("❌ Database connection failed:", err);
  }
})();

// --- BACKEND ROUTES ---
// Use .input(...).execute(...) pattern as you're doing
// BANK
app.post('/api/bank', async (req, res) => {
  const { BankID, BankName, Location } = req.body;
  const query = `INSERT INTO BANK (Bank_Id, Name, Location) VALUES ('${BankID}', '${BankName}', '${Location}')`;
  try {
    await app.locals.db.request().query(query);
    res.json({ message: 'Bank added successfully.' });
  } catch (err) {
    console.error('[API /bank] Error:', err);
    res.status(500).json({ message: 'Error inserting bank data.' });
  }
});

// BRANCH
app.post('/api/branch', async (req, res) => {
  const { BranchID, BankID, BranchName, Location } = req.body;
  const query = `INSERT INTO BRANCH (Branch_Id, Bank_Id, Branch_Name, Location) VALUES (${BranchID}, ${BankID}, '${BranchName}', '${Location}')`;

  try {
    await app.locals.db.request().query(query);
    res.json({ message: 'Branch added successfully.' });
  } catch (err) {
    console.error('[API /branch] Error:', err);
    res.status(500).json({ message: 'Error inserting branch data.' });
  }
});

// CUSTOMER
app.post('/api/customer', async (req, res) => {
  const { Customer_Id, Name, Address, Phone, Email, DOB } = req.body;

  
  console.log('[POST /customer] Received body:', req.body);
    // Check for undefined values
    if (!Customer_Id || !Name || !Address || !Phone || !Email || !DOB) {
      return res.status(400).json({ message: 'Missing required fields.' });
    }
  const query = `INSERT INTO CUSTOMER (Customer_Id, Name, Address, Phone, Email, Date_of_Birth)
  VALUES (${Customer_Id}, '${Name}', '${Address}', '${Phone}', '${Email}', '${DOB}')`;

  try {
    await app.locals.db.request().query(query);
    res.json({ message: 'Customer added successfully.' });
  } catch (err) {
    console.error('[API /customer] Error:', err);
    res.status(500).json({ message: 'Error inserting customer data.' });
  }
});

// ACCOUNT
app.post('/api/account', async (req, res) => {
  const { Acc_No, Customer_Id, BranchID, Acc_type, Balance } = req.body;
  const query = `INSERT INTO ACCOUNT (Acc_No, Customer_Id, Branch_Id, Acc_type, Balance) VALUES (${Acc_No}, ${Customer_Id}, ${BranchID}, '${Acc_type}', ${Balance})`;
  try {
    await app.locals.db.request().query(query);
    res.json({ message: 'Account created successfully.' });
  } catch (err) {
    console.error('[API /account] Error:', err);
    res.status(500).json({ message: 'Error inserting account data.' });
  }
});

// TRANSACTION
app.post('/api/transaction', async (req, res) => {
  const { Trans_Id, Acc_No, Trans_Date, Trans_type, Amount } = req.body;

  const query = `
    INSERT INTO ACCOUNT_TRANSACTION (Trans_Id, Acc_No, Trans_Date, Trans_type, Amount)
    VALUES (${Trans_Id}, ${Acc_No}, '${Trans_Date}', '${Trans_type}', ${Amount})
  `;

  try {
    await app.locals.db.request().query(query);
    res.json({ message: 'Transaction recorded successfully.' });
  } catch (err) {
    console.error('[API /transaction] Error:', err);
    res.status(500).json({ message: 'Error inserting transaction data.' });
  }
});


// LOAN
app.post('/api/loan', async (req, res) => {
  const { Loan_Id, Customer_Id, BranchID, Loan_type, Loan_Amount, Interest_Rate, Loan_term } = req.body;

  const query = `
    INSERT INTO LOAN (Loan_Id, Customer_Id, Branch_Id, Loan_type, Loan_Amount, Interest_Rate, Loan_term)
    VALUES (${Loan_Id}, ${Customer_Id}, ${BranchID}, '${Loan_type}', ${Loan_Amount}, ${Interest_Rate}, ${Loan_term})
  `;

  try {
    await app.locals.db.request().query(query);
    res.json({ message: 'Loan added successfully.' });
  } catch (err) {
    console.error('[API /loan] Error:', err);
    res.status(500).json({ message: 'Error inserting loan data.' });
  }
});

// EMI
app.post('/api/emi', async (req, res) => {
  const { EMI_Id, Loan_Id, EMI_Amount, EMI_Due_Date, Payment_Status } = req.body;

  const query = `
    INSERT INTO EMI (EMI_Id, Loan_Id, EMI_Amount, EMI_Due_Date, Payment_Status)
    VALUES (${EMI_Id}, ${Loan_Id}, ${EMI_Amount}, '${EMI_Due_Date}', '${Payment_Status}')
  `;

  try {
    await app.locals.db.request().query(query);
    res.json({ message: 'EMI recorded successfully.' });
  } catch (err) {
    console.error('[API /emi] Error:', err);
    res.status(500).json({ message: 'Error inserting EMI data.' });
  }
});


// ✅ Start server
app.listen(port, () => {
  console.log(`✅ SmartBank server running at http://localhost:${port}`);
});
