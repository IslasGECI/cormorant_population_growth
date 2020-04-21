#============================================================================
# Reporte de tendencia poblacional de cormorán orejon
# I. Definición del _phony_ *all* que enlista todos los objetivos principales
# ===========================================================================
all: reports/tendencia_poblacional_cormoran.pdf

define renderLatex
cd $(<D) && pdflatex $(<F)
cd $(<D) && pdflatex $(<F)
endef

define checkDirectories
mkdir --parents $(@D)
endef


# II. Declaración de las variables
# ===========================================================================
# Variables a resultados

csvDatosParejasAvesMarinas = \
	data/raw/parejas_aves_marinas_islas_del_pacifico.csv

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

csvCormorantBurrowsQuantityPacificIslands = \
	data/processed/csvCormorantBurrowsQuantityPacificIslands.csv

csvGrowthRateCormorantPacificIslands = \
	reports/tables/csvGrowthRateCormorantPacificIslands.csv

csvFullResultsCormorantPacificIslands = \
	reports/tables/csvFullResultsCormorantPacificIslands.csv

csvCormorantsPopulationGrowing = \
	reports/tables/csvCormorantsPopulationGrowing.csv

csvCormorantsPopulationDecreasing = \
	reports/tables/csvCormorantsPopulationDecreasing.csv

csvGrowthRateDistributionCormorantAlcatraz = \
	reports/tables/growth_rate_distribution_cormorant_alcatraz.csv

csvGrowthRateDistributionCormorantPatos = \
	reports/tables/growth_rate_distribution_cormorant_patos.csv

csvGrowthRateDistributionCormorantPajaros = \
	reports/tables/growth_rate_distribution_cormorant_pajaros.csv

csvCormorantAllGrowthRates = \
	reports/tables/cormorant_all_islets_growth_rates.csv


# III. Reglas para construir los objetivos principales
# ===========================================================================

reports/tendencia_poblacional_cormoran.pdf: reports/tendencia_poblacional_cormoran.tex $(pngPopulationGrowRateCormorantAlcatraz) $(pngPopulationGrowRateCormorantPatos) $(pngPopulationGrowRateCormorantPajaros) $(csvCormorantBurrowsQuantityPacificIslands) $(csvGrowthRateCormorantPacificIslands) $(csvCormorantsPopulationDecreasing) $(csvCormorantsPopulationGrowing) $(csvCormorantAllGrowthRates)
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pythontex $(<F)
	cd $(<D) && bibtex $(subst .tex,,$(<F))
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pdflatex $(<F)

# IV. Reglas para construir las dependencias de los objetivos principales
# ==========================================================================

$(pngPopulationGrowRateCormorantAlcatraz) $(csvGrowthRateDistributionCormorantAlcatraz): $(csvMaximumNestsAlcatraz) src/calculateCormorantGrowthRate
	$(checkDirectories)
	src/calculateCormorantGrowthRate \
	--input $< \
	--drop 2005-2006 \
	--exit $(csvGrowthRateDistributionCormorantAlcatraz) \
	--exit $(pngPopulationGrowRateCormorantAlcatraz)
	
$(pngPopulationGrowRateCormorantPatos) $(csvGrowthRateDistributionCormorantPatos): $(csvMaximumNestsPatos) src/calculateCormorantGrowthRate
	$(checkDirectories)
	src/calculateCormorantGrowthRate \
	--input $< \
	--drop 2011-2012 \
	--drop 2015-2016 \
	--drop 2016-2017 \
	--exit $(csvGrowthRateDistributionCormorantPatos) \
	--exit $(pngPopulationGrowRateCormorantPatos)
	

$(pngPopulationGrowRateCormorantPajaros) $(csvGrowthRateDistributionCormorantPajaros): $(csvMaximumNestsPajaros) src/calculateCormorantGrowthRate
	$(checkDirectories)
	src/calculateCormorantGrowthRate \
	--input $< \
	--drop 2015-2016 \
	--drop 2016-2017 \
	--exit $(csvGrowthRateDistributionCormorantPajaros) \
	--exit $(pngPopulationGrowRateCormorantPajaros)

$(csvMaximumNestsPatos): $(csvConteoNidosCormoranOrejon) src/calculate_max_nest_quantity
	$(checkDirectories)
	src/calculate_max_nest_quantity \
	$< \
	Patos \
	> $@

$(csvMaximumNestsPajaros): $(csvConteoNidosCormoranOrejon) src/calculate_max_nest_quantity
	$(checkDirectories)
	src/calculate_max_nest_quantity \
	$< \
	Pajaros \
	> $@

$(csvMaximumNestsAlcatraz): $(csvConteoNidosCormoranOrejon) src/calculate_max_nest_quantity
	$(checkDirectories)
	src/calculate_max_nest_quantity \
	$< \
	Alcatraz \
	> $@
$(csvCormorantBurrowsQuantityPacificIslands): $(csvDatosParejasAvesMarinas) src/calculate_burrows_quantity_per_species
	$(checkDirectories)
	src/calculate_burrows_quantity_per_species \
	$< \
	"Double-crested Cormorant" \
	> $@

$(csvGrowthRateCormorantPacificIslands) $(csvFullResultsCormorantPacificIslands): $(csvCormorantBurrowsQuantityPacificIslands) src/calculateGrowthRateSeaBirds
	$(checkDirectories)
	mkdir --parents reports/figures
	src/calculateGrowthRateSeaBirds \
	--input $< \
	--exit $(csvFullResultsCormorantPacificIslands) \
	--exit $(csvGrowthRateCormorantPacificIslands)

$(csvCormorantsPopulationDecreasing): $(csvFullResultsCormorantPacificIslands) src/select_growth_rates_and_p_values
	$(checkDirectories)
	src/select_growth_rates_and_p_values $< p_valor_menor \
	> $@

$(csvCormorantsPopulationGrowing): $(csvFullResultsCormorantPacificIslands) src/select_growth_rates_and_p_values
	$(checkDirectories)
	src/select_growth_rates_and_p_values $< p_valor \
	> $@

$(csvCormorantAllGrowthRates): src/joinCormorantGrowthRates $(csvGrowthRateDistributionCormorantAlcatraz) $(csvGrowthRateDistributionCormorantPatos) $(csvGrowthRateDistributionCormorantPajaros) $(csvFullResultsCormorantPacificIslands)
	$(checkDirectories)
	src/joinCormorantGrowthRates \
	--input $(csvFullResultsCormorantPacificIslands) \
	--input $(csvGrowthRateDistributionCormorantPatos) \
	--input $(csvGrowthRateDistributionCormorantPajaros) \
	--input $(csvGrowthRateDistributionCormorantAlcatraz) \
	--exit $(csvCormorantAllGrowthRates)

# V. Reglas phonies
# ===========================================================================

$(csvDatosParejasAvesMarinas):
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
	rm --force --recursive reports/tables/
	rm --force --recursive reports/figures/
	rm --force --recursive reports/non-tabular/
	rm --force --recursive reports/pythontex*/
	rm --force --recursive src/__pycache__/

