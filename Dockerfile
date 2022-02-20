# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

FROM python:3.10.0b3

ARG access_key

USER root
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
&& python get-pip.py \
&& pip install awscli

RUN aws --version

RUN echo $access_key



# Retrieve the arguments passed from the docker build command
ARG CODEARTIFACT_TOKEN
ARG DOMAIN
ARG REGION
ARG REPO

copy /root/.aws /root/.aws

#Manually configure the PIP client with the authenthication token
RUN pip config set global.index-url "https://aws:$CODEARTIFACT_TOKEN@$DOMAIN.d.codeartifact.$REGION.amazonaws.com/pypi/$REPO/simple/"
RUN pip install -r requirements.txt

CMD ["python","application.py"]
