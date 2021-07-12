FROM islasgeci/base:0.7.0
COPY . .
# Install modules with pip
RUN pip install --upgrade pip && pip install \
    . \
    black \
    flake8 \
    mutmut \
    pandasql \
    pylint \
    pytest \
    pytest-mpl \
    rope \
    tqdm
# ShellSpec
RUN curl -fsSL https://git.io/shellspec | sh -s -- --yes
ENV PATH="/root/.local/lib/shellspec:$PATH"
RUN shellspec --init
