
-- query 1 cuales vehiculos estan activos ? 
EXPLAIN ANALYZE
SELECT vehicle_id, license_plate, vehicle_type
FROM vehicles
WHERE status = 'active';

-- query 2 cantidad de viajes por conductor
EXPLAIN ANALYZE
SELECT d.driver_id, d.first_name, d.last_name, COUNT(t.trip_id) AS total_trips
FROM drivers d
JOIN trips t ON d.driver_id = t.driver_id
GROUP BY d.driver_id, d.first_name, d.last_name
ORDER BY total_trips desc

-- query 3 Entregas pendientes ordenadas por fecha programada
EXPLAIN ANALYZE
SELECT 
    d.delivery_id,
    d.customer_name,
    d.delivery_address,
    d.scheduled_datetime
FROM deliveries d
WHERE d.delivery_status = 'pending'
ORDER BY d.scheduled_datetime ASC;

-- query 4: Promedio de entregas por conductor (6 meses)
EXPLAIN ANALYZE
WITH entregas_por_viaje AS (
    SELECT
        t.driver_id,
        t.trip_id,
        COUNT(d.delivery_id) AS deliveries_in_trip
    FROM trips t
    JOIN deliveries d ON d.trip_id = t.trip_id
    WHERE t.departure_datetime >= CURRENT_DATE - INTERVAL '6 months'
    GROUP BY t.driver_id, t.trip_id
)
SELECT
    dr.driver_id,
    CONCAT(dr.first_name, ' ', dr.last_name) AS full_name,
    AVG(e.deliveries_in_trip) AS avg_deliveries_per_trip,
    COUNT(e.trip_id) AS total_trips
FROM drivers dr
JOIN entregas_por_viaje e ON dr.driver_id = e.driver_id
GROUP BY dr.driver_id, dr.first_name, dr.last_name
HAVING COUNT(e.trip_id) >= 10
ORDER BY avg_deliveries_per_trip DESC;


-- query 5: Q5. Conductores con licencia próxima a vencer y alta carga de trabajo
EXPLAIN ANALYZE
select dr.driver_id,
		CONCAT(dr.first_name, ' ', dr.last_name)as full_name,
		dr.license_expiry
from drivers dr
where
	dr.license_expiry <= current_date + interval '90 days' 
	and dr.driver_id  in (
		select t.driver_id
		from trips t
		where t.departure_datetime >= current_date - interval '1 year'
		group by t.driver_id 
		having count(*) > 50 
	);
		
-- query 6: consumo total de combustible por ruta 
EXPLAIN ANALYZE

select r.route_id,
		concat(r.origin_city,'-',r.destination_city) as ciudades_origen_destino,
		count(t.trip_id ) as viajes_completados,
		sum(t.fuel_consumed_liters) as consumo_total_gasolina,
		avg(t.fuel_consumed_liters ) as promedio_gasolina
from routes r
join trips t on r.route_id = t.route_id
where t.status = 'completed'
group by r.route_id, r.origin_city, r.destination_city
order by consumo_total_gasolina desc

-- query 7: porcentaje de entregas retrasadas por ciudad destino
EXPLAIN ANALYZE
SELECT
    r.destination_city,
    COUNT(d.delivery_id) AS total_entregas,
    SUM(
        CASE 
            WHEN d.delivered_datetime > d.scheduled_datetime THEN 1 
            ELSE 0 
        END
    ) AS entregas_retrasadas,
    ROUND(
        100.0 * SUM(
            CASE 
                WHEN d.delivered_datetime > d.scheduled_datetime THEN 1 
                ELSE 0 
            END
        ) / NULLIF(COUNT(d.delivery_id), 0),
        2
    ) AS porcentaje_retrasadas
FROM routes r
JOIN trips t 
    ON t.route_id = r.route_id
JOIN deliveries d 
    ON d.trip_id = t.trip_id
GROUP BY 
    r.destination_city
ORDER BY 
    porcentaje_retrasadas DESC;
      

-- Q8. Vehículos con sobreutilización de capacidad
EXPLAIN ANALYZE
SELECT
    v.vehicle_id,
    v.license_plate,
    v.capacity_kg,
    ROUND(AVG(t.total_weight_kg), 2) AS carga_promedio_kg,
    ROUND(100.0 * AVG(t.total_weight_kg) / v.capacity_kg, 2) AS porcentaje_uso_capacidad
FROM vehicles v
JOIN trips t ON t.vehicle_id = v.vehicle_id
WHERE t.status = 'completed'
GROUP BY v.vehicle_id, v.license_plate, v.capacity_kg
HAVING AVG(t.total_weight_kg) > 0.8 * v.capacity_kg
ORDER BY porcentaje_uso_capacidad DESC;

