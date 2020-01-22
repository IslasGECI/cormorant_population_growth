from scipy.optimize import curve_fit
import numpy as np


def ley_potencia(T, Lambda, No):
    return No * np.power(Lambda, T)

def calcula_lambda(temporadas, maximo_nidos):
    temporadas = np.array(temporadas)
    numero_agno = temporadas - temporadas[0]
    maximo_nidos = np.array(maximo_nidos)
    popt, pcov = curve_fit(ley_potencia, numero_agno.astype('float64'), maximo_nidos.astype('float64'))
    return popt
