SELECT
	DB_NAME(t.parent_object_id) as 'Database',
    s.Name AS 'Schema',
	t.NAME AS 'Table',
    p.rows AS 'Row Count',
    CONVERT(FLOAT, SUM(a.total_pages) * 8) / 1024 AS 'Total Space (MB)', 
    CONVERT(FLOAT, SUM(a.used_pages) * 8) / 1024 AS 'Used Space (MB)', 
    CONVERT(FLOAT, (SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024 AS 'Unused Space (MB)',
	create_date AS 'Creation Date'
FROM 
    sys.tables t
		INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
		INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
		INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
		LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.NAME NOT LIKE 'dt%' AND 
	t.is_ms_shipped = 0 AND 
	i.OBJECT_ID > 255 
GROUP BY 
    t.Name, t.parent_object_id, s.Name, p.Rows, create_date
ORDER BY 
    t.Name