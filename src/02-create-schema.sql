-- This file is a SQLite3 schema for the NUTTAB 2010 database. It is
-- derived from the schema of the original product.

-- This file is (c) by Andrew Harvey <andrew.harvey4@gmail.com>
-- It is licensed under a Creative Commons Attribution-ShareAlike 3.0
-- Australia License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-sa/3.0/au/>.

-- This work is based on the CC BY-SA 3.0 AU licensed NUTTAB 2010 product.
--
--    Based on source: NUTTAB 2010 (Food Standards Australia NewZealand);
--    The University of New South Wales; Professor Heather Greenfield and
--    co-workers at the University of New South Wales;  Tables of
--    composition of Australian Aboriginal Foods (J Brand-Miller, KW
--    James and PMA Maggiore).

-- The original work is avaliable at http://www.foodstandards.gov.au/consumerinformation/nuttab2010/nuttab2010electronic5119.cfm
-- The licensing statement of the original work is avaliable at http://www.foodstandards.gov.au/consumerinformation/nuttab2010/informationandlicens5099.cfm

CREATE TABLE food
(
  food_id character(8),
  name text,
  optional_name text,
  description text,
  scientific_name text,
  derivation text,
  nitrogen_factor real,
  fat_factor real,
  specific_gravity real,
  sampling_details text,
  inedible_portion text,
  edible_portion text,
  food_group text,
  sub_group text,
  sort_order integer,

  PRIMARY KEY (food_id)
);

CREATE TABLE nutriant
(
  nutriant_id text,
  description text,
  scale text,

  PRIMARY KEY (nutriant_id)
);

-- nutriants per solid and liquid foods per weight of food (per 100g of food)
CREATE TABLE food_nutriant_per_weight
(
  food_id character(8) REFERENCES food(food_id),
  nutrient_id text REFERENCES nutriant(nutriant_id),
  value real,
  category text,

  PRIMARY KEY (food_id, nutrient_id)
);

-- nutriants per liquid foods per volume (per 100mL of food)
CREATE TABLE food_nutriant_per_volume
(
  food_id character(8) REFERENCES food(food_id),
  nutrient_id text REFERENCES nutriant(nutriant_id),
  value real,
  category text,

  PRIMARY KEY (food_id, nutrient_id)
);

CREATE TABLE recipe
(
  food_id character(8) REFERENCES food(food_id),
  food_name text,
  total_weight_change real,
  ingredient_id character(8),
  ingredient_name text,
  ingredient_weight real,
  retention_factor integer,

  PRIMARY KEY (food_id, ingredient_id)
);
