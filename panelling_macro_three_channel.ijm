//Set output directory
output = getDirectory("Select a Results Directory");

//Create duplicate to run macro on
run("Duplicate...", "title=Duplicate duplicate");

//Split stack and change colours
run("Stack to Images");
selectWindow("Duplicate-0001");
run("Blue");
selectWindow("Duplicate-0002");
run("Green");
selectWindow("Duplicate-0003");
run("Red");

//Adjust brightness and contrast
selectWindow("Duplicate-0001");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");

//selectWindow("Duplicate-0002");
//run("Enhance Contrast", "saturated=0.35");
//run("Apply LUT");

//selectWindow("Duplicate-0003");
//run("Enhance Contrast", "saturated=0.35");
//run("Apply LUT");

//Make composite
run("Merge Channels...", "c1=Duplicate-0001 c2=Duplicate-0002 c3=Duplicate-0003 create keep");
selectWindow("Composite");

//Add scale bar
run("Scale Bar...", "width=100 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold overlay");

//Save and reopen as png for single layer
saveAs("PNG", output+"4_Composite.png");
close();
open(output+"4_Composite.png");

//set split images back to gray LUT
selectWindow("Duplicate-0001");
run("Grays");
selectWindow("Duplicate-0002");
run("Grays");
selectWindow("Duplicate-0003");
run("Grays");

//Save other channels for for use in FigureJ
selectWindow("Duplicate-0001");
saveAs("BMP", output+"1_Blue.bmp");
selectWindow("Duplicate-0002");
saveAs("BMP", output+"2_Green.bmp");
selectWindow("Duplicate-0003");
saveAs("BMP", output+"3_Red.bmp");

//combine as montage and save
run("Images to Stack", "use");
run("Make Montage...", "columns=2 rows=2 scale=1");
saveAs("BMP", output+"Montage.bmp");
//Close windows
selectWindow("Stack");
close();
selectWindow("Montage.bmp");
close();
