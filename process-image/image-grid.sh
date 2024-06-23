#!/bin/bash

# Take images whose filenames end with -1.png, -2.png, -3.png, and -4.png in cd and turn into 2x2 grid (png)
montage *-1.png *-2.png *-3.png *-4.png -geometry +0+0 -tile 2x2 grid-2x2.png