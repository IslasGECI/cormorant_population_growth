FROM islasgeci/jupyter:dcc0

WORKDIR /workdir
COPY . .

RUN pip install --upgrade pip && \
    pip install \
    git+https://github.com/IslasGECI/analytictools.git@bf4af5a568534e120fe1228277584226c97e017e \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql

RUN pip install \
    black \
    flake8 \
    mutmut \
    pylint \
    pytest \
    rope
