FROM islasgeci/jupyter:5869

RUN pip install --upgrade pip && \
    pip install \
    git+https://github.com/IslasGECI/analytictools.git@88969455c0a318931999277cfebab34fb614a60d \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql
