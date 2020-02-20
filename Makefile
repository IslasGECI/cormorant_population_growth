
# I. Definición del _phony_ *all* que enlista todos los objetivos principales
# ===========================================================================
all: reports/tendencia_poblacional_cormoran.pdf


define checkDirectories
if [ ! -d $(@D) ]; then mkdir --parents $(@D); fi
endef


#============================================================================
# Reporte de lambda de cormorán orejon
# II. Declaración de las variables
# ===========================================================================
# Variables a resultados

csvConteoNidosCormoranOrejon = \
	data/raw/conteo_nidos_cormoran_todas_islas.csv

jsonLambdaCormorantAlcatraz = \
	reports/non-tabular/jsonLambdaCormorantAlcatraz.json

pngPopulationGrowRateCormorantAlcatraz = \
	reports/figures/pngPopulationGrowRateCormorantAlcatraz.png

jsonLambdaCormorantPatos = \
	reports/non-tabular/jsonLambdaCormorantPatos.json

pngPopulationGrowRateCormorantPatos = \
	reports/figures/pngPopulationGrowRateCormorantPatos.png

jsonLambdaCormorantPajaros = \
	reports/non-tabular/jsonLambdaCormorantPajaros.json

pngPopulationGrowRateCormorantPajaros = \
	reports/figures/pngPopulationGrowRateCormorantPajaros.png

csvMaximumNestsPatos = \
	reports/tables/csvMaximumNestsPatos.csv

csvMaximumNestsPajaros = \
	reports/tables/csvMaximumNestsPajaros.csv

csvMaximumNestsAlcatraz = \
		reports/tables/csvMaximumNestsAlcatraz.csv

# III. Reglas para construir los objetivos principales
# ===========================================================================

reports/tendencia_poblacional_cormoran.pdf: reports/tendencia_poblacional_cormoran.tex $(jsonLambdaCormorantAlcatraz) $(pngPopulationGrowRateCormorantAlcatraz) $(pngPopulationGrowRateCormorantPatos) $(jsonLambdaCormorantPatos) $(pngPopulationGrowRateCormorantPajaros) $(jsonLambdaCormorantPajaros)
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pythontex $(<F)
	cd $(<D) && bibtex tendencia_poblacional_cormoran
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pdflatex $(<F)

# IV. Reglas para construir las dependencias de los objetivos principales
# ==========================================================================

$(pngPopulationGrowRateCormorantAlcatraz) $(jsonLambdaCormorantAlcatraz): $(csvMaximumNestsAlcatraz) src/calculateCormorantGrowthRate
	$(checkDirectories)
	src/calculateCormorantGrowthRate \
	--input $< \
	--drop 2005-2006 \
	--exit reports/non-tabular/jsonLambdaCormorantAlcatraz.json \
	--exit reports/figures/pngPopulationGrowRateCormorantAlcatraz.png
	
$(pngPopulationGrowRateCormorantPatos) $(jsonLambdaCormorantPatos): $(csvMaximumNestsPatos) src/calculateCormorantGrowthRate
	$(checkDirectories)
	src/calculateCormorantGrowthRate \
	--input $< \
	--drop 2011-2012 \
	--drop 2015-2016 \
	--drop 2016-2017 \
	--exit reports/non-tabular/jsonLambdaCormorantPatos.json \
	--exit reports/figures/pngPopulationGrowRateCormorantPatos.png

$(pngPopulationGrowRateCormorantPajaros) $(jsonLambdaCormorantPajaros): $(csvMaximumNestsPajaros) src/calculateCormorantGrowthRate
	$(checkDirectories)
	src/calculateCormorantGrowthRate \
	--input $< \
	--drop 2015-2016 \
	--drop 2016-2017 \
	--exit reports/non-tabular/jsonLambdaCormorantPajaros.json \
	--exit reports/figures/pngPopulationGrowRateCormorantPajaros.png

$(csvMaximumNestsPatos): $(csvConteoNidosCormoranOrejon) src/calculateMaxNestQuantity
	$(checkDirectories)
	src/calculateMaxNestQuantity \
	$< \
	Patos \
	> reports/tables/csvMaximumNestsPatos.csv

$(csvMaximumNestsPajaros): $(csvConteoNidosCormoranOrejon) src/calculateMaxNestQuantity
	$(checkDirectories)
	src/calculateMaxNestQuantity \
	$< \
	Pajaros \
	> reports/tables/csvMaximumNestsPajaros.csv

$(csvMaximumNestsAlcatraz): $(csvConteoNidosCormoranOrejon) src/calculateMaxNestQuantity
	$(checkDirectories)
	src/calculateMaxNestQuantity \
	$< \
	Alcatraz \
	> reports/tables/csvMaximumNestsAlcatraz.csv

# V. Reglas phonies
# ===========================================================================

$(csvConteoNidosCormoranOrejon):
	$(checkDirectories)
	descarga_datos $(@F) $(@D)

#=============================================================================
# V. Reglas del resto de los phonies
# ===========================================================================
# Elimina los residuos de LaTeX

clean:
	rm --force reports/*.aux
	rm --force reports/*.dvi
	rm --force reports/*.fdb_latexmk
	rm --force reports/*.fls
	rm --force reports/*.log
	rm --force reports/*.out
	rm --force reports/*.pdf
	rm --force reports/*.pytxcode
