/*
 * ImageJ macro template for batch processing by folder
 * Written by Sam Siljee
 * Created 12/10/2023
 * Feel free to use and edit under the MIT licensce
 */

// Check to stop macro if there are images open - these would be closed and unsaved changes discarded
if (nImages > 0) {

	print("Please save and close all open images before running this macro.");
	
} else {

// Set input directory
input = getDirectory("Select an input directory");

// Set output directory
output = getDirectory("Select a results directory");

// Dialog box for user input - on start up
Dialog.create("Montaging options");
Dialog.addString("File suffix", ".oib");
Dialog.addCheckbox("Checkbox input", true);
Dialog.addNumber("numeric input", 1);
Dialog.show();

// Get user input
suffix = Dialog.getString();
checkbox_input = Dialog.getCheckbox();
numeric_input = Dialog.getNumber();

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
    
	// Check number of channels
	nChannels = nSlices;

	// Get image name
	name = getTitle();

	// Create duplicate to run the macro on
	run("Duplicate...", "title=Duplicate duplicate");


	/*
	/ Insert the block of the marco code to be perfomred on the image here
	/ Variables can be accessed from the startup dialogue box
	/ Dialog boxes can also be opened to ask for variables on an image by image basis
	/ There are plenty of helpful forums to learn more about the ImageJ macro language
	/*


	// Save
	saveAs("BMP", output+"/"+name+" edited.bmp");

	// Close windows
	run("Close All");
}

}