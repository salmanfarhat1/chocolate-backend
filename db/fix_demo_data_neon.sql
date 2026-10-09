-- =====================================================================
-- Demo data fixes — run this on NEON (prod) if it still has the old data
-- Idempotent: safe to run multiple times, it skips what already exists.
-- =====================================================================

-- 1) Every chocolate gets its own photos (was: all pointed to dark_large_3.jpg)
UPDATE chocolates
SET photo_urls = ARRAY['/photos/dark_large_' || id || '.jpg',
                       '/photos/dark_small_'  || id || '.jpg']::text[];

-- 2) Make sure every chocolate has variants.
--    Matched by chocolate NAME (lowercased) instead of id, so it works
--    even when the id sequences differ between local and Neon.
--    Idempotent: skips any (chocolate_id, size) that already exists.
INSERT INTO chocolate_variants (chocolate_id, size, weight, price)
SELECT c.id, v.size, v.weight, v.price
FROM (VALUES
  ('dark delight',     'Small',  50.00,  2.99),
  ('dark delight',     'Large',  100.00, 5.49),
  ('hazelnut delight', 'Small',  50.00,  2.99),
  ('hazelnut delight', 'Medium', 100.00, 5.29),
  ('snickers',         'Small',  50.00,  3.19),
  ('snickers',         'Medium', 100.00, 5.49),
  ('angel',            'Small',  100.00, 2.49),
  ('angel',            'Large',  200.00, 4.00),
  ('test',             'Small',  50.00,  2.49),
  ('test',             'Medium', 100.00, 4.49),
  ('lazy',             'Mini',   100.00, 6.49),
  ('lazy',             'Small',  200.00, 12.00)
) AS v(choco_name, size, weight, price)
JOIN chocolates c ON lower(c.name) = v.choco_name
WHERE NOT EXISTS (
  SELECT 1 FROM chocolate_variants cv
  WHERE cv.chocolate_id = c.id AND cv.size = v.size
);

-- 3) Diagnostics: what ids/names does this database actually have?
SELECT id, name FROM chocolates ORDER BY id;
SELECT chocolate_id, size, weight, price
FROM chocolate_variants ORDER BY chocolate_id, price;

-- 4) Verification query
SELECT c.id, c.name,
       string_agg(v.size || ' ' || v.weight::int || 'g @ €' || v.price,
                  ' | ' ORDER BY v.price) AS variants
FROM chocolates c
LEFT JOIN chocolate_variants v ON v.chocolate_id = c.id
GROUP BY c.id, c.name
ORDER BY c.id;
