//Set output directory
output = getDirectory("Select a results directory");

//Create duplicate to run macro on
run("Duplicate...", "title=Duplicate duplicate");

// Split the channels
run("Split Channels");

// Select the DAPI channel
selectWindow("C1-Duplicate");

// Run threshold
setAutoThreshold("Default dark no-reset");
//run("Threshold...");
setOption("BlackBackground", true);

// Use DAPI threshold to make mask
run("Convert to Mask");

// Tidy up the mask
run("Watershed");
run("Fill Holes");

// Create ROIs
run("Analyze Particles...", "size=10-Infinity pixel exclude clear add");

// Select channel two
selectWindow("C2-Duplicate");

// Set measurements to aquire and measure
run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
roiManager("Measure");

// Save results
selectWindow("Results");
saveAs("Results", output+"channel_2_results.csv");

// Repeat for channel 3
run("Clear Results");
selectWindow("C3-Duplicate");
roiManager("Measure");
selectWindow("Results");
saveAs("Results", output+"channel_3_results.csv");

// Close all new windows
selectImage("C1-Duplicate");
close();
selectImage("C2-Duplicate");
close();
selectImage("C3-Duplicate");
close();
close("ROI Manager");
close("Results");