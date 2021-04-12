FROM islasgeci/base:dc92

COPY . .

RUN pip install --upgrade pip && pip install \
    git+https://github.com/IslasGECI/analytictools.git@29ecd2646109cdfb11638ad5fee7e7457a442e9c \
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

RUN git clone --branch feature/Agrega_funcionalidad_a_query https://github.com/IslasGECI/queries.git && \
    cd queries && \
    make install

RUN curl -fsSL https://git.io/shellspec | sh -s -- --yes
ENV PATH="/root/.local/lib/shellspec:$PATH"
RUN shellspec --init
