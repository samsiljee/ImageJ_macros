//Get directories for batch actions
input = getDirectory("Choose an Input Directory");
output = getDirectory("Select a Results Directory")

function ModifyBC (input, output, filename) {
	run("Bio-Formats (Windowless)", "open="+input+filename);
	title=replace(filename,".obi","");
	selectWindow(title);
	run("Split Channels");
	selectWindow("C3-"+title);
	//run("Brightness/Contrast...");
	setMinAndMax(11531, 47533);
	run("Apply LUT");
	selectWindow("C4-"+title);
	setMinAndMax(11531, 47533);
	run("Apply LUT");
	selectWindow("C1-"+title);
	setMinAndMax(11531, 47533);
	run("Apply LUT");
	selectWindow("C2-"+title);
	setMinAndMax(11531, 47533);
	run("Apply LUT");
	run("Merge Channels...", "c1=C1-"+title+" c2=C2-"+title+" c3=C3-"+title+" c4=C4-"+title+" create");
	selectWindow(title);
	saveAs("PNG", output+title+".png");
	run("Close");
	
}

//setBatchMode(true);
setBatchMode(false);
list = getFileList(input);
for (i = 0; i < list.length; i++)
        ModifyBC(input, output, list[i]);
