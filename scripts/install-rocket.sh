#!/bin/bash

cd /tmp
wget https://pypi.python.org/packages/72/5a/efc43e5d8a7ef27205a4c7c4978ebaa812418e2151e7edb26ff3143b29eb/Rocket-1.2.4.zip
unzip Rocket-1.2.4.zip

wget https://pypi.python.org/packages/source/d/distribute/distribute-0.6.13.tar.gz
mkdir ~/.wine/drive_c/Temp/
cp distribute-0.6.13.tar.gz ~/.wine/drive_c/Temp/

perl -i -pe 's!^DEFAULT_URL =.*!DEFAULT_URL = "file:///C:/Temp/"!' Rocket-1.2.4/distribute_setup.py

zip -r Rocket-1.2.4.zip Rocket-1.2.4
wine c:\\Python27\\python.exe c:\\Python27\\Scripts\\pip.exe install Rocket-1.2.4.zip


