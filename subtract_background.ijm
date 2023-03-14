//Create duplicate to run macro on
run("Duplicate...", "title=Duplicate duplicate");

//Split stack
run("Stack to Images");

//Subtract from channel 1 (DAPI)
selectWindow("Duplicate-0001");
run("Subtract...", "value=69");

//Subtract from channel 2
selectWindow("Duplicate-0002");
run("Subtract...", "value=684");

//Subtract from channel 3
selectWindow("Duplicate-0003");
run("Subtract...", "value=215");

//Merge back to multichannels
run("Images to Stack", "use");
