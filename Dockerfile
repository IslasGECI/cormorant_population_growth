FROM islasgeci/jupyter:dcc0

WORKDIR /workdir
COPY . .

RUN pip install --upgrade pip && \
    pip install \
    git+https://github.com/IslasGECI/analytictools.git@5633bbfa7fbc0fc40aa50067a71092602b817789 \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql

RUN pip install \
    black \
    flake8 \
    pylint \
    pytest \
    rope
