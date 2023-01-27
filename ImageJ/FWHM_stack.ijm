// 0. Stack all the images that you want to analyze at once.
//    And name each stack as you want, as the results will have the name.
// 1. select a line perpendicular to a filament/bead/structure.
// 2. select thickness, so we get the fwhm of an area not a line
line_thickness = 3
// 3. Run this pluggin

window_name = getTitle();
selectWindow(window_name);
n = nSlices;
setSlice(1);

for (j=0; j<n; j++) {
	setSlice(j+1);
	getPixelSize(unit, pixelWidth, pixelHeight);
	getDimensions(width, height, channels, slices, frames);
	slice_name = getInfo("slice.label");
	if(pixelWidth!=pixelHeight){
		exit("Please select an image with pixel aspect ratio of one.")
	}
	
	id0=getImageID();
	//roiManager("Add");
	
	if(selectionType()!=5){
		exit("Support only straight line");
	}
	getSelectionBounds(a, b, c, d);
	line=""+a+" "+b+" "+c+" "+d;
	if(channels>1){
		Stack.getPosition(channel, dummy, dummy);
		line="Ch"+channel+" "+a+" "+b+" "+c+" "+d;
	}
	getLine(x1, y1, x2, y2, lineWidth);
	makeLine(x1, y1, x2, y2, line_thickness);
	Y=getProfile();
	len=Y.length;
	
	X=newArray(len);
	for(i=0;i<len;i++){
		X[i]=i*pixelHeight;
	}
	
	Fit.doFit("Gaussian", X, Y);
	r2=Fit.rSquared;
	if(r2<0.9){
		showMessage("Warming: Poor Fitting",r2);
	}
//	Fit.plot();
//	if(isOpen("y = a + (b-a)*exp(-(x-c)*(x-c)/(2*d*d))")){
//		selectWindow("y = a + (b-a)*exp(-(x-c)*(x-c)/(2*d*d))");
//		rename(line);
//	}
	sigma=Fit.p(3);
	FWHM=abs(2*sqrt(2*log(2))*sigma);
	myTable(slice_name,line,FWHM,unit);
	//selectImage(id0);
	//selectWindow("FWHM");
		
	selectWindow(window_name);
}


function myTable(slice_name,a,b,c){
	title1="FWHM";
	title2="["+title1+"]";
	if (isOpen(title1)){
   		print(title2, slice_name+"\t"+a+"\t"+b+"\t"+c);
	}
	else{
   		run("Table...", "name="+title2+" width=400 height=200");
   		print(title2, "\\Headings:SliceName\tLine\tFWHM\tUnit");
   		print(title2, slice_name+"\t"+a+"\t"+b+"\t"+c);
	}
}
