/*
 * Macro to batch process two, three, or four channel fluorescence images
 * Written by Sam Siljee
 * Created 4/10/2023
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
Dialog.create("Montaging options");
Dialog.addString("File suffix", ".oib");
Dialog.addCheckbox("Rearrange channels", false);
Dialog.addCheckbox("Include first channel in merge", true);
Dialog.addCheckbox("Set min and max values manually", false);
Dialog.addCheckbox("Auto brightness/contrast first channel", true);
Dialog.addCheckbox("Auto brightness/contrast all channels", false);
Dialog.addCheckbox("Include scale bar", true);
Dialog.addCheckbox("Use grays LUT on split channels", true);
Dialog.show();

// Get user input
suffix = Dialog.getString();
rearrange_channels = Dialog.getCheckbox();
DAPI_in_merge = Dialog.getCheckbox();
BC_manual = Dialog.getCheckbox();
BC_DAPI_channel = Dialog.getCheckbox();
BC_other_channels = Dialog.getCheckbox();
show_scale = Dialog.getCheckbox();
white_split = Dialog.getCheckbox();

// Get user input to rearrange the channels
if (rearrange_channels) {
	// Dialog box for channel rearrangement
	Dialog.create("New channel order");
	Dialog.addString("New order", "132");
	Dialog.show();
		// Get channel rearrangement input
	channel_order = Dialog.getString();
}

// Get user input to set min and max points for brightness and contrast
if (BC_manual) {
	// Open sample image

	// Get min and max values
}


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
	
	// Rearrange the channels
	if (rearrange_channels) {
		run("Arrange Channels...", "new="+channel_order);
	}

	//Split stack and change DAPI to blue
	run("Stack to Images");
	selectWindow("Duplicate-0001");
	run("Blue");

	// Colours for two channel
	if (nChannels == 2) {
		selectWindow("Duplicate-0002");
		run("Grays");
	}

	// Colours for three channel
	if (nChannels == 3) {
		selectWindow("Duplicate-0002");
		run("Green");
		selectWindow("Duplicate-0003");
		run("Red");
	}
	
	// Colours for four channels
	if (nChannels == 4) {
	selectWindow("Duplicate-0002");
	run("Green");
	selectWindow("Duplicate-0003");
	run("Red");
	selectWindow("Duplicate-0004");
	run("Grays");
	}

	// Adjust brightness and contrast
	if (BC_other_channels) {
		selectWindow("Duplicate-0001");
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT");
	
		selectWindow("Duplicate-0002");
		run("Enhance Contrast", "saturated=0.35");
		run("Apply LUT");
	
		if (nChannels > 2) {
			selectWindow("Duplicate-0003");
			run("Enhance Contrast", "saturated=0.35");
			run("Apply LUT");
		}
		
		if (nChannels > 3) {
			selectWindow("Duplicate-0004");
			run("Enhance Contrast", "saturated=0.35");
			run("Apply LUT");
		}
		
	} else {
		if (BC_DAPI_channel) {
		   selectWindow("Duplicate-0001");
		   run("Enhance Contrast", "saturated=0.35");
 		   run("Apply LUT");
		}
	}

	// Make composite for two channels
	if (nChannels == 2) {
		if (DAPI_in_merge) {
			run("Merge Channels...", "c1=Duplicate-0001 c2=Duplicate-0002 create keep");
		} else {
			run("Merge Channels...", "c2=Duplicate-0002 create keep");
		}
	}

	// Make composite for three channels
	if (nChannels == 3) {
		if (DAPI_in_merge) {
			run("Merge Channels...", "c1=Duplicate-0001 c2=Duplicate-0002 c3=Duplicate-0003 create keep");
		} else {
			run("Merge Channels...", "c2=Duplicate-0002 c3=Duplicate-0003 create keep");
		}
	}
	
	// Make composite for four channels
	if (nChannels == 4) {
		if (DAPI_in_merge) {
			run("Merge Channels...", "c1=Duplicate-0001 c2=Duplicate-0002 c3=Duplicate-0003 c4=Duplicate-0004 create keep");
		} else {
			run("Merge Channels...", "c2=Duplicate-0002 c3=Duplicate-0003 c4=Duplicate-0004 create keep");
		}
	}

	selectWindow("Composite");

	run("RGB Color");
	selectWindow("Composite (RGB)");

	// set split images back to gray LUT
	if (white_split) {
		selectWindow("Duplicate-0001");
		run("Grays");
		selectWindow("Duplicate-0002");
		run("Grays");
		if (nChannels > 2) {
			selectWindow("Duplicate-0003");
			run("Grays");
		}
		if (nChannels > 3) {
			selectWindow("Duplicate-0004");
			run("Grays");
		}
	}

	close("Composite");

	// Make montage
	run("Images to Stack", "use");
	if (nChannels == 2) {
		run("Make Montage...", "columns=3 rows=1 scale=1");
	}
	if (nChannels == 3) {
		run("Make Montage...", "columns=2 rows=2 scale=1");
	}
	if (nChannels == 4) {
		run("Make Montage...", "columns=3 rows=2 scale=1");
	}

	// Add scale bar
	if (show_scale) {
		run("Scale Bar...", "width=100 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold burn");
	}

	// Save montage
	saveAs("BMP", output+"/"+name+" montage.bmp");

	// Close windows
	run("Close All");
}

}