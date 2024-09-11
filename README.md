Kelfoun K., P. Samaniego, P. Palacios, D. Barba, 2009, Testing the suitability of frictional 
behaviour for pyroclastic flow simulation by comparison with a well-constrained eruption at 
Tungurahua volcano (Ecuador). Bulletin of Volcanology, 71(9), 1057-1075, DOI: 10.1007/s00445-009-0286-6.

Kelfoun K., Santoso A.B., Latchimy T., Bontemps M., Nurdien I., Beauducel F., Fahmi A., 
Putra R., Dahamna N., Laurin A., Rizal M.H., Sukmana J.T., Gueugneau V. (2021). Growth 
and collapse of the 2018−2019 lava dome of Merapi volcano. Bulletin of Volcanology – DOI:10.1007/s00445-020-01428-x


--------------------------------------------------------------------------
The purpose of this simple script is to optimize volume and CRS values on
volcano specific scenarios for use on a single-fluid version of VolcFlow 
(a software developed by Karim Kelfoun and collaborators at the Laboratoire Magmas et Volcans, Clermont-Ferrand)

For this optimization (constraining) of volume and CRS values, randomized bin iterations containing numerical ranges 
for each of the two parameters are defined.
The ranges included in the script are examples, and are project dependent.
Preliminary tests confirmed the following relationship: 
The higher the volume of a flow, the lower the CRS must be to account for this, the same is true viceversa.

Lastly, the script also allows for the comparison of the area outputs against observed/mapped deposit footprint coverage.

The match and mismatch between the observed area and the simulated area covered is quantified via a series of validation and bayesian metrics
that also take place as part of this script as explained below:

Best fit Metrics:

	Jaccard Similarity Coefficient (Jaccard Fit), Rj - It uses TP as the 
		numerator and the union of areasinundated by observed and simulated flows for the denominator. 
		If FN or FP increase in relation to TP, then the Jaccard fit decreases (Charbonnier et. al 2018).
		= |Aobs∩Asim|/|Aobs∪Asim|*100 = (TP/TP+FN+FP)*100

	Model Sensitivity, Rms - It outputs the percentage of area of observed flow that the simulation correctly predicts, 
		with no penalty for FP (Charbonnier et. al 2018).
		= |Aobs∩Asim|/|Asim|*100 = (TP/TP+FP)*100

-	Model Precision, Rmp - A simulation with high R might indicate either a good match between the simulated andobserved areas (high TP) 
		or that areas thought to be safe from inundation based on the simulation are inundated by theobserved deposits (high FN) 
		(Charbonnier et. al 2018).
		= |Aobs∩Asim|/|Aobs|*100 = (TP/TP+FN)*100

	Percent Length Ratio, Rl - compares maximum observed and simulated flow runout. 
		Where L is thesimulated flow length and LOBS is the observed flow length (Spataro et al. 2004; Charbonnier et. al 2018)
		= Lsim/Lobs*100

Where:
	Aobs = Total area inundated observed
	Lobs = Total length observed
	Asim = Total area inundated by the simulation
	Lsim = Total length inundated by the simulation
	TP = True Positive
	FP = False Positive
	FN = False Negative

Note: Rl, Rj, Rms, and Rmp are all represented as percentages

VolcFlow variables used as part of this script:
	V = bolume
	Cohesion = constant retarding stresses (CRS)

Finally this script finds the best simulation via a sum of the percentages for all 4 metrics and assigns a score (sum of all metrics)
The simulation with the highes score is demmed as the best combination of volume and CRS values

--------------------------------------------------------------------------

This script works in conjuction with an input file that must be written to use VolcFlow in the first place

'toposcript_InputFile.m' is the user defined toposcript input file mentioned

In addition to this a few other files are required:

'source_cond.m' = Example file to define the source conditions at the "vents" 
(should be referenced as part of 'toposcript_InputFile.m' and not in BE-CRATER)

'DEM_GridFile_Example.grd' = Example grid file for desired DEM (should be referenced as part of 'toposcript_InputFile.m' and not in BE-CRATER)

'Deposit_Footpring.png' = Example of mapped deposit footprint PNG file 

'VolcFlow.p' = Necessary for VolcFlow to run

'VolcFlowFig.fig' = Necessary for VolcFLow to run

--------------------------------------------------------------------------

Instructions

- Make sure all the required files (above) are prepared appropriately.
- This will be largely dependent the approach the user takes

- After setting up the number of loops in the first portion
- Set each bin to cover a certain number of loops (3 per loop recommended)
- Make sure to set the volume ranges for each loop
- Then also set the CRS ranges for each bin
- Finally run the code

--------------------------------------------------------------------------

END
