import numpy as np
from scipy.optimize import curve_fit

def ley_potencia(T, Lambda, No):
    return No * np.power(Lambda, T)

def calcula_lambda(temporadas, maximo_nidos):
    temporadas = np.array(temporadas)
    numero_agno = temporadas - temporadas[0]
    maximo_nidos = np.array(maximo_nidos)
    popt, pcov = curve_fit(ley_potencia, numero_agno, maximo_nidos, maxfev = 2000, bounds=((0,0),(50,np.inf)))
    return popt

def remove_distribution_outliers(data):
    data=np.array(data)
    mean=np.mean(data)
    std=np.std(data)
    mask = (abs(data-mean) < std*5)
    return data[mask]

def bootstrap_fitting(dataframe):
    lambdas_bootstraps = []
    for i in range(2000):
        resampled_data=dataframe.sample(n=len(dataframe),replace=True,random_state=i).sort_index()
        fitting_result=calcula_lambda(resampled_data['Temporada'],resampled_data['Maxima_cantidad_nidos'])
        lambdas_bootstraps.append(fitting_result[0])
    lambdas_bootstraps = remove_distribution_outliers(lambdas_bootstraps)
    normal_fit = calcula_lambda(dataframe['Temporada'],dataframe['Maxima_cantidad_nidos'])
    return np.percentile(lambdas_bootstraps,[2.5,50,97.5]), normal_fit, lambdas_bootstraps

def calculate_p_values(distribution):
    distribution=np.array(distribution)
    mask = (distribution < 1)
    mask2 = (distribution > 1)
    return mask.sum()/len(distribution),mask2.sum()/len(distribution)