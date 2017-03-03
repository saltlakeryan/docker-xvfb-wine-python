#!/bin/bash

HOME=/home/developer
USER=developer

cd /tmp
wget https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi
wget http://dl.winehq.org/wine/wine-mono/4.5.6/wine-mono-4.5.6.msi
wget http://www.python.org/ftp/python/2.6.2/python-2.6.2.msi -P $HOME/.cache/winetricks/python26
wget http://downloads.sourceforge.net/project/pywin32/pywin32/Build%20214/pywin32-214.win32-py2.6.exe -P $HOME/.cache/winetricks/python26
wget http://www.autohotkey.com/download/AutoHotkey104805.zip -P $HOME/.cache/winetricks/ahk
wget https://downloads.sourceforge.net/project/pywin32/pywin32/Build%20219/pywin32-219.win32-py2.7.exe
wget https://pypi.python.org/packages/5b/7f/9334b57597acabaaf2261c93bb9b1f9f02cdfef5c1b1aa808b262f770adb/psutil-1.2.1.win32-py2.7.exe
wget https://downloads.sourceforge.net/project/pyhook/pyhook/1.5.1/pyHook-1.5.1.zip
wget https://downloads.sourceforge.net/project/pyhook/pyhook/1.5.1/pyHook-1.5.1.win32-py2.7.exe

#psutil-1.2.1.win32-py2.7.exe
#pywin32-219.win32-py2.7.exe
#pyHook-1.5.1-cp27-none-win32.whl

chown -R $USER $HOME

