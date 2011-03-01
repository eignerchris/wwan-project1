#set palette rgbformulae 21,22,23
set palette defined (0 "blue", 1 "green", 2 "orange", 3 "red", 4 "white" )
set pm3d map
#set cbrange [-20: 150]
splot '<awk -f colorpts.awk heatmap.dat 75 75'
set terminal png
set output 'tmp.png'
replot