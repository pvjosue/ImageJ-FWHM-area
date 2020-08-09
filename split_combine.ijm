
// This macro is used to observe dual channel images simutaneously. 

setBatchMode(true); // if true then no images or kymos will be displayed, instead all will be saved to the folder

id = getImageID(); //get active image Id, in this case the stack 
t  = getTitle(); // get image title (used to get the path)
N = roiManager("count"); //number of MTs in ROI to analyse manager
path = getDirectory(t); // set the directory for saving 


for (i=0 ; i<roiManager("count"); i++) {
	roiManager("select", i);
	ROIname = call("ij.plugin.frame.RoiManager.getName", i);
	run("Duplicate...", "duplicate");
	cropID = getImageID ();
	selectImage(cropID);
	title = getTitle();
	run("Split Channels");
	img2 = "C2-" +title;
	img1 = "C1-" + title;
	selectWindow("C1-"+title);
	run("Enhance Contrast", "saturated=2");  // Saturate 5 % pixels
	run("RGB Color");
	selectWindow("C2-"+title);
	run("Enhance Contrast", "saturated=2");
	run("RGB Color");
	run("Combine...", "stack1=["+ img1 +"] stack2=["+ img2 +"]");  // does not work
	saveAs("tiff", path+ROIname+"combine_movie");
	close();
}
