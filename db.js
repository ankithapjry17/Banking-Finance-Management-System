// db.js
const sql = require('mssql');

const config = {
  user: 'sa',
  password: 'nnm23is032',
  server: 'localhost',
  database: 'BankSystem2',
  options: {
    encrypt: false,
    trustServerCertificate: true
  }
};

const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log('Connected to SQL Server');
    return pool;
  })
  .catch(err => console.log('DB Connection Failed:', err));

module.exports = {
  sql,
  poolPromise
};
