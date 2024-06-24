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

    // Initialize an array to store results
    results = newArray();

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

        // Get image name
        var image_name = getTitle();

        // Measure mean whole image intensity
        run("Measure");

        // Get the mean intensity value from the Results table
        selectWindow("Results");
        var mean_intensity = getResult("Mean", nResults-1);

        // Store the result in the results array
        results = Array.concat(results, newArray(file, mean_intensity));

        // Clear results for the next measurement
        run("Clear Results");

        // Close the image
        close();
    }

    // Create the output file
    outputFile = File.open(output + "mean_intensity_results.csv", "w");

    // Write header
    File.write(outputFile, "File Name,Mean Intensity\n");

    // Write results
    for (i = 0; i < results.length; i += 2) {
        File.write(outputFile, results[i] + "," + results[i+1] + "\n");
    }

    // Close the output file
    File.close(outputFile);

    // Clear results window
    run("Clear Results");

    // Close all remaining windows
    run("Close All");
    print("Done!");
}
