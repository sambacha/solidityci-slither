FROM ubuntu:bionic

LABEL name=slither
LABEL src="https://github.com/trailofbits/slither"
LABEL creator=trailofbits
LABEL dockerfile_maintenance=trailofbits
LABEL desc="Static Analyzer for Solidity"


SHELL ["/bin/bash", "-exo", "pipefail", "-c"]


RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y git python3 python3-setuptools wget curl build-essential zip software-properties-common jq openssh-client sudo libpq-dev unzip 

RUN wget https://github.com/ethereum/solidity/releases/download/v0.5.17/solc-static-linux \
 && chmod +x solc-static-linux \
 && mv solc-static-linux /usr/bin/solc

RUN useradd -m slither && sudo apt update -y -qq
USER slither


COPY --chown=slither:slither . /home/slither/slither
WORKDIR /home/slither/slither

RUN python3 setup.py install --user
ENV PATH="/home/slither/.local/bin:${PATH}"
CMD /bin/bash
