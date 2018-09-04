```
[pi@avengers-tower, load: 0.08] (Tue Aug 14 - 03:54:25)
~/jhbuild/modulesets $ jhbuild sysdeps --install meta-scarlett-world-deps
W: meta-scarlett-world-deps has a dependency on unknown "gstreamer" module
W: meta-scarlett-world-deps has a dependency on unknown "gst-libav" module
W: gst-plugins-bad has a dependency on unknown "gstreamer" module
W: gst-plugins-base has a dependency on unknown "gstreamer" module
W: gtk+-3 has a dependency on unknown "atk" module
W: pango has a dependency on unknown "harfbuzz" module
W: gtk+-3 has a dependency on unknown "at-spi2-atk" module
W: gtk+-3 has a dependency on unknown "libxkbcommon" module
W: gst-plugins-bad has a dependency on unknown "graphene" module
W: gst-plugins-good has a dependency on unknown "gstreamer" module
W: gst-plugins-good has a dependency on unknown "pulseaudio" module
W: meta-scarlett-world-deps has a dependency on unknown "gst-plugins-ugly" module
W: meta-scarlett-world-deps has a dependency on unknown "gst-python" module
W: meta-scarlett-world-deps has a dependency on unknown "pycairo" module
```


```
*** Error during phase configure of pycairo: ########## Error running /home/developer/gnome/pycairo-1.8.2/configure --prefix /home/developer/jhbuild --disable-Werror  --disable-static --disable-gtk-doc  *** [32/32]
*** the following modules were not built *** [32/32]
gstreamer fribidi pango at-spi2-atk gtk+-3 libgudev gst-plugins-base gst-libav graphene gst-plugins-bad gst-plugins-good gst-plugins-ugly gst-python pycairo
developer@774c17ee4734:~/app$
```
