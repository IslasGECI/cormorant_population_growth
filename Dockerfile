FROM islasgeci/base:0.7.0
RUN pip install --upgrade pip && pip install \
    pandasql
