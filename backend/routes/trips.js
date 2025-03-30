const express = require('express');
const router = express.Router();
const pool = require('../db');

// Get all trips
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM Trips');
        res.json(result.rows);
    } catch (error) {
        console.error('Error fetching trips:', error);
        res.status(500).json({ error: 'Failed to retrieve trips' });
    }
});

// Add a new trip
router.post('/add', async (req, res) => {
    const { destination, start_date, end_date, price } = req.body;

    if (!destination || !start_date || !end_date || !price) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const result = await pool.query(
            'INSERT INTO Trips (destination, start_date, end_date, price) VALUES ($1, $2, $3, $4) RETURNING *',
            [destination, start_date, end_date, price]
        );
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error('Error adding trip:', error);
        res.status(500).json({ error: 'Failed to add trip' });
    }
});

router.delete('/delete/:id', async (req, res) => {
    try {
        const { id } = req.params;
        console.log("🛑 Delete request received for ID:", id); // Debug log

        const deleteQuery = 'DELETE FROM trips WHERE id = $1 RETURNING *';
        const result = await pool.query(deleteQuery, [id]);

        if (result.rowCount === 0) {
            return res.status(404).json({ error: "Trip not found" });
        }

        res.json({ message: "Trip deleted successfully" });
    } catch (error) {
        console.error("❌ Error deleting trip:", error);
        res.status(500).json({ error: "Internal Server Error" });
    }
});


module.exports = router;
