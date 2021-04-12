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

.PHONY: all check clean mutants tests

# II. Declaración de las variables
# ===========================================================================
# Variables a resultados

csvConteoNidosCormoranOrejon = \
	data/raw/conteo_nidos_cormoran_todas_islas.csv

csvCormorantMaximumNests = \
	data/processed/cormorant_all_islets_data.csv

csvCormorantCleanData = \
	data/processed/cormorant_all_islets_clean_data.csv

csvCormorantSeasonInterval = \
	data/processed/cormoran_season_interval.csv

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
	reports/figures/cormorant_population_trend_todos_santos.png \
	reports/figures/cormorant_population_trend_coronado_norte.png \
	reports/figures/cormorant_population_trend_coronado_sur.png

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
		sql/max_nest_quantity.sql \
		> $@

$(csvCormorantCleanData): $(csvCormorantMaximumNests) src/query_burrows_quantity_data
	$(checkDirectories)
	$(word 2, $^) \
		--input $< \
		--output $(csvCormorantCleanData)

$(pngPopulationGrowRateCormorantAllIslets) $(csvCormorantAllGrowthRates): $(csvCormorantCleanData) src/calculate_cormorant_growth_rate
	$(checkDirectories)
	mkdir reports/tables # 💩 TODO: src/calculate_cormorant_growth_rate tiene más de una responsabilidad; hay que partirlo en una parte para las figuras y otra para la tabla.
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

$(csvCormorantSeasonInterval): $(csvConteoNidosCormoranOrejon) src/query_get_season_interval
	$(checkDirectories)
	$(word 2, $^) \
		$< \
		> $@

# V. Reglas phonies
# ===========================================================================

#=============================================================================
# V. Reglas del resto de los phonies
# ===========================================================================
# Elimina los residuos de LaTeX

.PHONY: \
		check \
		clean \
		coverage \
		format \
		mutants \
		set_tests \
		tests

check:
	black --check --line-length 100 population_growth
	black --check --line-length 100 src
	black --check --line-length 100 tests
	flake8 --max-line-length 100 population_growth
	flake8 --max-line-length 100 src
	flake8 --max-line-length 100 tests

clean:
	rm --force --recursive data/processed/
	rm --force --recursive population_growth/__pycache__/
	rm --force --recursive reports/figures/
	rm --force --recursive reports/non-tabular/
	rm --force --recursive reports/pythontex*/
	rm --force --recursive reports/tables/
	rm --force --recursive src/__pycache__/
	rm --force --recursive tests/__pycache__/
	rm --force .mutmut-cache
	rm --force reports/*.aux
	rm --force reports/*.bbl
	rm --force reports/*.blg
	rm --force reports/*.dvi
	rm --force reports/*.fdb_latexmk
	rm --force reports/*.fls
	rm --force reports/*.log
	rm --force reports/*.out
	rm --force reports/*.pdf
	rm --force reports/*.pytxcode

coverage: set_tests
	pytest --mpl --verbose

format:
	black --line-length 100 population_growth
	black --line-length 100 src
	black --line-length 100 tests

mutants: set_tests
	mutmut run --paths-to-mutate population_growth --runner 'pytest --mpl'
	mutmut run --paths-to-mutate src --runner 'shellspec'

set_tests:
	mkdir --parents tests/baseline
	pytest --mpl-generate-path tests/baseline/

tests:
	pytest --mpl --verbose
