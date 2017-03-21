#
# script to register Python 2.0 or later for use with 
# Python extensions that require Python registry settings
#
# written by Joakim Loew for Secret Labs AB / PythonWare
#
# source:
# http://www.pythonware.com/products/works/articles/regpy20.htm
#
# modified by Valentine Gogichashvili as described in http://www.mail-archive.com/distutils-sig@python.org/msg10512.html

import sys

from _winreg import *

# tweak as necessary
version = sys.version[:3]
installpath = sys.prefix

regpath = "SOFTWARE\\Python\\Pythoncore\\%s\\" % (version)
installkey = "InstallPath"
pythonkey = "PythonPath"
pythonpath = "%s;%s\\Lib\\;%s\\DLLs\\" % (
    installpath, installpath, installpath
)

def RegisterPy():
    try:
        reg = OpenKey(HKEY_CURRENT_USER, regpath)
    except EnvironmentError as e:
        try:
            reg = CreateKey(HKEY_CURRENT_USER, regpath)
            SetValue(reg, installkey, REG_SZ, installpath)
            SetValue(reg, pythonkey, REG_SZ, pythonpath)
            CloseKey(reg)
        except:
            print "*** Unable to register!"
            return
        print "--- Python", version, "is now registered!"
        return
    if (QueryValue(reg, installkey) == installpath and
        QueryValue(reg, pythonkey) == pythonpath):
        CloseKey(reg)
        print "=== Python", version, "is already registered!"
        return
    CloseKey(reg)
    print "*** Unable to register!"
    print "*** You probably have another Python installation!"

if __name__ == "__main__":
    RegisterPy()

from pywinauto import application, timings
import subprocess, pywinauto, time, os
from pywinauto.SendKeysCtypes import SendKeys

def next_window(app):
    actwin = repeated_check(app, 'Setup - wxPython3.0-py27')
    actwinbutton = repeated_check(actwin, 'Next')
    return actwinbutton

def finish_window(app):
    actwin = repeated_check(app, 'Setup')
    actwinbutton = repeated_check(actwin, 'Finish')
    return actwinbutton

def button_ready(button, name):
    return button.VerifyEnabled()

def repeated_check(app, dialogname):
    return repeated_check_generic(app, dialogname, check_for_dialog)

def repeated_check_generic(dlg, name, callback):
    return timings.WaitUntilPasses(10, 0.5, callback, (pywinauto.findwindows.WindowNotFoundError, pywinauto.findbestmatch.MatchError, pywinauto.controls.HwndWrapper.ControlNotEnabled), dlg, name)

def check_for_dialog(app, dialogname):
    print "check for dialog called: ", dialogname
    print "app: ", app
    return app[dialogname]

def check_button(app, buttonname):
    return app[buttonname].VerifyEnabled()

def main():
    #subprocess.call(["Twisted-15.2.1.win32-py2.7.exe"])
    exe_file = sys.argv[1]
    app = application.Application()
    appname = os.path.join(os.getcwd(), exe_file)
    print(appname)
    app.start_(appname)
    #app.start(appname)

    print("Sleeping for 2 seconds")
    time.sleep(2)
    print("Step 1")
    first = next_window(app)

    SendKeys('{ENTER}')
    time.sleep(2)

    print("Step 2")
    second = next_window(app)
    SendKeys('%a')
    time.sleep(1)
    SendKeys('{SPACE}')
    time.sleep(1)
    SendKeys('{ENTER}')
    time.sleep(1)

    print("Step 3")
    third = next_window(app)
    time.sleep(1)
    SendKeys('{ENTER}')
    time.sleep(1)

    print("Step 4")
    third = next_window(app)
    time.sleep(1)
    SendKeys('{ENTER}')
    time.sleep(1)

    time.sleep(12)
    print("Step 5")
    finish = finish_window(app)
    time.sleep(1)
    SendKeys('{ENTER}')
    time.sleep(1)
    time.sleep(1)
    SendKeys('{ENTER}')
    time.sleep(1)

main()
