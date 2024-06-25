/*
 * ImageJ macro to get mean image intensity from all images in a folder - one channel only
 * Written by Sam Siljee
 * Created 20/06/2024
 * Feel free to use and edit under the MIT license
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
    Dialog.create("Suffix selection");
    Dialog.addString("File suffix", ".tif");

    Dialog.show();

    // Get user input
    suffix = Dialog.getString();

    // Close windows
    run("Close All");

    // Set parameters to be measured
    run("Set Measurements...", "mean redirect=None decimal=0");
	
	// Prevent images from opening while macro is running - up to 20x speed improvement
	setBatchMode(true);

    processFolder(input);

    // function to scan folders/subfolders/files to find files with correct suffix
    function processFolder(input) {
        list = getFileList(input);
        list = Array.sort(list);
        for (i = 0; i < list.length; i++) {
            if (File.isDirectory(input + File.separator + list[i]))
                processFolder(input + File.separator + list[i]);
            if (endsWith(list[i], suffix))
                processFile(input, list[i]);
        }
    }

    function processFile(input, file) {
        // Construct the full file path
        var filePath = input + File.separator + file;

        // Open the image file using Bio-Formats Importer
        open(filePath);

        // Measure mean whole image intensity
        run("Measure");

        // Print the current file name to log
		print(getTitle());

        // Close the image
        close();
    }

    // Close all remaining windows
    run("Close All");
}
