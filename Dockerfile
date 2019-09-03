FROM debian:sid
ENV DISPLAY :0

RUN echo 'deb http://mirrors.kernel.org/debian/ sid main contrib non-free\n\
deb-src http://mirrors.kernel.org/debian/ sid main contrib non-free\n'\
>> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y install git build-essential bison flex cmake libssl-dev
RUN apt-get -y build-dep gstreamer1.0-libav gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly

RUN cd /usr/src && git clone git://anongit.freedesktop.org/git/gstreamer/gstreamer        && cd gstreamer        && ./autogen.sh --disable-gtk-doc && make -j8 install
RUN cd /usr/src && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-base && cd gst-plugins-base && ./autogen.sh --disable-gtk-doc && make -j8 install
RUN cd /usr/src && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-good && cd gst-plugins-good && ./autogen.sh --disable-gtk-doc && make -j8 install
RUN cd /usr/src && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad && cd gst-plugins-bad  && ./autogen.sh --with-hls-crypto=openssl --disable-gtk-doc && make -j8 install
RUN cd /usr/src && git clone git://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly && cd gst-plugins-ugly && ./autogen.sh --disable-gtk-doc && make -j8 install

RUN ldconfig

CMD /bin/bash
