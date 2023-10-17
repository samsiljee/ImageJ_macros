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

// Only open .avi files
suffix = ".avi";

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

	// Open the avi file
	open(filePath);
		
	// Get image name
	name = getTitle();
	
	// Save as TIFF
	saveAs("TIFF", output + File.separator + name + ".tiff");

	// Close windows
	run("Close All");
}

}