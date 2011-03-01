# Cell Site Simulator #

## Overview ##

The following is a cell site simulator. Given 4 input parameters, it constructs a grid, made up of 3 sectors, and calculates CINRS at each point throughout the cell. Next it initalizes the cell with 75 clients (25 in each sector) at points on the grid. Transmitter power, first and second-tier interferers, block size, and target block error rate are factored into a modulation coding scheme decision and a bit rate for that client is calculated. 

The simulator possesses the ability to generate heatmaps if so desired via a datadump to heatmap.dat. A gnuplots script that then be run against the datafile that will generate a very pretty PNG. 

## Platform and Deps ##

This was developed on an Intel Macbook Pro; I'm fairly confident the Ruby code executes without issue. However, I'm not sure the gnuplots script will work without puking. If you don't have gnuplots installed or it's incompatible with Windows, simply ignore the heatmap generating functions. Sample heatmaps are included in the heatmaps directory.

That being said, the following I used the following:

	1. Ruby 1.8.7-head
	2. gnuplot 4.4 patchlevel 2

If you're on a *nix based machine, rvm (http://rvm.beginrescueend.com) is a great way to manage Ruby versions. Do 
	
	`rvm install ruby-1.8.7-head`
	`rvm use ruby-1.8.87-head`

## Running a Simulation ##
There are currently two ways to run a simulation at the moment.

  1. Single run script that outputs some simple statistics about the simulation. You can run it with the following: 
	
		`ruby simulate.rb RADIUS TX_POWER BLOCK_SIZE TARGET_BLER`
	
	e.g.
		
		`ruby simulate.rb 1 40 1000 0.05`

  2. Full simulation script that generates reports for all paramters from the homework description: 

		`ruby scripted_sim.rb`

You can choose which one to use based on your level of interest. If you'd like to fuss a bit with the parameters, use the single run script (simulate.rb), as this takes < 2 seconds to run. If you'd like to run the full simulation and read the reports, use scripted_sim.rb - it takes approximately 30-50 minutes to run, depending on your machine.