-- Q9. Ranking de eficiencia de rutas
EXPLAIN ANALYZE
WITH route_stats AS (
    SELECT
        r.route_id,
        r.route_code,
        r.origin_city,
        r.destination_city,
        COUNT(t.trip_id) AS trips_completados,
        AVG(
            EXTRACT(EPOCH FROM (t.arrival_datetime - t.departure_datetime)) / 3600.0
        ) AS duracion_promedio_horas,
        AVG(t.fuel_consumed_liters) AS combustible_promedio,
        SUM(
            CASE
                WHEN d.delivery_status = 'delivered'
                     AND d.delivered_datetime <= d.scheduled_datetime
                THEN 1 ELSE 0
            END
        )::float / NULLIF(COUNT(d.delivery_id), 0) AS tasa_entregas_a_tiempo
    FROM routes r
    JOIN trips t ON t.route_id = r.route_id
    LEFT JOIN deliveries d ON d.trip_id = t.trip_id
    WHERE t.status = 'completed'
    GROUP BY r.route_id, r.route_code, r.origin_city, r.destination_city
),
scores AS (
    SELECT
        route_id,
        route_code,
        origin_city,
        destination_city,
        trips_completados,
        duracion_promedio_horas,
        combustible_promedio,
        tasa_entregas_a_tiempo,
        (
            tasa_entregas_a_tiempo * 0.5
            + (1.0 / NULLIF(duracion_promedio_horas, 0)) * 0.25
            + (1.0 / NULLIF(combustible_promedio, 0)) * 0.25
        ) AS eficiencia_score
    FROM route_stats
)
SELECT
    *,
    RANK() OVER (ORDER BY eficiencia_score DESC) AS eficiencia_rank
FROM scores
ORDER BY eficiencia_rank;

-- Q10. Conductores con mayor porcentaje de entregas retrasadas
EXPLAIN ANALYZE
WITH driver_delays AS (
    SELECT
        dr.driver_id,
        CONCAT(dr.first_name, ' ', dr.last_name) AS full_name,
        COUNT(d.delivery_id) AS total_entregas,
        SUM(
            CASE
                WHEN d.delivered_datetime > d.scheduled_datetime THEN 1
                ELSE 0
            END
        ) AS entregas_retrasadas
    FROM drivers dr
    JOIN trips t ON t.driver_id = dr.driver_id
    JOIN deliveries d ON d.trip_id = t.trip_id
    GROUP BY dr.driver_id, full_name
)
SELECT
    driver_id,
    full_name,
    total_entregas,
    entregas_retrasadas,
    ROUND(100.0 * entregas_retrasadas / NULLIF(total_entregas, 0), 2) AS porcentaje_retraso,
    RANK() OVER (
        ORDER BY 100.0 * entregas_retrasadas / NULLIF(total_entregas, 0) DESC
    ) AS rank_retraso
FROM driver_delays
WHERE total_entregas >= 50
ORDER BY rank_retraso;

  -- Q11. Intervalos entre mantenimientos por vehículo
EXPLAIN ANALYZE
SELECT
    v.vehicle_id,
    v.license_plate,
    m.maintenance_type,
    m.maintenance_date,
    LAG(m.maintenance_date) OVER (
        PARTITION BY v.vehicle_id
        ORDER BY m.maintenance_date
    ) AS mantenimiento_anterior,
    (m.maintenance_date::date
     - LAG(m.maintenance_date::date) OVER (
                  PARTITION BY v.vehicle_id
                  ORDER BY m.maintenance_date 
        )
    ) AS dias_desde_mantenimiento_anterior
FROM vehicles v
JOIN maintenance m ON m.vehicle_id = v.vehicle_id
ORDER BY v.vehicle_id, m.maintenance_date;



-- Q12. Evolución mensual de viajes y consumo de combustible
EXPLAIN ANALYZE
WITH monthly_stats AS (
    SELECT
        date_trunc('month', departure_datetime)::date AS mes,
        COUNT(trip_id) AS total_trips,
        SUM(fuel_consumed_liters) AS total_combustible
    FROM trips
    WHERE status = 'completed'
    GROUP BY date_trunc('month', departure_datetime)
)
SELECT
    mes,
    total_trips,
    total_combustible,
    SUM(total_trips) OVER (ORDER BY mes) AS trips_acumulados,
    SUM(total_combustible) OVER (ORDER BY mes) AS combustible_acumulado
FROM monthly_stats
ORDER BY mes;


