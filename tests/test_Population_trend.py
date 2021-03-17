from population_growth import Population_trend
import pytest
import pandas as pd


cormorant_data = pd.read_csv("tests/data_tests/conteo_nidos_cormoran_test.csv")
def test_method__init__():
    Population_trend()


