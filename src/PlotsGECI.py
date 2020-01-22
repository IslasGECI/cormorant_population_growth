#!/usr/bin/env python

import matplotlib.pyplot as plt

def GECI_Plot():
    fig, ax = plt.subplots(figsize=(11, 8))
    ax.spines['right'].set_visible(False)
    ax.spines['top'].set_visible(False)
    plt.yticks(rotation=90,size = 12)
    return fig, ax
