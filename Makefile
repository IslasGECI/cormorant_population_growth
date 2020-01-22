# I. Definición del _phony_ *all* que enlista todos los objetivos principales
# ===========================================================================
all: reports/tendencia_poblacional_cormoran_alcatraz.pdf

define renderLatex
cd $(<D) && pdflatex $(<F)
cd $(<D) && pdflatex $(<F)
endef

#============================================================================
# Reporte de lambda de cormorán orejon
# II. Declaración de las variables
# ===========================================================================
# Variables a resultados

csvConteoNidosCormoranOrejonAlcatraz = \
	data/raw/conteo_nidos_cormoran_isla_alcatraz.csv

jsonLambdaCormorantAlcatraz = \
	reports/non-tabular/jsonLambdaCormorantAlcatraz.json

pngPopulationGrowRateCormorant = \
	reports/figures/pngPopulationGrowRateCormorant.png

# III. Reglas para construir los objetivos principales
# ===========================================================================

reports/tendencia_poblacional_cormoran_alcatraz.pdf: reports/tendencia_poblacional_cormoran_alcatraz.tex $(jsonLambdaCormorantAlcatraz) $(pngPopulationGrowRateCormorant)
	cd $(<D) && pdflatex $(<F)
	cd $(<D) && pythontex $(<F)
	cd $(<D) && pdflatex $(<F)

# IV. Reglas para construir las dependencias de los objetivos principales
# ==========================================================================

$(pngPopulationGrowRateCormorant) $(jsonLambdaCormorantAlcatraz): $(csvConteoNidosCormoranOrejonAlcatraz) src/cormorantGrowRateAlcatraz
	if [ ! -d $(@D) ]; then mkdir --parents $(@D); fi
	src/cormorantGrowRateAlcatraz --entrada $< \
	--salida reports/non-tabular/jsonLambdaCormorantAlcatraz.json \
	--salida reports/figures/pngPopulationGrowRateCormorant.png

# V. Reglas phonies
# ===========================================================================

$(csvConteoNidosCormoranOrejonAlcatraz):
	if [ ! -d $(@D) ]; then mkdir --parents $(@D); fi
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
