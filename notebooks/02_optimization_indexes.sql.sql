-- ============================
-- ÍNDICE 1: Deliveries por estado y fecha programada
-- Mejora Q3 y Q10
-- ============================
DROP INDEX IF EXISTS idx_deliveries_status_scheduled;

CREATE INDEX idx_deliveries_status_scheduled
ON deliveries (delivery_status, scheduled_datetime);


-- ============================
-- ÍNDICE 2: Deliveries por trip_id
-- Mejora Q4, Q7, Q9 y Q10
-- ============================
DROP INDEX IF EXISTS idx_deliveries_trip_id;

CREATE INDEX idx_deliveries_trip_id
ON deliveries (trip_id);


-- ============================
-- ÍNDICE 3: Trips por driver_id y fecha
-- Mejora Q4 y Q5
-- ============================
DROP INDEX IF EXISTS idx_trips_driver_departure;

CREATE INDEX idx_trips_driver_departure
ON trips (driver_id, departure_datetime);


-- ============================
-- ÍNDICE 4: Trips por status y route_id
-- Mejora Q6, Q7 y Q9
-- ============================
DROP INDEX IF EXISTS idx_trips_status_route;

CREATE INDEX idx_trips_status_route
ON trips (status, route_id);


-- ============================
-- ÍNDICE 5: Índice parcial para entregas retrasadas
-- Mejora Q7 y Q10
-- ============================
DROP INDEX IF EXISTS idx_deliveries_delayed;

CREATE INDEX idx_deliveries_delayed
ON deliveries (trip_id)
WHERE delivered_datetime > scheduled_datetime;
