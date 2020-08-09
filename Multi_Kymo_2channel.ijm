// This macro generate kymogprahs and kymo movies for each microtububle marked by a line ROI
// The macro assumes that the plugin KymogrpahMin is installed
// The macro runs in patch mode where no images are displyed during process but instead images are saved to the choosed folder
//
// by Mohammed Mahamdeh (Mohammed.mahamdeh@gmail.com)
// 2017 - 08 - 17

setBatchMode(true); // if true then no images or kymos will be displayed, instead all will be saved to the folder

id = getImageID(); //get active image Id, in this case the stack 
t  = getTitle(); // get image title (used to get the path)
N = roiManager("count"); //number of MTs in ROI to analyse manager
path = getDirectory(t); // set the directory for saving 

// case: ROIs in the ROI manager 
if (Overlay.size==0){

for (i=0 ; i<roiManager("count"); i++) {
	selectImage(id); //select stack
    roiManager("select", i); // select line ROIs 
	
	// generate kymograph
	ROIname = call("ij.plugin.frame.RoiManager.getName", i);
	run("Reslice [/]...", "output=0.5 slice_count=1 avoid");
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


// case: ROI are saved in an overlay
else{
	run("To ROI Manager");

for (i=0 ; i<roiManager("count"); i++) {
	selectImage(id); //select stack
    roiManager("select", i); 
	
	// generate kymograph
	ROIname = call("ij.plugin.frame.RoiManager.getName", i);
	run("KymographMin", "linewidth=23");
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

