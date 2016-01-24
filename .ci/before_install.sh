#!/bin/bash

set -e

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -f -p $HOME/miniconda
export PATH="$HOME/miniconda/bin:$PATH"
hash -r
conda config --set always_yes yes --set changeps1 no
conda update -q conda

# Echo info about conda
conda info -a
conda env list

# Setup variables
testenv=testenv$PYTHON_VERSION
echo "Test environment: $testenv"

conda env list | grep "$testenv"
hasenv=`conda env list | grep "testenv3.4"`
echo "Has environment: $hasenv"

requirements=`cat requirements.txt | tr '\n' ' ' | sed 's/pyhmsa//g' | sed 's/qtpy//g'`
echo "Conda requirements: $requirements"

if [ -n "$hasenv" ]; then
    conda create -q -n $testenv python=$PYTHON_VERSION
    echo "Conda environment $testenv created"
fi

source activate $testenv
conda install $requirements
pip install qtpy pyhmsa
pip list
conda list