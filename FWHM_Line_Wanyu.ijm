//Measure FWHM from intensity profile using Gaussian Fitting
//Image must have aspect ratio of one
//Version 1: 8 Mar 2011, John Lim, IMB
//Version 2; 9 Mar 2011, Send FWHM to a table, John Lim, IMB
//Version 3; 11 Mar 2011, Rename the fitting graph, John Lim, IMB
//Version 4; 4/13/18, make it work for multiple ROIs in the ROI manager; add line width, Wanyu Lei; works for multiple channels
getPixelSize(unit, pixelWidth, pixelHeight);
getDimensions(width, height, channels, slices, frames);

if(pixelWidth!=pixelHeight){
	exit("Please select an image with pixel aspect ratio of one.")
}

id0=getImageID();
//roiManager("Add");

if(selectionType()!=5){
	exit("Support only straight line");
}
for (ii=0 ; ii<channels; ii++) { 
// Stack.setChannel(ii);	

for (i=0 ; i<roiManager("count"); i++) {    //Wanyu
ROIname = call("ij.plugin.frame.RoiManager.getName", i); //Wanyu
print("ROIname"); // wanyu
roiManager("select", i);    //Wanyu
getSelectionBounds(a, b, c, d);
// line=""+a+" "+b+" "+c+" "+d;
line=ROIname;
if(channels>1){
	Stack.getPosition(channel, dummy, dummy);
	line="Ch"+ii+" "+ROIname;   // name of the plot
	
}

Y=getProfile();

 run("Line Width...", "line=10");   // change width
len=Y.length;

X=newArray(len);
for(j=0;j<len;j++){
	X[j]=j*pixelHeight;
}

Fit.doFit("Gaussian", X, Y);
r2=Fit.rSquared;
if(r2<0.9){
	showMessage("Warning: Poor Fitting",r2);
}
// Fit.plot();
if(isOpen("y = a + (b-a)*exp(-(x-c)*(x-c)/(2*d*d))")){
	selectWindow("y = a + (b-a)*exp(-(x-c)*(x-c)/(2*d*d))");
	rename(line);
}
sigma=Fit.p(3);
FWHM=abs(2*sqrt(2*log(2))*sigma);

myTable(ROIname,line,FWHM,unit,r2);

selectImage(id0);
selectWindow("FWHM");

// saveAs("Measurements", dir + name +"FWHM Results.csv");  // Wanyu

function myTable(a,b,c,d,e){
	title1="FWHM";
	title2="["+title1+"]";
	if (isOpen(title1)){
   		print(title2, a+"\t"+b+"\t"+c+"\t"+d+"\t"+e);  // wanyu
	}
	else{
   		run("Table...", "name="+title2+" width=300 height=200");
   		print(title2, "\\Headings:ROIname\tLine\tFWHM\tUnit\tGoodness_of_fitting");
   		print(title2, a+"\t"+b+"\t"+c+"\t"+d+"\t"+e); //wanyu
	}
}
}
}
    //wanyu
//--
//ImageJ mailing list: http://imagej.nih.gov/ij/list.html
