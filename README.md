# Tendencia poblacional de cormorán orejón en las islas del Noroeste de México 2000-2020

## Resultados

La población de cormorán orejón está disminuyendo en las islas Alcatraz, Pájaros, Patos y San
Benito. En Isla Asunción la población va en aumento. Para las colonias de Coronado, Natividad, San
Jerónimo, San Martín, San Roque y Todos Santos no tenemos información suficiente para estimar una
tendencia poblacional.

## Instrucciones

Para reproducir el reporte ejecuta:

```
docker pull islasgeci/cormorant_population_growth:latests
docker run --name cormorant_population_growth islasgeci/cormorant_population_growth:latests make
docker cp cormorant_population_growth:/workdir/reports/tendencia_poblacional_cormoran.pdf .
xdg-open tendencia_poblacional_cormoran.pdf
```
