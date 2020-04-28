#!/usr/bin/env python
import matplotlib

matplotlib.use('Agg')
matplotlib.rcParams['figure.dpi'] = 300

matplotlib.rcParams['mathtext.fontset'] = 'stix'
matplotlib.rcParams['font.family'] = 'STIXGeneral'

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MaxNLocator

def roundup(x,multiplo):
    return np.ceil(x / multiplo) * multiplo

def GECI_Plot():
    fig, ax = plt.subplots(figsize=(11, 8))
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    plt.yticks(rotation=90,size = 12)
    return fig, ax

islet_markers = {
    "Asuncion": "o",
    "Coronado": "^",
    "Guadalupe - Solo islotes": "s",
    "Guadalupe - Con islotes": "s",
    "Guadalupe - Sin islotes": "X",
    "Natividad": "p",
    "San Benito": "h",
    "San Jeronimo": "D",
    "San Martin": "P",
    "San Roque": "*",
    "Todos Santos": ">",
}

islet_colors = {
    "Asuncion": "black",
    "Coronado": "red",
    "Guadalupe - Solo islotes": "peru",
    "Guadalupe - Con islotes": "peru",
    "Guadalupe - Sin islotes": "gold",
    "Natividad": "green",
    "San Benito": "blue",
    "San Jeronimo": "purple",
    "San Martin": "hotpink",
    "San Roque": "lightgreen",
    "Todos Santos": "skyblue",
}