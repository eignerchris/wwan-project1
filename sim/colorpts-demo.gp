#set pal gray
#set pal color
set palette rgbformulae 21,22,23
set pm3d map
splot '<awk -f colorpts.awk heatmap.dat 75 75'
