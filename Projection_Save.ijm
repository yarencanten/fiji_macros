// Save a Z projection into parent/analysis/root/
// Filename: root_<TYPE>_<start>-<stop>.tif  e.g. myimage_MAX_5-20.tif

if (nImages == 0) exit("No image open.");
origID = getImageID();
if (nSlices < 2) exit("Image is not a stack.");

title = getTitle();
dot = lastIndexOf(title, ".");
if (dot > 0) root = substring(title, 0, dot);
else root = title;

parent = getDirectory("image");
if (parent == "") parent = getDirectory("Choose a folder to create the output folder in");

// Guard: refuse to run if already inside an "analysis" folder
parentCheck = toLowerCase(replace(parent, "\\\\", "/"));
if (indexOf(parentCheck, "/analysis/") >= 0)
    exit("This image is already inside an 'analysis' folder:\n" + parent + "\nRefusing to run.");

// Dialog: start, stop, projection type
types = newArray("Max Intensity", "Average Intensity", "Sum Slices", "Standard Deviation", "Median", "Min Intensity");
short = newArray("MAX", "AVG", "SUM", "STD", "MED", "MIN");
Dialog.create("Projection (stack has " + nSlices + " slices)");
Dialog.addNumber("Start slice:", 1);
Dialog.addNumber("Stop slice:", nSlices);
Dialog.addChoice("Projection type:", types, "Max Intensity");
Dialog.show();
startSlice = Dialog.getNumber();
stopSlice = Dialog.getNumber();
projType = Dialog.getChoice();

if (startSlice < 1 || stopSlice > nSlices || startSlice > stopSlice)
    exit("Invalid slice range (stack has " + nSlices + " slices).");

for (i = 0; i < types.length; i++) if (types[i] == projType) tag = short[i];

// Make folders
analysisDir = parent + "analysis" + File.separator;
if (!File.exists(analysisDir)) File.makeDirectory(analysisDir);
outDir = analysisDir + root + File.separator;
if (!File.exists(outDir)) File.makeDirectory(outDir);

// Project and save
selectImage(origID);
run("Z Project...", "start=" + startSlice + " stop=" + stopSlice + " projection=[" + projType + "]");
saveAs("Tiff", outDir + root + "_" + tag + "_" + startSlice + "-" + stopSlice + ".tif");

print("Saved to: " + outDir);