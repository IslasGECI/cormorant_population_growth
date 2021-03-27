FROM islasgeci/jupyter:dcc0

WORKDIR /workdir
COPY . .

RUN pip install --upgrade pip && pip install \
    git+https://github.com/IslasGECI/analytictools.git@29ecd2646109cdfb11638ad5fee7e7457a442e9c \
    git+https://github.com/IslasGECI/descarga_datos.git@v0.1.0-beta \
    pandasql

RUN pip install \
    . \
    black \
    flake8 \
    mutmut \
    pylint \
    pytest \
    pytest-mpl \
    rope

RUN git clone https://github.com/IslasGECI/queries.git && \
    cd queries && \
    git reset --hard 544f891035d424dd80f333b00f42da0c0914aebb && \
    make install && \
    cd ..

RUN curl -fsSL https://git.io/shellspec | sh -s -- --yes
ENV PATH="/home/jovyan/.local/lib/shellspec:$PATH"
RUN shellspec --init
