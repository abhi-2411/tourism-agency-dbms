const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');


const app = express();
app.use(cors());
app.use(bodyParser.json());

// Create a new pool instance
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'travel_agency',
    password: 'postgreabhi',
    port: 5432,
});

// Registration endpoint
app.post('/api/customers/register', async (req, res) => {
    const { name, email, phone, address, password } = req.body;  // Ensure `name` is extracted

    // Validate that all required fields exist
    if (!name || !email || !phone || !password) {
        return res.status(400).json({ message: "All fields are required" });
    }

    try {
        console.log("Received data:", req.body); // Debugging log

        const result = await pool.query(
            'INSERT INTO Customers (name, email, phone, address, password) VALUES ($1, $2, $3, $4, $5) RETURNING *',
            [name, email, phone, address, password]
        );

        return res.status(201).json({ message: 'Customer registered successfully', customer: result.rows[0] });
    } catch (error) {
        console.error('Error during registration:', error);
        return res.status(500).json({ message: 'Error registering customer', error: error.message });
    }
});


// Login endpoint
app.post('/api/customers/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const result = await pool.query('SELECT * FROM customers WHERE email = $1', [email]);
        const customer = result.rows[0];

        if (customer && customer.password === password) {
            return res.status(200).json({ message: 'Login successful', customer });
        } else {
            return res.status(401).json({ message: 'Invalid credentials' });
        }
    } catch (error) {
        console.error('Error during login:', error);
        return res.status(500).json({ message: 'Error logging in' });
    }
});

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});