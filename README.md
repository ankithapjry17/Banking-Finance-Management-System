# Banking and Finance Management System

A database-driven web application for managing banking operations, including customer records, bank accounts, financial transactions, loans, and EMI payments.

## Overview

The Banking and Finance Management System was developed as part of the Database Management Systems course at NMAM Institute of Technology, Nitte. The project demonstrates relational database design and the integration of a web interface with a backend server and SQL database.

## Key Features

- Bank and branch management
- Customer registration and account management
- Deposit and withdrawal transaction processing
- Loan and EMI record management
- Account balance and transaction history retrieval
- Database-level validation using SQL triggers

## Technology Stack

- **Frontend:** HTML, CSS, JavaScript
- **Backend:** Node.js, Express.js
- **Database:** Microsoft SQL Server
- **Database Concepts:** Relational schema design, stored procedures, triggers, primary keys, and foreign keys

## Database Design

The database consists of seven main tables:

- `BANK` — Bank information
- `BRANCH` — Branch details
- `CUSTOMER` — Customer records
- `ACCOUNT` — Account information and balances
- `ACCOUNT_TRANSACTION` — Financial transaction records
- `LOAN` — Loan details
- `EMI` — EMI payment records

Stored procedures support banking operations and information retrieval. The `trg_CheckWithdrawalLimit` trigger validates withdrawal requests against available account balances and handles balance updates.

## Project Structure

```text
├── public/       # Frontend files
├── docs/         # Project report and SQL documentation
├── db.js         # Database connection
├── server.js     # Backend server
├── final sql.sql # Database schema and SQL logic
├── package.json  # Project dependencies
└── README.md
```

## Getting Started

**Prerequisites:** Node.js and Microsoft SQL Server.

1. Clone the repository:

   ```bash
   git clone https://github.com/YOUR-USERNAME/Banking-Finance-Management-System.git
   cd Banking-Finance-Management-System
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Execute `final sql.sql` in SQL Server Management Studio to create the database and its objects.

4. Configure the database connection in `db.js`.

5. Start the application using the command configured in `package.json`. If no start script is defined and `server.js` is the entry point, run:

   ```bash
   node server.js
   ```

## Team Members

Developed as a team project during the 2024–2025 academic year.

- Aashna Mathias
- Akshatha Kini
- Ankitha
- Bhagya P. Shetty

## Documentation

Refer to the [`docs/`](docs/) directory for the project report and SQL code documentation.

## Future Enhancements

- Role-based authentication and authorization
- Interactive dashboards and financial reports
- Automated EMI reminders
- Enhanced security and transaction auditing
