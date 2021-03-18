import numpy as np

def filter_data_by_islet(df, islet):
    return df[df.Isla == islet]


def resample_seasons(df):
    first_season = int(df.Temporada.min())
    last_season = int(df.Temporada.max())
    return np.linspace(first_season, last_season, last_season-first_season+ 1).astype(int)
    
