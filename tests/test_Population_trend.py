from population_growth import *
import pytest
import pandas as pd
import numpy as np
from pandas._testing import assert_frame_equal


cormorant_data = pd.DataFrame({"Isla": ["a", "a", "b"], "Temporada": [2020, 2021, 2020]})
expected_data = pd.DataFrame({"Isla": ["a", "a"], "Temporada": [2020, 2021]})


def test_filter_data_by_islet():
    obtained_data = filter_data_by_islet(cormorant_data, "a")
    assert_frame_equal(expected_data, obtained_data)


def test_resample_seasons():
    expected_date = np.array([2020, 2021])
    obtained_date = resample_seasons(cormorant_data)
    np.testing.assert_array_equal(expected_date, obtained_date)


def tests_calculate_upper_limit():
    expected_limit = calculate_upper_limit(cormorant_data["Temporada"])
    obtained_limit = 3000
    assert expected_limit == obtained_limit
    

Plotter = Plotter_Population_Trend_Model()
class Tests_Plotter_Population_Trend_Model():
    def tests_init_(self):
        fig, ax = geci_plot()
        assert type(fig) == type(Plotter.fig)

Model = Population_Trend_Model(cormorant_data, [1, 2, 3], "Temporada")
class Test_Population_Trend_Model():

    def test_ticks_text(self):
        assert (Model.ticks_text == np.array([2020, 2021])).all()