//Create duplicate to run macro on
run("Duplicate...", "title=Duplicate duplicate");

//Split stack and change colours
run("Stack to Images");
selectWindow("Duplicate-0001");
run("Blue");
selectWindow("Duplicate-0002");
run("Grays");

//Adjust brightness and contrast To channel 1
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
run("Merge Channels...", "c1=Duplicate-0001 c2=Duplicate-0002 create keep");
selectWindow("Composite");

//Add scale bar
run("Scale Bar...", "width=100 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold overlay");

//Save and reopen as png for single layer
saveAs("PNG", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Techniques/IF/ImageJ Macros/temp/4_Composite.png");
close();
open("C:/Users/sam.siljee/OneDrive - GMRI/Documents/Techniques/IF/ImageJ Macros/temp/4_Composite.png");

//Set channels back to grey LUT for split images
selectWindow("Duplicate-0001");
run("Grays");
selectWindow("Duplicate-0002");
run("Grays");

//Save other channels for for use in FigureJ
selectWindow("Duplicate-0001");
saveAs("BMP", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Techniques/IF/ImageJ Macros/temp/1_Blue.bmp");
selectWindow("Duplicate-0002");
saveAs("BMP", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Techniques/IF/ImageJ Macros/temp/2_Green.bmp");

//combine as montage and save
run("Images to Stack", "use");
run("Make Montage...", "columns=3 rows=1 scale=1");
saveAs("BMP", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Techniques/IF/ImageJ Macros/temp/Montage.bmp");

//Close windows
selectWindow("Stack");
close();
selectWindow("Montage.bmp");
close();