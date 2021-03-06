col FILE_NAME heading "File Name" format a64
col BYTES heading "Allocated (MB)" format 999,999,999
col MAXBYTES heading "Maximum (MB)" format 999,999,999
col UTILIZATION heading "Util (%)" format 999.99
col AUTOEXTENSIBLE heading "Ext"
--
SELECT
	FILE_NAME,
	(BYTES/1024/1024) as BYTES,
	(MAXBYTES/1024/1024) as MAXBYTES,
	--100 * ( BYTES / MAXBYTES ) AS UTILIZATION,
	CASE WHEN BYTES = 0 OR MAXBYTES = 0 THEN 0 ELSE ( BYTES / MAXBYTES ) * 100 END AS UTILIZATION,
	AUTOEXTENSIBLE
FROM
	DBA_DATA_FILES
WHERE
	TABLESPACE_NAME = 'REPORTER' OR TABLESPACE_NAME = 'UNDOTBS1'
ORDER BY
	TABLESPACE_NAME, FILE_NAME
/
