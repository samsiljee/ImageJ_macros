/*
 * Macro to batch measure fluorescence intensity (nuclear) in two or three channel images
 * Written by Sam Siljee
 * Created 12/10/2023
 * Feel free to use and edit under the MIT licensce
 */

if (nImages > 0) {

	print("Please save and close all open images before running this macro.");
	
} else {

// Set input directory
input = getDirectory("Select an input directory");

// Set output directory
output = getDirectory("Select a results directory");

// Dialog box for user input
Dialog.create("Options");
Dialog.addString("File suffix", ".oib");
Dialog.addNumber("DAPI channel", 1);
Dialog.addCheckbox("Measure channel 1", false);
Dialog.addCheckbox("Measure channel 2", true);
Dialog.addCheckbox("Measure channel 3", true);
Dialog.addCheckbox("Run watershed", false);
Dialog.addCheckbox("Run fill holes", false);
Dialog.addNumber("Minimum nucleus size (pixels)", 10);
Dialog.show();

// Get user input
suffix = Dialog.getString();
DAPI_channel = Dialog.getNumber();
measure_1 = Dialog.getCheckbox();
measure_2 = Dialog.getCheckbox();
measure_3 = Dialog.getCheckbox();
run_watershed = Dialog.getCheckbox();
run_fill_holes = Dialog.getCheckbox();
minimum_size = Dialog.getNumber();

// Close windows
run("Close All");

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	
	// Construct the full file path
	var filePath = input + File.separator + file;

	// Open the image file using Bio-Formats Importer
	run("Bio-Formats Importer", "open=[" + filePath + "] windowless=true");

    // Get image name
	name = getTitle();

	// Set parameters to be measured
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");

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

	// Tidy up the mask - if options selected

	if (run_watershed == true) {
		run("Watershed");
	}
	if (run_fill_holes == true) {
		run("Fill Holes");
	}

	// Create ROIs
	run("Analyze Particles...", "size="+minimum_size+"-Infinity pixel exclude clear add");

	// Measure and save results of first channel (if selected)
	if(measure_1 == true) {
		
		// Select channel one
		selectWindow("C1-Duplicate");

		// Open ROI manager
		roiManager("Measure");

		// Save results
		selectWindow("Results");
		saveAs("Results", output+"/"+name+"_channel_1_results.csv");

		// Clear results
		run("Clear Results");

	}

	// Measure and save results of second channel (if selected)
	if(measure_2 == true) {
		
		// Select channel two
		selectWindow("C2-Duplicate");

		// Open ROI manager
		roiManager("Measure");

		// Save results
		selectWindow("Results");
		saveAs("Results", output+"/"+name+"_channel_2_results.csv");

		// Clear results
		run("Clear Results");

	}

	// Measure and save results of third channel (if selected)
	if(measure_3 == true) {
		
		// Select channel three
		selectWindow("C3-Duplicate");

		// Open ROI manager
		roiManager("Measure");

		// Save results
		selectWindow("Results");
		saveAs("Results", output+"/"+name+"_channel_3_results.csv");

		// Clear results
		run("Clear Results");

	}

	// Close windows
	run("Close All");
}

// Close remaining windows
close("ROI Manager");
close("Results");

}