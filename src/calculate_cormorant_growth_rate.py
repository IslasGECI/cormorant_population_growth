# calculate_cormorant_growth_rate calcula la tasa de crecimiento fundamental (lambda)
# utilizando un model de una ley de potencia a los datos de cantidad de nidos de cormoran orejon en Isla Alcatraz
from cli_paths import path_files
from geci_plots import *
from bootstraping_tools import *
from population_growth import *

import os
import pandas as pd

interest_variable = "Nidos_activos_por_visita"
lambdas_results = []

path = path_files()
data_path = path.input[0][0]
latex_table = path.output[0][0]

cormorant_data = pd.read_csv(data_path)
cormorant_data = cormorant_data.dropna(subset=[interest_variable])


for islet in cormorant_data.Isla.unique():
    fit_data = filter_data_by_islet(cormorant_data, islet)

    lambdas_distribution, intervals = bootstrap_from_time_series(
        fit_data,
        interest_variable,
        N=20,
        return_distribution=True,
        remove_outliers=True,
    )

    lambda_latex = generate_latex_interval_string(intervals)
    lambdas_distribution = pd.DataFrame({"Tasa de crecimiento": lambdas_distribution})
    p_value_mayor, p_value_menor = calculate_p_values(lambdas_distribution)
    lambdas_results.append([islet, lambda_latex, p_value_mayor, p_value_menor])

    Modelo_Tendencia_Poblacional = Population_Trend_Model(fit_data, intervals, interest_variable)
    Graficador = Plotter_Population_Trend_Model()
    Graficador.plot_smooth(Modelo_Tendencia_Poblacional)
    Graficador.plot_model(Modelo_Tendencia_Poblacional)
    Graficador.plot_data(Modelo_Tendencia_Poblacional, fit_data[interest_variable])
    legend_mpl_object = Graficador.set_legend_location(islet)
    Graficador.set_x_lim(Modelo_Tendencia_Poblacional)
    Graficador.set_y_lim(fit_data[interest_variable])
    Graficador.set_labels()
    Graficador.set_ticks(Modelo_Tendencia_Poblacional)
    Graficador.draw()
    Graficador.plot_growth_rate_interval(legend_mpl_object, lambda_latex)
    Graficador.savefig(islet)

lambdas_table = pd.DataFrame(lambdas_results)
lambdas_table.columns = ["Islet", "Growth_rate", "p_value", "p_value_menor"]

if not os.path.exists("reports/tables"):
    os.makedirs("reports/tables")

lambdas_table.round(decimals=3).to_csv(latex_table, index=False)
