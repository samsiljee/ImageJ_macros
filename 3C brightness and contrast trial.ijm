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

//Adjust brightness and contrast manually
run("Brightness/Contrast...")  // open Brightness/Contrast tool
title = "Channel one";
msg = "If necessary, use the \"B&C\" tool to\nadjust the brightness and contrast for the first channel, then click \"OK\".";
waitForUser(title, msg);
selectWindow("Duplicate-0001");

run("Brightness/Contrast...")  // open Brightness/Contrast tool
title = "Channel two";
msg = "If necessary, use the \"B&C\" tool to\nadjust the brightness and contrast for the second channel, then click \"OK\".";
waitForUser(title, msg);
selectWindow("Duplicate-0002");

run("Brightness/Contrast...")  // open Brightness/Contrast tool
title = "Channel three";
msg = "Use the \"B&C\" tool adjust the brightness and contrast \nfor the third channel, then click \"OK\".";
waitForUser(title, msg);
selectWindow("Duplicate-0003");
run("Brightness/Contrast...");

//Make composite
run("Merge Channels...", "c1=Duplicate-0001 c2=Duplicate-0002 c3=Duplicate-0003 create keep");
selectWindow("Composite");

//Add scale bar
run("Scale Bar...", "width=100 thickness=20 font=50 color=White background=None location=[Lower Right] horizontal bold overlay");

//Save and reopen as png for single layer
saveAs("PNG", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Coding/ImageJ Macros/temp/4_Composite.png");
close();
open("C:/Users/sam.siljee/OneDrive - GMRI/Documents/Coding/ImageJ Macros/temp/4_Composite.png");

//Save other channels and change colour for use in FigureJ
selectWindow("Duplicate-0001");
run("Grays");
saveAs("BMP", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Coding/ImageJ Macros/temp/1_Blue.bmp");
selectWindow("Duplicate-0002");
run("Grays");
saveAs("BMP", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Coding/ImageJ Macros/temp/2_Green.bmp");
selectWindow("Duplicate-0003");
run("Grays");
saveAs("BMP", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Coding/ImageJ Macros/temp/3_Red.bmp");

//combine as montage and save
run("Images to Stack", "use");
run("Make Montage...", "columns=2 rows=2 scale=1");
saveAs("BMP", "C:/Users/sam.siljee/OneDrive - GMRI/Documents/Coding/ImageJ Macros/temp/Montage.bmp");
//Close windows
selectWindow("Stack");
close();
selectWindow("Montage.bmp");
close();