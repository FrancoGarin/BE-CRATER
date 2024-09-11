% BEnchmark and Calibration via RAndomization of parameTERs (BE-CRATER) for VolcFlow

% By: Franco Garin, Sylvain J. Charbonnier, and Valentin Gueugneau

% Volcanology Research Group, School of Geosciences
% University of South Florida
% Email: francoalainv@usf.edu
% ResearchGate: https://www.researchgate.net/profile/Franco-Garin

% Originally created: May 20th, 2020
% Last updated: September 11th, 2024

% Version: v1.0 (Initial release)
% This script is shared under a GNU AGPLv3 license (Please see LICENSE.txt)

% "BE-CRATER for VolcFlow" was formerly known as VulcaVBM (See AGU2021
% Abstract)

% Please cite: 

% Villegas-Garin F., Charbonnier S., Gueugneau V., Rodriguez L., Escobar-Wolf R. (2021) 
% A Multifaceted Model Validation Approach for Pyroclastic Currents: The June 3rd, 2018 
% Pyroclastic Currents at Fuego Volcano (Guatemala). In:  AGU Fall Meeting Abstracts. pp NH25A-0543
% DOI: 10.13140/RG.2.2.25706.18881/2.

%--------------------------------------------------------------------------

% ***BE-CRATER requires a simple script written to work in conjunction with
% the VolcFlow single-fluid version only*** VolcFlow runs in MATLAB or GNU
% Octave

% The VolcFlow simulation code is distributed and written by
% Karim Kelfoun at Laboratoire Magma et Volcans, Clermont-Ferrand, France.

% Kelfoun K. and T.H. Druitt, 2005, Numerical modelling of the emplacement of the 7500 BP 
% Socompa rock avalanche, Chile. J. Geophys. Res., B12202, doi : 10.1029/2005JB003758, 2005.

% Kelfoun K., P. Samaniego, P. Palacios, D. Barba, 2009, Testing the suitability of frictional 
% behaviour for pyroclastic flow simulation by comparison with a well-constrained eruption at 
% Tungurahua volcano (Ecuador). Bulletin of Volcanology, 71(9), 1057-1075, DOI: 10.1007/s00445-009-0286-6.

% Kelfoun K., Santoso A.B., Latchimy T., Bontemps M., Nurdien I., Beauducel F., Fahmi A., 
% Putra R., Dahamna N., Laurin A., Rizal M.H., Sukmana J.T., Gueugneau V. (2021). Growth 
% and collapse of the 2018−2019 lava dome of Merapi volcano. Bulletin of Volcanology – DOI:10.1007/s00445-020-01428-x

%--------------------------------------------------------------------------

% The following 'BE-CRATER for VolcFlow' is a simple m file script meant to be
% used in MATLAB or GNU Octave (please modify as needed for the latter as
% needed)
% The purpose of this simple script is to set up randomization in bins
% to calibrate or benchmark VolcFlow outputs [single-fluid version] to
% constrain the volume and CRS that offer the best fit when compared against
% the mapped footprint of deposits from pyroclastic density currents (can
% also be used for other flows that VolcFlow is used to simulate. The best fit assessment 
% is achieved via the following metrics: the Jaccard similarity coefficient,
% model sensitivity, model precision, and percent length ratio.

% Please see:
% Charbonnier SJ, Connor CB, Connor LJ, Sheridan MF, Oliva Hernández JP, Richardson JA  (2018) 
% Modeling the October 2005 lahars at Panabaj (Guatemala). Bulletin of Volcanology, 80, 1-16, 
% doi: https://doi.org/10.1007/s00445-017-1169-x
% to appropriately cite and describe these metrics

% Also check "README" file for script description and uses

%--------------------------------------------------------------------------

% Best-fit Assessment Metrics:

% Percent length ratio, Rl 
% = Lsim/Lobs*100

% Jaccard similarity coefficient (Jaccard Fit), Rj
% = |Aobs∩Asim|/|Aobs∪Asim|*100
% = (TP/TP+FN+FP)*100

% Model sensitivity, Rms
% = |Aobs∩Asim|/|Asim|*100
% = (TP/TP+FP)*100

% Model precision, Rmp
% = |Aobs∩Asim|/|Aobs|*100
% = (TP/TP+FN)*100

% Where:
% Aobs = Total area inundated observed
% Lobs = Total length observed
% Asim = Total area inundated by the simulation
% Lsim = Total length inundated by the simulation
% TP = True Positive
% FP = False Positive
% FN = False Negative

% Note: Rl, Rj, Rms, and Rmp are all represented as percentages

% VolcFlow variables used as part of this script:
% V = Volume
% Cohesion = constant retarding stresses (CRS)

%--------------------------------------------------------------------------

% This script works in conjuction with an input file that must be written
% to use VolcFlow in the first place

% 'toposcript_InputFile.m'
% is the user defined toposcript input file mentioned

% In addition to this a few other files are required:
% 'source_cond.m' = Example file to define the source conditions at the
% "vents" (should be referenced as part of 'toposcript_InputFile.m' and not in BE-CRATER)
% 'DEM_GridFile_Example.grd' = Example grid file for desired DEM (should be
%  referenced as part of 'toposcript_InputFile.m' and not in BE-CRATER)
% 'Deposit_Footpring.png' = Example of mapped deposit footprint PNG file 
% 'VolcFlow.p' = Necessary for VolcFlow to run
% 'VolcFlowFig.fig' = Necessary for VolcFLow to run

%--------------------------------------------------------------------------

% Instructions

% Make sure all the required files (above) are prepared appropriately.
% This will be largely dependent the approach the user takes

% After setting up the number of loops in the first portion
% Set each bin to cover a certain number of loops (3 per loop recommended)
% Make sure to set the volume ranges for each loop
% Then also set the CRS ranges for each bin
% Finally run the code

%--------------------------------------------------------------------------

close all %closes everything prior (on the common line)
clear all %clears everything prior (on the common line)

open volcflowfig.fig;  % MANDATORY
set(findobj('tag','script'),'string',0); % Initializes VolcFlow to run as a script

autofilename='toposcript_InputFile.m' %input file the loops are based on

% Make sure that volume and constant retarding Stresses (CRS) are defined by 
% 'V' and 'cohesion', respectively, within the "toposcript_InputFile.m"

% Example:
% V= 10e6 ; % Volume for the Pyroclastic Density Current
% cohesion = 2500 ; % CRS for the Pyroclastic Density Current

% These parameters will be overwritten by the Bin Randomized Volume and CRS
% portion below

% First Portion (Bin Randomized Volume and CRS)

for loop = 1:15 % 15 loops (can be modified)
    
   if loop <= 3 % 1st Bin (loop 1, 2, & 3)
        V = (rand(1,1) * 5e6) + 20e6 % Randomized values between 20e6 and 25e6 for V
        cohesion = (rand(1,1) * 3000) + 4000 % Randomized values between 4000 Pa and 7000 Pa
        
        
    elseif loop >= 4 & 6 >= loop % 2nd Bin (loop 4, 5, & 6)
        V = (rand(1,1) * 5e6) + 25e6 % Randomized values between 25e6 and 30e6 for V
        cohesion = (rand(1,1) * 3000) + 5000 % Randomized values between 5000 Pa and 8000 Pa
        
        
    elseif loop >= 7 & 9 >= loop % 3rd Bin (loop 7, 8, & 9)
        V = (rand(1,1) * 5e6) + 30e6 % Randomized values between 30e6 and 35e6 for V
        cohesion = (rand(1,1) * 3000) + 6000 % Randomized values between 6000 Pa and 9000 Pa
        
        
    elseif loop >= 10 & 12 >= loop % 4th Bin (loop 10, 11, & 12)
        V = (rand(1,1) * 5e6) + 35e6 % Randomized values between 35e6 and 40e6 for V
        cohesion = (rand(1,1) * 3000) + 7000 % Randomized values between 7000 Pa and 10000 Pa
        

    elseif loop >= 13 % 5th Bin (loop 13, 14, & 15)
        V = (rand(1,1) * 5e6) + 40e6 % Randomized values between 40e6 and 45e6 for V
        cohesion = (rand(1,1) * 3000) + 8000 % Randomized values between 8000 Pa and 11000 Pa
        
        
   end %ends if and elseif statements for the bins
    
    save('bin.mat','cohesion','V') % temporary bin mat file
    %overrides values for CRS and volume on the 'toposcript' file
    
    VolcFlow %Opens Volcflow
    dd=sprintf('Output_Volcano_%d.mat', loop) % s-print-f (means write in terms of string characters)
    save(dd, 'h','cohesion','V') %save the final thickness, the CRS, and the volumes for the simulation
end

% Loops end and first portion ends


% Second Portion (Best-fit metric computation)
                                                    
% Rl = []; % Since Rl isn't automated, this variable was commented
Rj = []; % Rj variable established (empty)
Rmp = []; % Rmp variable established (empty)
Rms = []; % Rms variable established (empty)

% Read deposit footprint
shp = double(imread('Deposit_Footpring.png')); % Reads the footprint [deposit] file, also set the variable to be read as "double code"
ind = find(shp==0); % Index of the position of shape = 0 (the black bar error on the representation generated by photoshop)
shp(ind) = 255; % Takes only the coordinates ind, inside of the variable shape, and attribute them the value 255 (Sets black bar error to be 255 white)
shp = shp(:,:,2); % Takes every line, every column, and sets the green chanel from RGB on the shape to be the only one used
ind = find(shp<255); % Find on shapefile positons that are smaller than 255
shp(ind)=1; % Cells of coordinate ind inside of the variable shape attribute them the value 1 (shape of ind, e.g. the shape variables with the position ind)
ind = find(shp>1); % Find on shapefile positons that are greater than 1
shp(ind)=0; % Cells of coordinate ind inside of the variable shape attribute them the value 0 (to keep it consistent with line 63)
shp(61,:)=0; % Fixes error bart showing up on row 61 of the representation and every column on row 61


% Obs Runout Length (calculations for the Rl for the shp file)
xh = 113; yh = 106; xl = 1481; yl = 1942; % DEM shp file specific index values (change depending on DEM)
X = (xl - xh)*5; % substracts x(high) from x(low), multiplies it by 5 (number of meters)
Y = (yl - yh)*5; % substracts x(high) from x(low), multiplies it by 5 (number of meters)
Lobs = hypot (X,Y); %

% Simulated Runout Length (manually measured), had to input each value individually
Lsim = [10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500, 10500]; 
% Manual measurments for each flow, taken manually using method below
% Use imtool(h) on the command line, load your Output file before %straight line % manual 
Rl = (Lsim./Lobs)*100 ; %calculates Rl from line 70 and 72

 for loop=1:15 % Selects all loops (15 loops total)
    loop
    dd=sprintf('Output_Volcano_%d.mat', loop); %dd is the data in the loops
    load(dd); % Loads the data, so (dd)
    H=h; % Sets variable H to be the h variable for working
    ind = find(H>0.001); % For the index (position) find any values greater than 0.001
    H(ind) = 1; % Atribute the value 1 for the coordinate ind inside the variable shape
    H = flipud(H); % Flips H right-side-up. Where do you do equal axis?

    Union = shp + H; % The union between the original shpfile and the simulated H
    ind= find(Union==2); % Find on Union positons that are equal to 2
    [nrow,ncol] = size(ind); % Quantity of the cells where a position is present, only accounting for rows as there is only 1 column
    TP = nrow*25; % for a 5 meter dem, so the True Positive reading gets multiplied by 5x5 (meaning 25), will give you the cross-sectional area
    
    Overestimate = H - shp; % The union between the original shpfile and the simulated H 
    ind= find(Overestimate==1); % Find on Overestimate positons that are equal to 1 
    [nrow,ncol] = size(ind); % Quantity of the cells where a position is present, only accounting for rows as there is only 1 column
    FP = nrow*25;  % for a 5 meter dem, so the False Positive reading gets multiplied by 5x5 (meaning 25)
    
    Underestimate = shp - H; % The union between the original shpfile and the simulated H 
    ind= find(Underestimate==1); % Find on Underestimate positons that are equal to 1 
    [nrow,ncol] = size(ind); % Quantity of the cells where a position is present, only accounting for rows as there is only 1 column
    FN = nrow*25;  % for a 5 meter dem, so the False Negative reading gets multiplied by 5x5 (meaning 25)
    
    Null = shp + H; % Only to keep the idea, it isn't considered, as it is 0
    ind= find(Null==0); % Find on Null positons that are equal to 0
    [nrow,ncol] = size(ind); % Quantity of the cells where a position is present, only accounting for rows as there is only 1 column
    TN = nrow*25;  % for a 5 meter dem, so the True Negative reading gets multiplied by 5x5 (meaning 25)
    
    rj = (TP / (TP + FN + FP)) * 100 ; % Calculates rj ("virtual variable" for Rj)
    rmp = (TP / (TP + FP)) * 100 ; % Calculates rmp ("virtual variable" for Rmp)
    rms = (TP / (TP + FN)) * 100 ; % Calculates rms ("virtual variable" for Rms)

    Rj = [Rj,rj]; % Defines Rj from "virtual variable" rj
    Rmp = [Rmp,rmp]; % Defines Rmp from "virtual variable" rmp
    Rms = [Rms,rms]; % Defines Rms from "virtual variable" rms

 end
 
 Rl % Restastes Rl in preparation for calculations below
 Rj % Restastes Rj in preparation for calculations below
 Rmp % Restastes Rmp in preparation for calculations below
 Rms % Restastes Rms in preparation for calculations below
 

% Calculate the average of the four metrics
Sum = (Rj + Rmp + Rms + Rl) / 4; % Averages all the metrics

Best = find(Sum==max(Sum)); % Finds the best simulation (max value for averaged metrics)
dd = sprintf('Output_Volcano_%d.mat',Best); % Loads the simulations .mat file
load(dd) % Second step in the .mat simulation

fprintf(1,'My best simulation was obtained for V = %d and CRS = %d\n', V, cohesion) % Outputs V & CRS values of the best simulation
