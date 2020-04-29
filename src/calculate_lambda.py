import numpy as np
from scipy.optimize import curve_fit

def power_law(T, Lambda, No):
    return No * np.power(Lambda, T)

max_iter=2000
lower_bounds = 0
lambda_upper_bound = 50

def calculate_lambda(seasons, burrows_max):
    seasons = np.array(seasons)
    index = seasons - seasons[0]
    burrows_max = np.array(burrows_max)
    popt, pcov = curve_fit(power_law, index, burrows_max, maxfev = max_iter, bounds=((lower_bounds,lower_bounds),(lambda_upper_bound,np.inf)))
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
        fitting_result=calculate_lambda(resampled_data['Temporada'],resampled_data['Maxima_cantidad_nidos'])
        lambdas_bootstraps.append(fitting_result[0])
    lambdas_bootstraps = remove_distribution_outliers(lambdas_bootstraps)
    normal_fit = calculate_lambda(dataframe['Temporada'],dataframe['Maxima_cantidad_nidos'])
    return np.percentile(lambdas_bootstraps,[2.5,50,97.5]), normal_fit, lambdas_bootstraps

def calculate_p_values(distribution):
    distribution=np.array(distribution)
    mask = (distribution < 1)
    mask2 = (distribution > 1)
    return mask.sum()/len(distribution),mask2.sum()/len(distribution)