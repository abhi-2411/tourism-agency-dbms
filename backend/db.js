const { Pool } = require("pg");

// Create a new PostgreSQL pool instance
const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "travel_agency",
    password: "postgreabhi",
    port: 5432,
});

// Export the pool instance to use in other files
module.exports = pool;
