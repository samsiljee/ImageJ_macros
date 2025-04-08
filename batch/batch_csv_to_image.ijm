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
// Activate batch process mode - Images won't be opened graphically, up to 20x speed improvement
setBatchMode(true);

// Set input directory
input = getDirectory("Select an input directory");

// Set output directory
output = getDirectory("Select a results directory");

// Dialog box for user input - on start up
Dialog.create("Options");
Dialog.addString("File suffix", ".csv");
Dialog.show();

// Get user input
suffix = Dialog.getString();

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
    
	// Open the .csv file as an image
	run("Text Image... ", "open=[" + filePath + "] windowless=true");

	// Get image name
	var name_with_extension = getTitle();

	// Get name without extension
	var name = name_with_extension.substring(0, name_with_extension.lastIndexOf('.'));
	
	// Change LUT to grays
	run("Grays");

	// Save
	saveAs("PNG", output+"/"+name+" grays.png");
	
	// Change LUT from Lambert
	run("Lambert");
	
	// Save
	saveAs("PNG", output+"/"+name+" Lambert LUT.png");
	
	// Run again but adjusting contrast
	run("Grays");
	setMinAndMax(3, 30);
	saveAs("PNG", output+"/"+name+" contrast adjusted grays.png");
	
	run("Lambert");
	setMinAndMax(3, 30);
	saveAs("PNG", output+"/"+name+" contrast adjusted Lambert LUT.png");

	// Close windows
	run("Close All");
	
	// Display finished message
	print(name+" converted");
}
print("All files converted");
}
