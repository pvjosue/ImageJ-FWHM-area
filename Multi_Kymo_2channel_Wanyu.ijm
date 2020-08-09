// This macro generate kymogprahs and kymo movies for each microtububle marked by a line ROI
// The macro assumes that the plugin KymogrpahMin is installed
// The macro runs in patch mode where no images are displyed during process but instead images are saved to the choosed folder
//
// by Mohammed Mahamdeh (Mohammed.mahamdeh@gmail.com)
// 2017 - 08 - 17

// Modified by Wanyu Lei 07/07/18; 
// Note Wanyu uses KymographMax and the line width is set to be 5. 
// Output: kymograph .tif; .jpeg with enhaced contrast (saturation 5% )
// Pls change parameters as you want. 

setBatchMode(true); // if true then no images or kymos will be displayed, instead all will be saved to the folder

id = getImageID(); //get active image Id, in this case the stack 
t  = getTitle(); // get image title (used to get the path)
N = roiManager("count"); //number of MTs in ROI to analyse manager
path = getDirectory(t); // set the directory for saving 
newDir= path + "/pngpic/"; // name a new folder to save all png pic. 
File.makeDirectory(newDir); // creat a new folder to save all png pic. 
// case: ROIs in the ROI manager 
if (Overlay.size==0){

for (i=0 ; i<roiManager("count"); i++) {
	selectImage(id); //select stack
    roiManager("select", i); // select line ROIs 
	
	// generate kymograph
	ROIname = call("ij.plugin.frame.RoiManager.getName", i);
	// run("Reslice [/]...", "output=0.5 slice_count=1 avoid");   // This is for two channel 
	// run("KymographMax", "linewidth=5");    // This is for Wanyu one channel 
		run("KymographSum", "linewidth=5");    // This is for Wanyu one channel 
	KymoID = getImageID ();
	selectImage(KymoID);
	rename(ROIname);
	saveAs("tiff", path+ROIname);

	// color code kymograph for visualization 
	run("physics"); 
	run("Enhance Contrast", "saturated=2");   // Saturate 5 % pixels
	saveAs("png", newDir+ROIname);
	close();
	
	// save kymo movie
	selectImage(id); //select stack
	roiManager("select", i);
	run("To Bounding Box");
	run("Enlarge...", "enlarge=10 pixel");
	run("Duplicate...", "duplicate");
	//run("Straighten...", "line=60 process title=" + ROIname);
	saveAs("tiff", path+ROIname+"movie");
	close();
}
};


// case: ROI are saved in an overlay
else{
	run("To ROI Manager");

for (i=0 ; i<roiManager("count"); i++) {
	selectImage(id); //select stack
    roiManager("select", i); 
	
	// generate kymograph
	ROIname = call("ij.plugin.frame.RoiManager.getName", i);
	// run("KymographMin", "linewidth=23"); // This is Microtubules 
	//run("KymographMax", "linewidth=5");    // This is for Wanyu, Fluororescence microscope 
		run("KymographSum", "linewidth=5");    // This is for Wanyu one channel 
	KymoID = getImageID ();
	selectImage(KymoID);
	rename(ROIname);
	saveAs("tiff", path+ROIname);
	close();
	
	// save kymo movie
	selectImage(id); //select stack
	roiManager("select", i);
	run("To Bounding Box");
	run("Enlarge...", "enlarge=10 pixel");
	run("Duplicate...", "duplicate");
	//run("Straighten...", "line=60 process title=" + ROIname);
	saveAs("tiff", path+ROIname+"movie");
	close();
}
};

showMessage("Process completed, all kymos and related movies are saved");
roiManager("save", path+"ROI.zip");

