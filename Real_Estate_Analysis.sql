CREATE DATABASE real_estate;
USE real_estate;
CREATE TABLE properties
(
  property_id VARCHAR(50) PRIMARY KEY,
  property_name VARCHAR(50),
  location VARCHAR(50),
  units_total INT 
);

CREATE TABLE tenants
(
  tenant_id VARCHAR(50) PRIMARY KEY,
  tenant_name VARCHAR(50),
  property_id VARCHAR(50),
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
  );
  
  
CREATE TABLE vacancies
(
  property_id VARCHAR(50),
  vacant_units INT
);

  CREATE TABLE leases 
  (
    lease_id  VARCHAR(50) PRIMARY KEY,
    tenant_id VARCHAR(50),
    property_id VARCHAR(50),
    start_date DATE,
    duration_months INT,
    monthly_rent DECIMAL(10,2),
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
     FOREIGN KEY (property_id) REFERENCES properties(property_id)
   );
  
 
CREATE TABLE payments
(
  payment_id  VARCHAR(50) PRIMARY KEY,
  lease_id  VARCHAR(50),
  payment_date DATE,
  amount_paid DECIMAL(10,2),
  FOREIGN KEY (lease_id) REFERENCES leases (lease_id)
  
);
SELECT * FROM vacancies;

# 1. total rent collected 
SELECT SUM(amount_paid) AS total_rent FROM payments;

# 2.  vacancy rate
SELECT p.property_id, p.property_name , p.location, p.units_total, v.vacant_units,
ROUND((v.vacant_units / p.units_total)*100) AS vacancy_rate
FROM vacancies v
JOIN properties p 
ON v.property_id = p.property_id;

# 3. average lease duration
SELECT ROUND(AVG(duration_months))  AS avg_lease_duration FROM leases;

# 4. top-performing properties
SELECT pp.property_id, pp.property_name, SUM(p.amount_paid) AS top_performing_properties
FROM leases l
JOIN payments p ON l.lease_id = p.lease_id
JOIN properties pp ON l.property_id = pp.property_id
GROUP BY pp.property_id, pp.property_name
ORDER BY top_performing_properties DESC;

#5. Top 5 Properties by Rent Collected
SELECT pp.property_id, pp.property_name, SUM(p.amount_paid) AS top_performing_properties
FROM leases l
JOIN payments p ON l.lease_id = p.lease_id
JOIN properties pp ON l.property_id = pp.property_id
GROUP BY pp.property_id, pp.property_name
ORDER BY top_performing_properties DESC;

#6.Active Leases per Property 
SELECT p.property_id, p.property_name,COUNT(l.lease_id) AS active_per_property
FROM properties p 
LEFT JOIN leases l 
ON p.property_id=l.property_id
GROUP BY p.property_id, p.property_name;

#7. Average Monthly Rent by Location
select p.location,ROUND(AVG(l.monthly_rent))AS avg_monthly_rent
FROM leases l
JOIN properties p
ON l.property_id=p.property_id
GROUP BY p.location;

#🔹 8. Lease Count by Duration Buckets
SELECT 
    CASE 
        WHEN duration_months < 9 THEN 'Short-term (<9m)'
        WHEN duration_months BETWEEN 9 AND 18 THEN 'Mid-term (9-18m)'
        ELSE 'Long-term (>18m)'
    END AS lease_term_type,
    COUNT(*) AS lease_count
FROM leases
GROUP BY lease_term_type;













  
  