SET search_path TO staging;

--Relationship between colours and inventory_parts
ALTER TABLE colours ADD PRIMARY KEY (id);
ALTER TABLE inventory_parts ADD FOREIGN KEY (color_id) REFERENCES colours(id);

--Relationship between inv_parts and inventories
ALTER TABLE inventories ADD PRIMARy KEY (id);
ALTER TABLE inventory_parts ADD FOREIGN KEY (inventory_id) REFERENCES inventories(id);

--Relationship between inventories and inv_sets
ALTER TABLE inventory_sets ADD FOREIGN KEY (inventory_id) REFERENCES inventories(id);

--Relationship between inv_sets and sets
ALTER TABLE sets ADD PRIMARY KEY (set_num);
ALTER TABLE inventory_sets ADD FOREIGN KEY (set_num) REFERENCES sets(set_num);

--RELATIONSHIP BETWEEN SETS AND INVENTORIES
ALTER TABLE inventories ADD FOREIGN KEY (set_num) REFERENCES sets(set_num);

--RELATIONSHIP BETWEEN THEMES AND SETS
ALTER TABLE themes ADD PRIMARY KEY (id);
ALTER TABLE sets ADD FOREIGN KEY (theme_id) REFERENCES themes(id);


--Found that there were part_nums in inventory_parts that where not in parts table, so could not set up the foreign key
--To combat, i updated the parts table by inserting into the parts table the part_nums from inventory, keeping name and part_cat as NULL

INSERT INTO parts (part_num, name, part_cat_id)
SELECT
ip.part_num,
NULL AS name,         -- Assuming you want to set name to NULL for new rows
NULL AS part_cat_id   -- Assuming you want to set part_cat_id to NULL for new rows
FROM inventory_parts ip
LEFT JOIN parts p ON ip.part_num = p.part_num
WHERE p.part_num IS NULL;


--Deleting at Dupes from parts table
SELECT part_num, COUNT(*)
FROM parts
GROUP BY part_num
HAVING COUNT(*) > 1;
WITH duplicates AS (
SELECT
ctid,
ROW_NUMBER() OVER (PARTITION BY part_num ORDER BY ctid) AS rnum
FROM parts
)
DELETE FROM parts
WHERE ctid IN (
SELECT ctid
FROM duplicates
WHERE rnum > 1
);


--Relationship between inv_parts and parts
ALTER TABLE parts ADD PRIMARy KEY (part_num);
ALTER TABLE inventory_parts ADD FOREIGN KEY (part_num) REFERENCES parts(part_num);

--Relationship between parts and part_cat
ALTER TABLE part_categories ADD PRIMARy KEY (id);
ALTER TABLE parts ADD FOREIGN KEY (part_cat_id) REFERENCES part_categories(id);


