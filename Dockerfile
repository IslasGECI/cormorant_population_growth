FROM islasgeci/jupyter:dcc0

RUN pip install --upgrade pip && \
    pip install \
    git+https://github.com/IslasGECI/analytictools.git@051176ee335cf463b300899f1089761f0294c0a3 \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql
