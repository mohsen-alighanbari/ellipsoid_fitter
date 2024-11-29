This software is part of the publication with title "Enclosing 95% confidence 
area and volume to center of pressure and center of mass in posturography 
using optimization and coordinate ascent methods." under review in 
the Computers in Biology and Medicine Journal. 

Please cite the above publication if you are using all or parts of this 
code. 

/////////////////////////////////////// Instructions /////////////////////////////////////////////



\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  Center of pressure \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
For CoP data:
In order to enclose ellipse to 95% CoP data, the below function can be used:
[area_optimization,area_pca_paper,area_data_trimmer,area_pca,optimization_final_percent,data_trimmer_final_percent,pca_final_percent,caa_time,trim_time,optim_time,pca_paper_time,pca_time] = MVEE_2d_v11(x,y,do_plot,do_display)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input to the MVEE_2d_v11 function:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x: Represent the CoP movement in the anteroposterior direction
y: Represent the CoP movement in the mediolateral direction
do_plot: plotting the enclosed ellipse to the CoP data using an optimization algorithm, data trimmer, PCA, and Covariate methods. 
do_display:  display the performance of all the methods in the Matlab command window.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Output of the MVEE_2d_v11 function:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
area_optimization: Export the area of the enclosed ellipse to 95% of the data using an optimization algorithm
area_pca_paper: Export the area of the enclosed ellipse to 95% of CoP data using a covariance method.
area_data_trimmer: Export the area of the enclosed ellipse to 95% of CoP data using the data trimmer method.
area_pca: Export the area of the enclosed ellipse to 95% of CoP data using the PCA method.
optimization_final_percent_data: Indicating a percentage of samples encompassed with an ellipse using an optimization algorithm. 
data_trimmer_final_percent: Indicating a percentage of samples encompassed with an ellipse using a data trimmer method.
pca_final_percent: Indicating a percentage of samples encompassed with an ellipse using a PCA method.
caa_time: Export the duration of the initial optimization for both the optimization algorithm and data-trimmer methods. 
trim_time: Export the time cost of the data trimmer method when enclosing ellipse to 95% of CoP data.  
optim_time: Export the time cost of the optimization algorithm when enclosing ellipse to 95% of CoP data.
pca_paper_time: Export the time cost of the covariance method when enclosing ellipse to 95% of CoP data.
pca_time: Export the time cost of the PCA method when enclosing ellipse to 95% of CoP data.




\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ For the CoM data:  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
For the CoM data, the below function can be used:
[data_trimmer_approach_volume,optimization_approach_volume,pca_approach_volume,percentage_points_inside_initial_ellipsoid,percentage_points_inside_data_trimmer_ellipsoid,percentage_points_inside_optimization_ellipsoid,percentage_points_inside_pca_ellipsoid,CAA_time,optim_time,trim_time,pca_time] = MVEE_3d_v12(x,y,z,do_plot,do_display,tolerance);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Input to MVEE_3d_v12 function: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x: Represent the CoM movement in the anteroposterior direction
y: Represent the CoM movement in the mediolateral direction
z: Represent the CoM movement in the vertical direction
do_plot: Plotting the enclosed ellipsoid to the CoM data using an optimization algorithm, data trimmer, and PCA methods. 
do_display: Display the performance of all the methods in the Matlab command window.
tolerance: Set tolerance value for the initial optimization. It should be selected as 1e-3 for data lower than 0.0001 and 1e-7 for other scenarios.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Output of the MVEE_3D_v12 function:  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_trimmer_approach_volume: Export the ellipsoid volume fitted with the data trimmer method to the CoM data. 
optimization_approach_volume: Export the ellipsoid volume enclosed with the optimization algorithm to the CoM data.
pca_approach_volume: Export the ellipsoid volume enclosed with the PCA approach to the CoM data.
percentage_points_inside_initial_ellipsoid: Export the percentage of samples enclosed in the ellipsoid with the initial optimization for both the optimization algorithm and data trimmer methods.
percentage_points_inside_data_trimmer_ellipsoid: Export the percentage of samples fitted in the ellipsoid using the data trimmer method.
percentage_points_inside_optimization_ellipsoid: Export the percentage of the samples fitted in the ellipsoid using the optimization algorithm.
percentage_points_inside_pca_ellipsoid: Export the percentage of samples fitted in the ellipsoid using the PCA method.
CAA_time: Export the time cost of the initial optimization for both the optimization and data trimmer methods.
optim_time: Export the time cost of the optimization algorithm to enclose ellipsoid to 95% of the CoM data. 
trim_time: Export the time cost of the data trimmer method to enclose ellipsoid to 95% of the CoM data.
pca_time: Export the time cost of the PCA method to enclose ellipsoid to 95% of the CoM data.
 