import pytest
import numpy as np
from unittest.mock import Mock

from population_growth import *

@pytest.mark.mpl_image_compare
def tests_Plotter_Population_Trend_Model():
    model = Mock()
    model.time_to_model = [1,3]
    model.model_med = [1,3]
    Plotter = Plotter_Population_Trend_Model()
    Plotter.set_labels()
    return Plotter.plot_model(model)