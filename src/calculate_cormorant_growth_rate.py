#!/usr/bin/env python
#
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


def plot_growth_rate_interval(legend_mpl_object, lambda_latex):
    legend_box_positions = legend_mpl_object.get_window_extent()
    ax.annotate(
        r"$\lambda =$ {}".format(lambda_latex),
        (legend_box_positions.p0[0], legend_box_positions.p1[1] - 320),
        xycoords="figure pixels",
        fontsize=25,
        color="k",
        alpha=1,
    )


def set_labels():
    plt.ylabel("Number of breeding pairs", size=20)
    plt.xlabel("Seasons", size=20)


def set_ticks(Population_Trend_Model):
    plt.xticks(
        Population_Trend_Model.ticks_positions,
        Population_Trend_Model.ticks_text,
        rotation=90,
        size=20,
    )
    plt.yticks(size=20)


def set_legend_location(islet):
    legend_mpl_object = plt.legend(loc="best")
    if islet == "Natividad":
        legend_mpl_object = plt.legend(loc="upper left")
    return legend_mpl_object


def calculate_upper_limit(data_interest_variable):
    upper_limit = roundup(
        data_interest_variable.max() * 1.2,
        10 ** order_magnitude(data_interest_variable),
    )
    return upper_limit


class Population_Trend_Model:
    def __init__(self, fit_data, intervals, interest_variable):
        self.intervals = intervals
        self.plot_seasons = fit_data["Temporada"][:] - fit_data["Temporada"].iloc[0] + 1
        self.ticks_text = resample_seasons(fit_data)
        self.ticks_positions = ticks_positions_array(self.ticks_text)
        self.time_to_model = np.linspace(
            self.ticks_positions.min(), self.ticks_positions.max(), 100
        )
        self.parameters = lambda_calculator(fit_data["Temporada"], fit_data[interest_variable])[1]

    @property
    def model_min(self):
        return power_law(self.time_to_model, self.intervals[0], self.parameters)

    @property
    def model_med(self):
        return power_law(self.time_to_model, self.intervals[1], self.parameters)

    @property
    def model_max(self):
        return power_law(self.time_to_model, self.intervals[2], self.parameters)


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

    fig, ax = geci_plot()
    ax.fill_between(
        Modelo_Tendencia_Poblacional.time_to_model,
        Modelo_Tendencia_Poblacional.model_min,
        Modelo_Tendencia_Poblacional.model_max,
        alpha=0.2,
        label="Confidence zone",
        color="b",
    )
    plt.plot(
        Modelo_Tendencia_Poblacional.time_to_model,
        Modelo_Tendencia_Poblacional.model_med,
        label="Population growth model",
        color="b",
    )
    plt.plot(
        Modelo_Tendencia_Poblacional.plot_seasons,
        fit_data[interest_variable],
        "-Dk",
        label="Active Nests",
    )
    legend_mpl_object = set_legend_location(islet)
    plt.xlim(
        Modelo_Tendencia_Poblacional.ticks_positions.min() - 0.2,
        Modelo_Tendencia_Poblacional.ticks_positions.max(),
    )
    ax.set_ylim(
        0,
        calculate_upper_limit(fit_data[interest_variable]),
    )
    set_labels()
    set_ticks(Modelo_Tendencia_Poblacional)
    plt.gcf().subplots_adjust(bottom=0.2)
    plt.draw()
    plot_growth_rate_interval(legend_mpl_object, lambda_latex)

    plt.savefig(
        "reports/figures/cormorant_population_trend_{}".format(islet.replace(" ", "_").lower()),
        dpi=300,
    )

lambdas_table = pd.DataFrame(lambdas_results)
lambdas_table.columns = ["Islet", "Growth_rate", "p_value", "p_value_menor"]

if not os.path.exists("reports/tables"):
    os.makedirs("reports/tables")

lambdas_table.round(decimals=3).to_csv(latex_table, index=False)
