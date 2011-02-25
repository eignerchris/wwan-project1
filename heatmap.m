% Heatmap generator

data = load('sim/heatmap.dat');

xmin = min(data)(1);
xmax = max(data)(1);
ymin = min(data)(2);
ymax = max(data)(2); 

x_values = rot90(data(:,1));
y_values = rot90(data(:,2));
z_values = rot90(data(:,3));

contour(x_values, y_values, z_values); 
axis square;
colorbar;
xlim([xmin xmax]);
ylim([ymin ymax]);

print('heatmap.png', '-dpng')