-- =====================================================================
-- Demo data fixes for NEON (prod)
-- NOTE: Neon's data differs from local — its 6 chocolates are:
--   id 1 Dark Delight, 2 Tiramisu, 4 Angel,
--   id 5 Surprise, 6 Lazy, 7 Peanut Butter   (there is NO id 3)
-- Idempotent: safe to run multiple times.
-- =====================================================================

-- 1) Every chocolate gets one of the 6 real photo files.
--    Assigned by id order (id -> rank 1..6), because Neon's ids are not 1..6
--    and the old data left id 7 pointing at a non-existent dark_large_7.jpg.
WITH ranked AS (
  SELECT id, row_number() OVER (ORDER BY id) AS rn FROM chocolates
)
UPDATE chocolates c
SET photo_urls = ARRAY[
  '/photos/dark_large_' || r.rn || '.jpg',
  '/photos/dark_small_'  || r.rn || '.jpg'
]
FROM ranked r
WHERE c.id = r.id AND r.rn <= 6;

-- 2) Make sure every chocolate has variants.
--    Matched by chocolate NAME (lowercased) instead of id, so it works
--    even when the id sequences differ between local and Neon.
--    Idempotent: skips any (chocolate_id, size) that already exists.
INSERT INTO chocolate_variants (chocolate_id, size, weight, price)
SELECT c.id, v.size, v.weight, v.price
FROM (VALUES
  ('dark delight',  'Small',  50.00,  2.99),
  ('dark delight',  'Large',  100.00, 5.49),
  ('tiramisu',      'Small',  50.00,  3.19),
  ('tiramisu',      'Medium', 100.00, 5.49),
  ('angel',         'Small',  100.00, 2.49),
  ('angel',         'Large',  200.00, 4.00),
  ('surprise',      'Small',  50.00,  2.49),
  ('surprise',      'Medium', 100.00, 4.49),
  ('lazy',          'Mini',   100.00, 6.49),
  ('lazy',          'Small',  200.00, 12.00),
  ('peanut butter', 'Small',  50.00,  3.29),
  ('peanut butter', 'Medium', 100.00, 5.79)
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

-- 4) Verification query — every row must show 2 variants
SELECT c.id, c.name, c.photo_urls,
       string_agg(v.size || ' ' || v.weight::int || 'g @ €' || v.price,
                  ' | ' ORDER BY v.price) AS variants
FROM chocolates c
LEFT JOIN chocolate_variants v ON v.chocolate_id = c.id
GROUP BY c.id, c.name, c.photo_urls
ORDER BY c.id;
