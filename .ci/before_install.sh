#!/bin/bash

if [ ! -d "$HOME/miniconda" ]; then
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -f -p $HOME/miniconda
    export PATH="$HOME/miniconda/bin:$PATH"
    hash -r
    conda config --set always_yes yes --set changeps1 no
    conda update -q conda
    conda info -a
fi

testenv=testenv$TRAVIS_PYTHON_VERSION
hasenv=`conda env list | grep $testenv`
requirements=`cat requirements.txt | tr '\n' ' ' | sed 's/pyhmsa//g' | sed 's/qtpy//g'`

if [ -n "$hasenv" ]; then
    conda create -q -n $testenv python=$TRAVIS_PYTHON_VERSION
fi

source activate $testenv
conda install $requirements
pip install qtpy pyhmsa
pip list
conda list