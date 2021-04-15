FROM islasgeci/base:dc92
COPY . .

# Install modules with pip
RUN pip install --upgrade pip && pip install \
    . \
    black \
    flake8 \
    git+https://github.com/IslasGECI/analytictools.git@29ecd2646109cdfb11638ad5fee7e7457a442e9c \
    mutmut \
    pandasql \
    pylint \
    pytest \
    pytest-mpl \
    rope \
    tqdm

# IslasGECI/queries
RUN git clone --depth 1 --branch feature/Agrega_funcionalidad_a_query https://github.com/IslasGECI/queries.git && \
    cd queries && \
    make install

# ShellSpec
RUN curl -fsSL https://git.io/shellspec | sh -s -- --yes
ENV PATH="/root/.local/lib/shellspec:$PATH"
RUN shellspec --init
