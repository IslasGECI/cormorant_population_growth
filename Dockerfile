FROM islasgeci/jupyter:5869

RUN pip install --upgrade pip && \
    pip install \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql
