SET search_path TO staging;

SELECT 
 ls.set_num
 ,ls.name as set_name
 ,ls.year as set_release_year
 ,ls.theme_id as set_theme_id
 ,ls.num_parts as set_num_parts
 , li.id as inven_id
 , li.version as inventory_id_version
, lip.color_id as set_colour_id
, lip.quantity
, lip.is_spare
, lip.part_num
, lp.name as Part_name
,lp.part_cat_id
, lt.name as theme_name
, lc.name as colour_name
, lc.rgb
, lc.is_trans
, lpc.name
, lip.quantity as inventory_quantity
FROM sets as ls
JOIN inventories as li ON ls.set_num = li.set_num
JOIN inventory_parts as lip ON li.id = lip.inventory_id
JOIN parts as lp ON lip.part_num = lp.part_num
JOIN themes as lt ON ls.theme_id = lt.id
join colours as lc on lc.id = lip.color_id
join part_categories as lpc on lp.part_cat_id = lpc.id;