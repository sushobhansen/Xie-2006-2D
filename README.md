## Purpose
OpenFOAM implementation of the paper by Xie et al (2006) to simulate 2D flow in a series of street canyons with floor (not wall) heating by solving the RANS equations with realizable k-epsilon turbulence model and standard wall functions. 

The characteristic length is H, the height of the buildings (set to 1 m). The aspect ratio is fixed at 1.0. Using air as a fluid, Re based on H is fixed at 3500. Using inlet temperature and road temperature as reference values, again for air, Rb is set at -0.21 (using dynamic data, it turned out to be closer to -0.18, but that did not change the results significantly). 

## Mesh
Meshing was performed using the Extrusion-Exclusion method proposed by Van Hooff and Blocken (2010) implemented on Gmsh. The mesh is generated such that the prismatic layers at boundaries have an aspect ratio of 1, after which there is growth. To generate the mesh, use:

`gmsh 2d.geo -2 -o 2d.msh
gmshToFoam 2d.msh`

Then, in constant/polyMesh/boundary, change sides to empty, roads and buildings to wall, and atmosphere to symmetry.
The Gmsh script is written using certain parameters for the spacing and number of prismatic elements, you can play with them as necessary. The mesh is structured and conformal. It is in 3D because OpenFOAM only accepts 3D meshes; however, there is only one layer of cells in the z direction (note that +y is up). See OpenFOAM user guide to understand this. 

## Run Case
The case can be run in serial by simply calling he buoyantBoussinesqSimpleFoam solver. However, this case is also written up for a parallel run. I had 2 cores available, so I simply used simpleCoeffs in system/decomposeParDict to split the mesh into two equal halves. Again, see OpenFOAM documentation for more. Then, run the case using:

`bash runthis`

Setting -np to the appropriate number of cores for renumberMesh and the solver in runthis. I wasn't able to run decomposePar in parallel (perhaps it shouldn't be?). The solver output is dumped to stdout (your screen) but also to a log file for postprocessing. The solver is run to 2000 iterations or a residual of 1e-6 for everything, but these options can be changed in system/controlDict and system/fvSolution. I used a lot of first-order schemes in system/fvSchemes, you can use others. See OpenFOAM documentation. 

## Postprocessing
After running, the solution is reconstructucted into one directory. The components of U are obtained for the latest time step. For validation, a singleGraph utility (defined in system/singleGraph) is used to extract the temperature and velocity components along the vertical centerline (x=9.5) of the middle canopy. yPlus is also evalutuated and while it is possible that yPlus does not meet the criteria of being between 5 and 30, the results are still good. Finally, Cd and Cl monitors are also placed in system/constrolDict.functions. OpenFOAM places post-processing results in a separate folder that it creates.

Finally, to generate post-processing plots, simply run (requires python3, numpy, and matplotlib):

`bash plotresiduals`

As the name suggests, it first plots residuals. There should no wiggles except possibly in p when the solution is just about at convergence. Next, it plots the drag and lift coefficient monitors - I didn't really define the reference values properly for lift, so it should just be stable. Cd will be stable and close to (but less than) the flat horizontal plate solution of Cd = 0.001. Finally, it will plot the normalized temperature and x component of wind speed profiles together with data points from Xie et al (2006). In addition, wind tunnel data from Uehara et al (2000) and simulation data from Kim and Baik (2001) are also plotted. 

The results are good, keeping in mind experimental errors, differences in definition of Rb, differences in roughness (model considers z0 as zero because the wind tunnel test doesn't report anything for it), and potential wall heating not reported.

## References
- Van Hooff, T., & Blocken, B. (2010). Coupled urban wind flow and indoor natural ventilation modelling on a high-resolution grid: A case study for the Amsterdam ArenA stadium. Environmental Modelling & Software, 25(1), 51-65.
- Xie, X., Liu, C. H., Leung, D. Y., & Leung, M. K. (2006). Characteristics of air exchange in a street canyon with ground heating. Atmospheric Environment, 40(33), 6396-6409.
- Uehara, K., Murakami, S., Oikawa, S., & Wakamatsu, S. (2000). Wind tunnel experiments on how thermal stratification affects flow in and above urban street canyons. Atmospheric Environment, 34(10), 1553-1562.
- Kim, J. J., & Baik, J. J. (2001). Urban street-canyon flows with bottom heating. Atmospheric Environment, 35(20), 3395-3404.
