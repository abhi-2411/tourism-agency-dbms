**🚀 Project Overview**
Travel Agency Management System is a database-centric project built using PostgreSQL to model and manage the operations of a travel business — including trips, customers, bookings, payments, agents, and reviews.
The primary goal is to ensure clean data architecture, reduce redundancy, and enforce real-world business rules using relational modeling and constraints.

The database has been carefully designed, normalized up to 3NF, and implemented using pgAdmin. It supports complex queries, views, triggers, and indexing — making it efficient for analytics and scalable for 
larger datasets. The project showcases how real-world systems can be mapped into relational structures with integrity, flexibility, and security in mind.

**🔍 Features**
1. Well-Normalized Relational Schema: Customers, Trips, Bookings, Payments, Agents, and Reviews — each as dedicated tables with proper relationships.
2. Foreign Keys & Cascading Rules: Enforce data integrity and automatic cleanup of dependent records.
3. Constraints: Used for validations like uniqueness, check ranges, and composite uniqueness to prevent anomalies.
4. Triggers: Prevent overbooking by dynamically checking availability before insertions.
5. Views: Created for top destinations, customer activity, and revenue insights to support analytics and reporting.
6. Advanced SQL: Includes usage of set operations (UNION, INTERSECT, EXCEPT), group-by queries, nested subqueries, and indexed searches.
7. Secure Password Storage: Passwords for customers and agents are hashed using pgcrypto functions inside PostgreSQL.

**🛠 Tech Stack**
- Database: PostgreSQL (Designed and managed using pgAdmin)
- Schema Design: Follows normalization principles (up to 3NF)
- Database Access Tool: pgAdmin 4
- Extensions Used: pgcrypto for password encryption
- Additional Tools: psql CLI for executing queries, data seeding, and testing
