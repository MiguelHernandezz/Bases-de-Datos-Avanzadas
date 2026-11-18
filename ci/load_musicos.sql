-- CI helper: loads the CSVs produced by PECL2-carga-masiva-optimizacion/CSVMusicos.py
-- into the MUSICOS schema defined in PECL3-seguridad-transacciones/PECL3.sql
\copy grupo FROM 'grupos.csv' CSV
\copy musicos FROM 'musicos.csv' CSV
\copy conciertos FROM 'conciertos.csv' CSV
\copy discos FROM 'discos.csv' CSV
\copy canciones FROM 'canciones.csv' CSV
\copy entradas FROM 'entradas.csv' CSV
\copy grupos_tocan_conciertos FROM 'grupos_conciertos.csv' CSV
SELECT 'grupo' AS tabla, count(*) FROM grupo UNION ALL SELECT 'musicos', count(*) FROM musicos
UNION ALL SELECT 'conciertos', count(*) FROM conciertos UNION ALL SELECT 'discos', count(*) FROM discos
UNION ALL SELECT 'canciones', count(*) FROM canciones UNION ALL SELECT 'entradas', count(*) FROM entradas
UNION ALL SELECT 'grupos_tocan_conciertos', count(*) FROM grupos_tocan_conciertos;
