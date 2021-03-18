SELECT
  Isla,
  Temporada,
  CASE
    WHEN MAX(Nidos_activos_por_visita) IS NULL THEN 'NA'
    ELSE MAX(Nidos_activos_por_visita)
  END Nidos_activos_por_visita,
  CASE
    WHEN Notas IS NULL THEN 'NA'
    ELSE Notas
  END Notas
FROM ${table_name}
GROUP BY Isla, Temporada
