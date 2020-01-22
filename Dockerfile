FROM islasgeci/jupyter:8e52

RUN pip install --upgrade pip && \
    pip install \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql
