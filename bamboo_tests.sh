#!/bin/bash

mkdir -p tmp
/opt/python-2.7.9/bin/python /mnt/software/v/virtualenv/13.0.1/virtualenv.py tmp/venv
source tmp/venv/bin/activate

pip install nose
pip install cram
(cd repos/pbcommand && make install)

make misc-tests
