// Analyis kymo is used to analyse kaymographes. 


id = getImageID(); //get active image Id, in this case the stack 
t  = getTitle();
N = roiManager("count"); //number of MTs in ROI to analyse manager
path = getDirectory(t); // set the directory for saving 
length_cal = getNumber("enter pixel size in um", 0.16);// pixel size in micron
time_cal = getNumber("enter time step in seconds", 10) ; // time step
cal = 60*length_cal/time_cal; // rate calibration factor in um/min

//----------------------------------------------------------
//other options to get calibration
//getVoxelSize(width, height, depth, unit)
//getPixelSize(unit, pixelWidth, pixelHeight)
//----------------------------------------------------------

// check if result window is open and close it
  if (isOpen("Results")) {
       selectWindow("Results");
       run("Close");
   } 

run("Set Measurements...", "area bounding display redirect=None decimal=3");

// measuring growth

waitForUser("draw growth lines and add them to the ROI then press OK");
Roi.setStrokeColor("green"); // green color to indecate growth

// for every line in the ROI manager measure growth/shrinkage rate and growth time
for (i=0 ; i<roiManager("count"); i++) {
	selectImage(id); // select the kymograph (can be moved outside of the loop!, check?)
    roiManager("select", i);
//	ROIname = call("ij.plugin.frame.RoiManager.getName", i); // name of the ROis (not needed here)
	run("Measure");
	
	gr = cal *((getResult("Width",i)/getResult("Height",i))); // calculate growth rate
	setResult("growth rate (µm/min)",i, gr);// add to results table 
	gt = time_cal*(getResult("Height",i))/60; // growth time
	setResult("growth time (min)",i, gt);// add to results table 	
	
};
saveAs("Results", path + t + "__results_Growth.txt"); 
roiManager("save", path+t+"__ROI_Growth.zip");

wait(1000); 
roiManager("deselect")// deselect the ROI
roiManager("delete"); // delete all growth ROIs and prepare for shrinkage ROI
run ("Clear Results"); // clear results table

// measuring shrinkage


waitForUser("draw shrinkage lines and add them to the ROI then press OK");
Roi.setStrokeColor("red"); // red color to indecate shrinkage

for (i=0 ; i<roiManager("count"); i++) {
	selectImage(id); // select the kymograph (can be moved outside of the loop!, check?)
    roiManager("select", i);
//	ROIname = call("ij.plugin.frame.RoiManager.getName", i); // name of the ROis (not needed here)
	run("Measure");
	
	sr = cal *((getResult("Width",i)/getResult("Height",i))); // calculate growth rate
	setResult("shrinkage rate (µm/min)",i, sr);// add to results table 
	st = time_cal*(getResult("Height",i))/60; // growth time
	setResult("shrinkage time (min)",i, st);// add to results table 	
	
};
saveAs("Results", path + t + "__results_Shrinkage.txt"); 
roiManager("save", path+t+"__ROI_Shrinkage.zip");

roiManager("deselect")// deselect the ROI
roiManager("delete"); // delete all growth ROIs and prepare for shrinkage ROI
run ("Clear Results"); // clear results table
