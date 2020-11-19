FROM islasgeci/jupyter:dcc0

RUN pip install --upgrade pip && \
    pip install \
    git+https://github.com/IslasGECI/analytictools.git@8873fce810e4c06937a5e942483e85c0e4896c19 \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql
