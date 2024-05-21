const mysql = require('mysql2');

const pool = mysql.createPool({
    host : 'localhost',
    user : 'user123',
    password : 'pass12word45!',
    database : 'bus_data'
});

module.exports = pool.promise();