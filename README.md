# Dockerfile for building GStreamer with RIST support

[RIST](https://www.rist.tv/) (Reliable Internet Stream Transport) is a new protocol for transporting live video over unmanaged networks.

Several vendors have implemented RIST on their products.  There is also an open source [implementation](https://www.collabora.com/news-and-blog/news-and-events/gstreamer-support-for-the-rist-specification.html) as part of [GStreamer](https://gstreamer.freedesktop.org/) framework.

Current latest version(1.16) of GStreamer doesn't include RIST yet. (2019.09)

Building GStreamer from source files is not easy. This Dockerfile will download the latest GStreamer source files and build it for you. It will include RIST filters.

The docker-compose file will create two containers.
 - sender - receive MPEG-2 TS UDP video stream and send it out via RIST.
 - receiver - receive RIST video stream and send it out via MPEG-2 TS UDP

## Example with ffmpeg low latency mode
1. Install ffmpeg
```sh
$ brew install ffmpeg
```
2. Create ffmpeg low latency preset
```sh
mkdir ~/.ffmpeg
vi ~/.ffmpeg/lowlatency.ffpreset
vcodec=libx264
thread_type=slice
slices=1
# x264
profile=baseline
level=32
preset=superfast
tune=zerolatency
crf=15
x264-params=vbv-maxrate=5000:vbv-bufsize=1:slice-max-size=1500:keyint=60
acodec=aac
```

2. Run ffplay
```sh
$ ffplay -fflags nobuffer -flags low_delay -framedrop -strict experimental udp://0.0.0.0:5005
```

3. Run RIST containers
```sh
$ docker-compose up
```

4. Run ffmpeg
```sh
$ ffmpeg -re -f lavfi -i testsrc=size=1280x720:rate=30 -f lavfi -i sine -vf drawtext="text='%{localtime\:%X}':fontsize=20:fontcolor=white:x=7:y=7" -pix_fmt yuv420p -an -vpre lowlatency -f mpegts udp://127.0.0.1:5004?pkt_size=1316
```