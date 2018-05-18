//Mesh for the 2D air exchange paper by Xie et al (2006)

w = 1.0;
h = 1.0;
boundaryLayerElements = 4;
cellsInBoundaryLayer = 1;
horizontalSize = 0.05;
verticalSize = horizontalSize*boundaryLayerElements;


Point(1) = {0,0,0};

For I In {2:20}
	Point(I) = {(I-1)*w,0,0};
EndFor

l1 = newl;
For I In {1:19}
	Line(l1) = {I+1,I};
	Transfinite Line{l1} = Ceil(w/horizontalSize) Using Bump 0.5;
	l1++;
EndFor

Extrude{0,h,0}{
	Line{1:19}; Layers{{cellsInBoundaryLayer*boundaryLayerElements,Ceil((h-cellsInBoundaryLayer*verticalSize)/verticalSize)},{cellsInBoundaryLayer*verticalSize/h,1.0}}; Recombine;
}

Transfinite Line{20:92:8} = Ceil(w/horizontalSize) Using Bump 0.5;

Extrude{0,3*h,0}{
	Line{20:92:4}; Layers{{cellsInBoundaryLayer*boundaryLayerElements,Ceil((3*h-cellsInBoundaryLayer*verticalSize)/verticalSize)},{cellsInBoundaryLayer*verticalSize/(3*h),1.0}}; Recombine;
}

Recursive Delete{
	Surface{23:95:8}; Line{93};
} 

Extrude{0,0,1}{
	Surface{27:171:8,103:167:8}; Layers{1}; Recombine;
}

Physical Surface("inlet") = {382};
Physical Surface("outlet") = {588};
Physical Surface("buildings") = {378, 184, 206, 228, 250, 272, 294, 316, 338, 360, 192, 214, 236, 258, 280, 302, 324, 346, 368, 400, 422, 444, 466, 488, 510, 532, 554, 576, 378};
Physical Surface("roads") = {180:356:22};
Physical Surface("atmosphere") = {584, 782, 562, 760, 540, 738, 518, 716, 496, 694, 474, 672, 452, 650, 430, 628, 408, 606, 386};
Physical Surface("sides") = {391, 611, 193, 413, 633, 215, 435, 655, 237, 457, 677, 259, 699, 479, 281, 303, 721, 501, 523, 743, 325, 545, 765, 347, 567, 787, 369, 589, 99, 103, 107, 27, 35, 111, 115, 43, 119, 123, 51, 127, 131, 135, 59, 139, 143, 67, 147, 151, 75, 155, 159, 83, 163, 167, 91, 171};
Physical Volume("internal") = Volume "*";
