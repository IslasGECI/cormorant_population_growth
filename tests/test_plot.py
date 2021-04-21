import pytest
from unittest.mock import Mock

from population_growth import Population_Trend_Model, Plotter_Population_Trend_Model


@pytest.mark.mpl_image_compare
def tests_Plotter_Population_Trend_Model():
    model = Mock(spec=Population_Trend_Model)
    model.time_to_model = [1, 3]
    model.model_med = [1, 3]
    Plotter = Plotter_Population_Trend_Model()
    Plotter.set_labels()
    return Plotter.plot_model(model)
