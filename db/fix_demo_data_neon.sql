-- =====================================================================
-- Demo data fixes — run this on NEON (prod) if it still has the old data
-- Idempotent: safe to run multiple times, it skips what already exists.
-- =====================================================================

-- 1) Every chocolate gets its own photos (was: all pointed to dark_large_3.jpg)
UPDATE chocolates
SET photo_urls = ARRAY['/photos/dark_large_' || id || '.jpg',
                       '/photos/dark_small_'  || id || '.jpg']::text[];

-- 2) Make sure every chocolate has variants (skips existing size rows)
INSERT INTO chocolate_variants (chocolate_id, size, weight, price)
SELECT v.chocolate_id, v.size, v.weight, v.price
FROM (VALUES
  (1, 'Small',  50.00,  2.99),
  (1, 'Large',  100.00, 5.49),
  (2, 'Small',  50.00,  2.99),
  (2, 'Medium', 100.00, 5.29),
  (3, 'Small',  50.00,  3.19),
  (3, 'Medium', 100.00, 5.49),
  (4, 'Small',  100.00, 2.49),
  (4, 'Large',  200.00, 4.00),
  (5, 'Small',  50.00,  2.49),
  (5, 'Medium', 100.00, 4.49),
  (6, 'Mini',   100.00, 6.49),
  (6, 'Small',  200.00, 12.00)
) AS v(chocolate_id, size, weight, price)
WHERE NOT EXISTS (
  SELECT 1 FROM chocolate_variants cv
  WHERE cv.chocolate_id = v.chocolate_id AND cv.size = v.size
);

-- 3) Verification query
SELECT c.id, c.name,
       string_agg(v.size || ' ' || v.weight::int || 'g @ €' || v.price,
                  ' | ' ORDER BY v.price) AS variants
FROM chocolates c
LEFT JOIN chocolate_variants v ON v.chocolate_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;
