-- Used-Car Market Intelligence — Pricing, Inventory & Expansion Strategy
-- SQLite-oriented query library

-- 1. Basic quality check
SELECT COUNT(*) AS rows,
       COUNT(DISTINCT car_name || '|' || brand || '|' || model || '|' || selling_price) AS distinct_sample_keys
FROM used_cars;

-- 2. Median price by brand and age band
SELECT brand, age_band,
       COUNT(*) AS listings,
       AVG(selling_price) AS avg_price,
       -- SQLite has no built-in MEDIAN; use a percentile extension or precomputed summary in the workbook.
       MIN(selling_price) AS min_price,
       MAX(selling_price) AS max_price
FROM used_cars
GROUP BY brand, age_band
ORDER BY brand, age_band;

-- 3. Pricing-risk segments
SELECT brand, age_band, fuel_type,
       COUNT(*) AS listings,
       AVG(selling_price) AS avg_price,
       MAX(selling_price) - MIN(selling_price) AS observed_range
FROM used_cars
GROUP BY brand, age_band, fuel_type
HAVING COUNT(*) >= 30
ORDER BY observed_range DESC;

-- 4. Top brands by volume
SELECT brand, COUNT(*) AS listings
FROM used_cars
GROUP BY brand
ORDER BY listings DESC
LIMIT 15;

-- 5. Average price by fuel
SELECT fuel_type, COUNT(*) AS listings, AVG(selling_price) AS avg_price
FROM used_cars
GROUP BY fuel_type
ORDER BY avg_price DESC;

-- 6. Average price by transmission
SELECT transmission_type, COUNT(*) AS listings, AVG(selling_price) AS avg_price
FROM used_cars
GROUP BY transmission_type
ORDER BY avg_price DESC;

-- 7. Vahan state snapshot
SELECT state,
       SUM(count) AS registration_count
FROM vahan_raw
GROUP BY state
ORDER BY registration_count DESC;

-- 8. Matched car-maker registration signal by state
SELECT state,
       SUM(count) AS matched_car_registration_count
FROM vahan_raw
WHERE car_brand_match IS NOT NULL
GROUP BY state
ORDER BY matched_car_registration_count DESC;

-- 9. Expansion score is computed in the Python analysis because the scoring uses
-- winsorized normalization and the national CarDekho brand-price crosswalk.

-- 10. Business decision: join the analyzed inventory matrix and expansion score
-- tables for final recommendation reporting.
