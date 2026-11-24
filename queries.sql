SHOW TABLES;

SELECT * FROM dtp WHERE location LIKE '%Минск%';


SELECT full_name, experience FROM drivers WHERE experience > 5;


SELECT i.full_name, COUNT(p.protocol_id) AS protocol_count
FROM inspectors i
LEFT JOIN protocols p ON i.inspector_id = p.inspector_id
GROUP BY i.full_name;


SELECT dtp_code, name, dead_count FROM dtp WHERE dead_count > 0;