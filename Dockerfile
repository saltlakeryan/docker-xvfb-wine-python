FROM ubuntu:14.04

####  Install apt packages
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y x11-apps wget software-properties-common python-software-properties xvfb x11vnc xdotool
RUN apt-get update
RUN apt-get install -y openbox
RUN sudo add-apt-repository -y ppa:ubuntu-wine/ppa
RUN sudo apt-get update
RUN sudo apt-get install -y wine1.7 wine-mono4.5.4 wine-gecko2.21 winetricks

####  Create User
# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

#### Download Assets
ADD scripts/download-assets.sh /tmp/download-assets.sh
RUN /tmp/download-assets.sh

ADD scripts/run.sh /usr/local/bin/run

USER developer
ENV HOME /home/developer
ENV DISPLAY :0
ENV WINEARCH=win32

WORKDIR /tmp

#### Set up wine environment
ADD scripts/run-in-x11.sh /tmp/run-in-x11.sh
ADD scripts/wine-init.sh /tmp/wine-init.sh
RUN /tmp/run-in-x11.sh /tmp/wine-init.sh

#### Set up python in wine
ADD scripts/winetricks.patch /tmp/winetricks.patch
RUN sudo apt-get install -y patch && sudo patch -i winetricks.patch /usr/bin/winetricks

RUN /tmp/run-in-x11.sh winetricks -q python27
#RUN /tmp/run-in-x11.sh wine msiexec /i python-2.7.10.msi TARGETDIR="C:\\Python27" ALLUSERS=1 /qn

RUN wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\easy_install.exe pywin32-219.win32-py2.7.exe

# RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\easy_install.exe psutil-1.2.1.win32-py2.7.exe

RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\pip.exe install jinja2==2.8
RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\pip.exe install flask==0.12
RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\pip.exe install pyinstaller
RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\pip.exe install requests
ADD dependencies/pyHook-1.5.1-cp27-none-win32.whl /tmp/pyHook-1.5.1-cp27-none-win32.whl
RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\pip.exe install pyHook-1.5.1-cp27-none-win32.whl

ADD scripts/install-rocket.sh /tmp/install-rocket.sh
RUN /tmp/install-rocket.sh

RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe C:\\Python27\\Scripts\\pip.exe install pywinauto==0.5.4

ADD scripts/clicker.py /tmp/clicker.py
RUN wget https://pypi.python.org/packages/b4/96/abc8938fa7c9754aebe8e3bfc1ae5bc985141458ec6dbcef4db197eaf2e6/Twisted-15.2.1.win32-py2.7.msi
RUN /tmp/run-in-x11.sh wine msiexec /q /i Twisted-15.2.1.win32-py2.7.msi

RUN wget https://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython3.0-win32-3.0.2.0-py27.exe

ADD scripts/register-python.py /tmp/register-python.py
RUN cd /tmp && /tmp/run-in-x11.sh wine C:\\Python27\\python.exe register-python.py

ADD scripts/wxclicker.py /tmp/wxclicker.py
RUN wine C:\\Python27\\python.exe register-python.py
RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe wxclicker.py wxPython3.0-win32-3.0.2.0-py27.exe

RUN wget https://pypi.python.org/packages/f8/65/4f4ad8e803c97335bf789ad19cc48a4e4b5069d779a50340b3229f24cbff/pyOpenSSL-0.13.winxp32-py2.7.msi
RUN /tmp/run-in-x11.sh wine msiexec /q /i pyOpenSSL-0.13.winxp32-py2.7.msi

RUN wget https://sourceforge.net/projects/nsis/files/NSIS%203/3.01/nsis-3.01-setup.exe
RUN /tmp/run-in-x11.sh wine nsis-3.01-setup.exe /S

ADD dependencies/psutil-1.2.1.win32-py2.7.exe /tmp/psutil-1.2.1.win32-py2.7.exe
ADD scripts/psutilclicker.py /tmp/psutilclicker.py
RUN /tmp/run-in-x11.sh wine C:\\Python27\\python.exe psutilclicker.py psutil-1.2.1.win32-py2.7.exe

RUN cp -r /home/developer/.wine/drive_c/Python2.7/Scripts/* /home/developer/.wine/drive_c/Python27/Scripts/
RUN cp -r /home/developer/.wine/drive_c/Python2.7/Lib/* /home/developer/.wine/drive_c/Python27/Lib/

#docker build -t saltlakeryan/xvfb-wine-python .
#docker run --net=host -it --rm -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/.wine.docker:/home/developer/.wine -v ~/.Xauthority:/home/developer/.Xauthority -u developer xvfb bash
#docker run -it --rm -u developer -p 5900:5900 -v ~/dev/screenlock-package:/lock xvfb bash
