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

.PHONY: all clean tests

# II. Declaración de las variables
# ===========================================================================
# Variables a resultados

csvConteoNidosCormoranOrejon = \
	data/raw/conteo_nidos_cormoran_todas_islas.csv

csvCormorantMaximumNests = \
	data/processed/cormorant_all_islets_data.csv

csvCormorantCleanData = \
	data/processed/cormorant_all_islets_clean_data.csv

pngPopulationGrowRateCormorantAllIslets = \
	reports/figures/cormorant_population_trend_alcatraz.png \
	reports/figures/cormorant_population_trend_asuncion.png \
	reports/figures/cormorant_population_trend_coronado.png \
	reports/figures/cormorant_population_trend_natividad.png \
	reports/figures/cormorant_population_trend_pajaros.png \
	reports/figures/cormorant_population_trend_patos.png \
	reports/figures/cormorant_population_trend_san_benito.png \
	reports/figures/cormorant_population_trend_san_jeronimo.png \
	reports/figures/cormorant_population_trend_san_martin.png \
	reports/figures/cormorant_population_trend_san_roque.png \
	reports/figures/cormorant_population_trend_todos_santos.png

csvCormorantAllGrowthRates = \
	reports/tables/cormorant_all_islets_growth_rates.csv

csvCormorantsPopulationGrowing = \
	reports/tables/cormorant_colonies_growing.csv

csvCormorantsPopulationDecreasing = \
	reports/tables/cormorant_colonies_decreasing.csv

csvCormorantsPopulationWithoutSignificance = \
	reports/tables/cormorant_colonies_without_significance.csv


# III. Reglas para construir los objetivos principales
# ===========================================================================

reports/tendencia_poblacional_cormoran.pdf: reports/tendencia_poblacional_cormoran.tex $(pngPopulationGrowRateCormorantAllIslets) $(csvCormorantAllGrowthRates) $(csvCormorantsPopulationDecreasing) $(csvCormorantsPopulationGrowing) $(csvCormorantsPopulationWithoutSignificance)
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pythontex $(<F)
	cd $(<D) && bibtex $(subst .tex,,$(<F))
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pdflatex $(<F)

# IV. Reglas para construir las dependencias de los objetivos principales
# ==========================================================================

$(csvCormorantMaximumNests): $(csvConteoNidosCormoranOrejon) src/calculate_max_nest_quantity
	$(checkDirectories)
	$(word 2, $^) \
		$< \
		> $@

$(csvCormorantCleanData): $(csvCormorantMaximumNests) src/query_burrows_quantity_data
	$(checkDirectories)
	$(word 2, $^) \
		--input $< \
		--output $(csvCormorantCleanData)

$(pngPopulationGrowRateCormorantAllIslets) $(csvCormorantAllGrowthRates): $(csvCormorantCleanData) src/calculate_cormorant_growth_rate
	$(checkDirectories)
	$(word 2, $^) \
		--input $< \
		--output $(csvCormorantAllGrowthRates)

$(csvCormorantsPopulationDecreasing): $(csvCormorantAllGrowthRates) src/select_growth_rates_and_p_values
	$(checkDirectories)
	$(word 2, $^) \
		$< \
		p_value_menor \
		"<= 0.1" \
		> $@

$(csvCormorantsPopulationGrowing): $(csvCormorantAllGrowthRates) src/select_growth_rates_and_p_values
	$(checkDirectories)
	$(word 2, $^) \
		$< \
		p_value \
		"<= 0.1" \
		> $@

$(csvCormorantsPopulationWithoutSignificance): $(csvCormorantAllGrowthRates) src/select_growth_rates_and_p_values
	$(checkDirectories)
	$(word 2, $^) \
		$< \
		p_value \
		"> 0.1 AND p_value < 0.9" \
		> $@

# V. Reglas phonies
# ===========================================================================

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
	rm --force reports/*.bbl
	rm --force reports/*.blg
	rm --force reports/*.pytxcode
	rm --force reports/*.out
	rm --force reports/*.pdf
	rm --force --recursive reports/tables/
	rm --force --recursive data/processed/
	rm --force --recursive reports/figures/
	rm --force --recursive reports/non-tabular/
	rm --force --recursive reports/pythontex*/
	rm --force --recursive src/__pycache__/

tests:
	pytest tests/test_Population_trend.py