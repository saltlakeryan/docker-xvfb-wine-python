from pywinauto import application, timings
import subprocess, pywinauto, time, os, sys

def next_window(app):
    actwin = repeated_check(app, 'Setup')
    actwinbutton = repeated_check(actwin, 'Next')
    repeated_check_generic(actwinbutton, 'Next', button_ready)
    return actwin

def finish_window(app):
    actwin = repeated_check(app, 'Setup')
    actwinbutton = repeated_check(actwin, 'Finish')
    repeated_check_generic(actwinbutton, 'Finish', button_ready)
    return actwin

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
    first['Next'].Click()
    time.sleep(2)

    print("Step 2")
    second = next_window(app)
    second['Next'].Click()
    time.sleep(2)

    print("Step 3")
    third = next_window(app)
    third['Next'].Click()
    time.sleep(6)

    print("Step 4")
    finish = finish_window(app)
    finish['Finish'].Click()

main()
