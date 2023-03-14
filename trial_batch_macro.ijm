output_dir = "C:/Users/sam.siljee/OneDrive - GMRI/Pictures/Immunofluorescence/image_j_processing/"
input_dir = "C:/Users/sam.siljee/OneDrive - GMRI/Pictures/Immunofluorescence/image_j_processing/"

list = getFileList(input_dir);
listlength = list.length;

setBatchMode(true);
for (z = 0; z < listlength; z++){
    if(endsWith(list[z], 'oib')==true ){
    	if(list[z].contains("488")){
        title = list[z];
            end = lengthOf(title)-4;
            out_path = output_dir + substring(title,0,end) + "_processed.tif";
            open(input_dir + title);
            //add all the functions you want
            run("Brightness/Contrast...");
            setMinAndMax(1, 15);
            run("Apply LUT");
            saveAs("tif", "" + out_path + "");
            close();
    		};
    
        run("Close All");
        }
    }

setBatchMode(false);