#!/usr/bin/env python
#
# query_burrows_quantity_data limpia la base de datos de especies con menos de 3 temporadas

import pandas as pd

from cli_paths import path_files

path = path_files()

data_path = path.input[0][0]
output_file = path.output[0][0]

burrows_data = pd.read_csv(data_path)
data_cut = burrows_data.copy()

drop_data = burrows_data[burrows_data.Notas == "No usar"]
data_cut = data_cut.drop(drop_data.index)

for isla, _ in burrows_data.groupby(by="Isla"):
    data_per_island = burrows_data[burrows_data.Isla == isla]
    if len(data_per_island) < 3:
        data_cut = data_cut.drop(data_per_island.index)

data_cut.to_csv(output_file, index=False)
