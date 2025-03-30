
-- Customers Table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT
);

-- Trips Table
CREATE TABLE Trips (
    trip_id SERIAL PRIMARY KEY,
    destination VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    availability INT NOT NULL CHECK (availability >= 0)
);

-- Bookings Table (Many-to-Many: Customers ↔ Trips)
CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    trip_id INT REFERENCES Trips(trip_id) ON DELETE CASCADE,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Completed', 'Cancelled'))
);

-- Payments Table
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50) CHECK (payment_method IN ('Credit Card', 'Debit Card', 'UPI', 'Cash', 'Bank Transfer'))
);

-- Agents Table
CREATE TABLE Agents (
    agent_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    agency_name VARCHAR(100)
);

-- Reviews Table
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id) ON DELETE CASCADE,
    trip_id INT REFERENCES Trips(trip_id) ON DELETE CASCADE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT
);

--  Insert Customers
INSERT INTO Customers (name, email, phone, address) VALUES
('John Doe', 'john@example.com', '9876543210', 'New York, USA'),
('Alice Smith', 'alice@example.com', '9876543211', 'London, UK');

-- Insert Trips
INSERT INTO Trips (destination, start_date, end_date, price, availability) VALUES
('Paris', '2025-06-01', '2025-06-07', 1500.00, 10),
('Bali', '2025-07-10', '2025-07-17', 1200.00, 8);

-- Insert Bookings
INSERT INTO Bookings (customer_id, trip_id, payment_status) VALUES
(1, 1, 'Pending'),
(2, 2, 'Completed');

-- Insert Payments
INSERT INTO Payments (booking_id, amount, payment_method) VALUES
(1, 1500.00, 'Credit Card'),
(2, 1200.00, 'UPI');

-- Insert Agents
INSERT INTO Agents (name, email, phone, agency_name) VALUES
('Mark Taylor', 'mark@travel.com', '9876543212', 'Global Travels'),
('Emma Brown', 'emma@explore.com', '9876543213', 'Explore World');

-- Insert Reviews (Updated: Assigned to Customer 2)
INSERT INTO Reviews (customer_id, trip_id, rating, comments) VALUES
(2, 1, 5, 'Amazing experience!'),
(2, 2, 4, 'Great trip, but needed better accommodation.');


ALTER TABLE Customers ADD COLUMN password TEXT NOT NULL;
ALTER TABLE Agents ADD COLUMN password TEXT NOT NULL;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO Customers (name, email, phone, address, password) VALUES
('John Doe', 'john@example.com', '9876543210', 'New York, USA', crypt('password123', gen_salt('bf'))),
('Alice Smith', 'alice@example.com', '9876543211', 'London, UK', crypt('alicepass', gen_salt('bf')));

CREATE INDEX idx_customers_email ON Customers(email);
CREATE INDEX idx_agents_email ON Agents(email);
CREATE INDEX idx_trips_destination ON Trips(destination);
CREATE INDEX idx_bookings_customer_id ON Bookings(customer_id);
CREATE INDEX idx_payments_booking_id ON Payments(booking_id);

UPDATE Trips SET availability = availability - 1 WHERE trip_id = 1;

UPDATE Bookings SET payment_status = 'Cancelled' WHERE booking_id = 1;
UPDATE Trips SET availability = availability + 1 WHERE trip_id = 1;

DELETE FROM Customers WHERE customer_id = 1;

INSERT INTO Payments (booking_id, amount, payment_method)
VALUES (1, 1500.00, 'Credit Card');

UPDATE Bookings SET payment_status = 'Completed' WHERE booking_id = 1;


SELECT T.destination, COUNT(B.trip_id) AS total_bookings
FROM Trips T
JOIN Bookings B ON T.trip_id = B.trip_id
GROUP BY T.destination
ORDER BY total_bookings DESC
LIMIT 5;

SELECT T.destination, SUM(P.amount) AS total_revenue
FROM Payments P
JOIN Bookings B ON P.booking_id = B.booking_id
JOIN Trips T ON B.trip_id = T.trip_id
GROUP BY T.destination
ORDER BY total_revenue DESC
LIMIT 5;

SELECT C.name, COUNT(B.customer_id) AS total_bookings
FROM Customers C
JOIN Bookings B ON C.customer_id = B.customer_id
GROUP BY C.name
ORDER BY total_bookings DESC
LIMIT 5;

SELECT T.destination, AVG(R.rating) AS avg_rating
FROM Reviews R
JOIN Trips T ON R.trip_id = T.trip_id
GROUP BY T.destination
ORDER BY avg_rating DESC
LIMIT 5;

CREATE INDEX idx_trips_price ON Trips(price);
CREATE INDEX idx_reviews_trip_id ON Reviews(trip_id);

ALTER TABLE Bookings
ADD CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE;

ALTER TABLE Reviews
ADD CONSTRAINT fk_review_trip FOREIGN KEY (trip_id) REFERENCES Trips(trip_id) ON DELETE CASCADE;