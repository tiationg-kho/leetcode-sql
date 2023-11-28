# Write your MySQL query statement below

SELECT DISTINCT author_id AS id
FROM views v
WHERE v.author_id = v.viewer_id
ORDER BY v.author_id;