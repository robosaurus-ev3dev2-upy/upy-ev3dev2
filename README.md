# upy-ev3dev2
Main repo to contain submodules of other repos, as well as build scripts

The purpose of this "Orgnization" is to improve ev3dev2 running in Micropython.

ev3dev2 provides Python environment on Lego EV3, which would something the kids in our FLL team (Robosaurus) would like to explore.

However, python3 starts so so so so so so slow, which makes the environment not suitable for using during FLL competetion.
Fortunately there is also Micropython. So far ev3dev2 running in Micropython supports most of the sensors and motors on EV3, with the exception of LEDs, buttons, sound, and diplay.

Buttons would be pretty useful during the robot game so we do need them.
LEDs is pretty easy to fix so I just did it.
Sound is interesting to the kids. Especially the ability of calling espeak from the python program makes the kids a lot more interested in programming. So would like to have it.
Display is good, but looks like a little bit too complicated for now. Will postpone it.

As a coach of the FLL team, I would like to have the kids to do things. However, this I guess is too hard for a bunch of 10-year-olds. So I am going to help. :)

The changes are mostly in micropython-lib for low level supports. There is only one C module used, because I am too lazy to re-structure the structs and IOCTL numbers from C file to Python. So this requires a special built Micropython itself. I cherry-picked the changes from https://github.com/stinos/micropython/tree/windows-pyd so Micropython can load .so file as dynamical module. If I have the time and patience I may try to re-impelement the C file in Python and get rid of the requirments of special built Micropython.

My main goal is to make things run on LEGO EV3. And I am not an experience Python programmer at all, so I cannot guarentee the code I implemented in Micropython fully compliant with the function descriptions in CPython. I have only tested against the ev3dev2 stuff. So I am not persuing merging my changes into the mainlines in foreseeable future.

And you can see, this is just an experiment project. Everything is subject to change and please backup your work before you try this on your ev3dev SD card. :)

And I am not familiar with debian packaging stuff, so I am not going to try that. I will just describe the steps of building my stuff from source.

You can build this directly on your EV3. In the terminal:
```
    1. git clone --recursive https://github.com/robosaurus-ev3dev2-upy/upy-ev3dev2.git
    2. cd upy-ev3dev2
    3. sudo ./setup.sh
    4. make upy
    5. sudo make install_upy
    6. make libs
    7. sudo make install_libs
```
And you are done.

Step 4 of building micropython takes very long time on EV3 (more than an hour). So please be patient. Fortunately you only need to do that once. :)

Alternatively you can build micropython in ev3dev cross compile Docker environment (https://www.ev3dev.org/docs/tutorials/using-docker-to-cross-compile/). You need to do step 1 to 4 in the Docker environment (with CROSS_COMPILE=arm-linux-gnueabi- and CC=arm-linux-gnueabi-gcc), and manually replace /usr/bin/mpy-cross and /usr/bin/micropython on EV3 with the ones you built.
Then you can skip step 4 and 5 on EV3.
     
    

