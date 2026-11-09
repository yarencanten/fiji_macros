// Kymograph batch saver for KymoResliceWide
// Draw a line selection on your timelapse first, then run.

if (nImages == 0) exit("No image open.");
origID = getImageID();

// Need a line selection
selType = selectionType();
if (selType < 5 || selType > 7) exit("Please draw a line selection (straight, segmented or freehand) first.");

// Need a timelapse
getDimensions(w, h, c, z, t);
if (nSlices < 2) exit("Image doesn't look like a timelapse.");

// Name without extension
title = getTitle();
dot = lastIndexOf(title, ".");
if (dot > 0) root = substring(title, 0, dot);
else root = title;

// Parent directory: image's folder, or ask if image was never saved
parent = getDirectory("image");
if (parent == "") parent = getDirectory("Choose a folder to create the output folder in");

// Guard: refuse to run if already inside an "analysis" folder
parentCheck = toLowerCase(replace(parent, "\\\\", "/"));
if (indexOf(parentCheck, "/analysis/") >= 0)
    exit("This image is already inside an 'analysis' folder:\n" + parent + "\nRefusing to run, to avoid creating analysis/analysis/...");

// Make output folder
analysisDir = parent + "analysis" + File.separator;
if (!File.exists(analysisDir)) File.makeDirectory(analysisDir);

outDir = analysisDir + root + File.separator;
if (!File.exists(outDir)) File.makeDirectory(outDir);

// 1. Save the ROI
saveAs("Selection", outDir + root + "_ROI.roi");

// 2. Run KymoResliceWide and save the kymograph
run("KymoResliceWide", "intensity=Maximum");
kymoTitle = getTitle();
saveAs("Tiff", outDir + root + "_kymograph.tif");

// 3. Save the full timelapse as TIFF
selectImage(origID);
saveAs("Tiff", outDir + root + ".tif");

print("Saved to: " + outDir);

// 4. Open the kymograph
open(outDir + root + "_kymograph.tif");