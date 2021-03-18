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
