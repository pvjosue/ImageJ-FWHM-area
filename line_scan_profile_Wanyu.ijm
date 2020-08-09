// This function save line scan profiles in .csv format in the designated file
// Right now only work for single channel; change line width (default =5) as wish. 
// 8_4_18 Wanyu Lei

t  = getTitle();
imname=getTitleStripExtension();
path = getDirectory(t); // set the directory for saving 


selectWindow(t); 
run("Split Channels"); 
// loop through channels
for (c=1 ; c<3; c++) {
if(c==1){
	color="green";
	selectWindow("C1-"+t);
} 
	else{
	color="red";
	selectWindow("C2-"+t); 
}

for (i=0 ; i<roiManager("count"); i++) {
roiManager("select", i);
ROIname = call("ij.plugin.frame.RoiManager.getName", i);
run("Line Width...", "line=8");   // change width
run("Plot Profile");
close(); // close plot

selectWindow("Plot Values");
saveAs("Results", path+imname+"_"+ROIname+"_"+color+".csv");
close(imname+"_"+ROIname+"_"+color+".csv");  // close result windows
run("Clear Results");
}
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

showMessage("Process completed, all line profiles are saved");