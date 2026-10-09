-- =====================================================================
-- ⚠️  NEON (prod) ONLY — do NOT run this on your local database!
--     It DELETES all variants, and local has different product names.
--
-- Clean rebuild of variants + photo fix for Neon's real data:
--   id 1 Dark Delight, 2 Tiramisu, 4 Angel,
--   id 5 Surprise, 6 Lazy, 7 Peanut Butter   (there is NO id 3)
-- =====================================================================

BEGIN;

-- 1) Remove ALL existing variants (kills the duplicated / €1.00 junk rows)
DELETE FROM chocolate_variants;

-- 2) Fresh insert: exactly 2 variants per chocolate, matched by name
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
JOIN chocolates c ON lower(c.name) = v.choco_name;

COMMIT;

-- 3) Photo paths: assign the 6 real files by id order
--    (fixes any row pointing at a non-existent file like dark_large_7.jpg)
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

-- 4) Verification — every row: exactly 2 variants, 6 photo pairs, no €1.00 junk
SELECT c.id, c.name, c.photo_urls,
       string_agg(v.size || ' ' || v.weight::int || 'g @ €' || v.price,
                  ' | ' ORDER BY v.price) AS variants
FROM chocolates c
LEFT JOIN chocolate_variants v ON v.chocolate_id = c.id
GROUP BY c.id, c.name, c.photo_urls
ORDER BY c.id;

-- Should return: 12 rows total in chocolate_variants, none priced €1.00
SELECT count(*) AS total_variants FROM chocolate_variants;
