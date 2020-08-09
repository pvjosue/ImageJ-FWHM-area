// This function save line scan profiles in .csv format in the designated file
// Right now only work for single channel; change line width (default =5) as wish. 
// 8_4_18 Wanyu Lei

t  = getTitle();
imname=getTitleStripExtension();
path = getDirectory(t); // set the directory for saving 


selectWindow(t); 


for (i=0 ; i<roiManager("count"); i++) {
roiManager("select", i);
ROIname = call("ij.plugin.frame.RoiManager.getName", i);

run("Plot Z-axis Profile");
close(); // close plot

selectWindow("Plot Values");
saveAs("Results", path+imname+"_"+ROIname+".csv");
close(imname+"_"+ROIname+".csv");  // close result windows
run("Clear Results");
}


// get rid of extension of image name
function getTitleStripExtension() { 
  t = getTitle(); 
  t = replace(t, ".tif", "");         
  t = replace(t, ".tiff", "");       
  t = replace(t, ".lif", "");       
  t = replace(t, ".lsm", "");     
  t = replace(t, ".czi", "");       
  t = replace(t, ".nd2", "");     
  return t; 
} 
// save ROI
roiManager("save", path+"ROI.zip");

showMessage("Process completed, all intensity profiles are saved");