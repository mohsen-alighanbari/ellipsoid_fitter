% MIT License
% 
% Copyright (c) 2024 Mohsen Alighanbari, Sina Alighanbari, Lisa Griffin
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

function [area_optimization,area_pca_paper,area_data_trimmer,area_pca,optimization_final_percent,data_trimmer_final_percent,pca_final_percent,caa_time,trim_time,optim_time,pca_paper_time,pca_time] = MVEE_2d_v11(x,y,do_plot,do_display,tolerance)

%%%%%%%%%%%%%%%%%%%% INPUT PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x is the input data.
% y is the input data.
%
% do_plot is a boolean flag that enables plotting ellipses, set to false by default;
%
% do_display is a boolean flag that enables displaying messages to command window, set to false by default;
%%%%%%%%%%%%%%%%%%%%% OUTPUT PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% area_optimization: is the calculated area of the optimization method
%
% area_pca_paper: is the calculated area of the method mentioned in paper (very close to pca method)
%
% area_data_trimmer: is the calculated area of the trimming data through
% iterations method after initial MVEE calculation
%
% area_pca: is the calculated area of the pca method 
%
% optimization_final_percent: Final percentage of points inside ellipse
% determined by optimization method
%
% data_trimmer_final_percent: Final percentage of points inside ellipse
% determined by data trimmer method
%
% pca_final_percent: Final percentage of points inside ellipse
% determined by pca method
%
% caa_time: Wall clock tome for CAA algorithm
%
% trim_time: Wall clock time for data trimmer approach
%
% optim_time: Wall clock time for optimization
% 
% pca_paper_time: Wall clock time for PCA method
%
% pca_time: Wall clock time for PCA method2



if (nargin < 1), error('Please input X'); end
if ~iscolumn(x), error('The X vector is not column vector'); end
if (nargin < 2), error('Please input Y'); end
if ~iscolumn(y), error('The Y vector is not column vector'); end
if (nargin < 3), do_plot=false; end
if (nargin < 4), do_display=false; end


% Constructing the required input matrix for coordinate ascent algorithm
%Columns of the X vector should be our data points. X matrix should be 2*m
%where m is number of datat points
for i=1:size(x)
    X_original(1,i) = x(i,1)-mean(x);
    X_original(2,i) = y(i,1)-mean(y);
end

% calling the coordinate ascent algorithm on original data to find the best fit ellipse
tic;
[u,R,factor,improv,mxv,mnv,flagstep,lamhist,var,time,iter,act,major_semi_length,minor_semi_length,major_angle] = minvol(X_original,X_original,tolerance);
elapsed_CAA_time = toc;
caa_time = elapsed_CAA_time;

%%%%%%%%%%%%%% The data trimmer approach %%%%%%%%%%%%%%%%%%%

% Trimming the data based on calculated ellipse
tic;
[x_t,y_t,major_length_trim, minor_length_trim] = data_trimmer_ellipse(x,y,major_semi_length,minor_semi_length,major_angle);
data_trim_time = toc;
trim_time = data_trim_time;
for i=1:size(x_t)
    X(1,i) = x_t(i,1)-mean(x);
    X(2,i) = y_t(i,1)-mean(y);
end

% Calculating the percent of data inside the ellipse and area of the
% ellipse.
data_trimmer_final_percent = percent_finder(x,y,major_length_trim,minor_length_trim,major_angle);
area_data_trimmer = pi*major_length_trim*minor_length_trim;

if do_display
    disp(['The percentage of points inside ellipse (data trimmer) is: ' , num2str(data_trimmer_final_percent)]);
    disp(['The final area of data trimmer method is: ' , num2str(area_data_trimmer)]);
end

%%%%%%%%%%%%%% The optimization approach %%%%%%%%%%%%%%%%%%%
tic;
X_optim = x-mean(x);
Y_optim = y-mean(y);
save("optim_required_2d.mat","X_optim", "Y_optim","major_angle");

fun = @(p)pi*p(1)*p(2);
if do_display
    options = optimoptions('fmincon','Display','iter',"Algorithm","active-set","MaxFunctionEvaluations",3e+10,"MaxIterations",1000);
else
    options = optimoptions('fmincon',"display","none","Algorithm","active-set","MaxFunctionEvaluations",3e+10,"MaxIterations",1000);
end
A=[];b=[];Aeq=[];beq=[];lb=[major_length_trim-0.9*major_length_trim,minor_length_trim-0.9*minor_length_trim];ub=[major_length_trim+0.9*major_length_trim,minor_length_trim+0.9*minor_length_trim];
nonlcon = @max_percent_nonlcon_2d;
p0= [major_length_trim+0.3*major_length_trim,minor_length_trim+0.3*minor_length_trim];
p = fmincon(fun,p0,A,b,Aeq,beq,lb,ub,nonlcon,options);
optimization_time = toc;
optim_time = optimization_time;


optimization_final_percent = percent_finder(x,y,p(1),p(2),major_angle);
final_angle_optimization = major_angle;

area_optimization = pi*p(1,1)*p(1,2);

if do_display
    disp(['The percentage of points inside the ellipse (optimization method): ', num2str(optimization_final_percent)]);
    disp(['The final area of optimization method is: ' , num2str(area_optimization)]);
end

if do_plot
    figure;
    plot_optimization = ellipse(p(1),p(2),final_angle_optimization,0,0,'g',100);
    hold on;
    plot_data_timmer = ellipse(major_length_trim,minor_length_trim,major_angle,0,0,'r',100);
    plot_data_points = plot(X_original(1,:),X_original(2,:),'*k','MarkerSize',2);
end

%%%%%%%%%%%%%% The PCA approach %%%%%%%%%%%%%%%%%%%
% Area calculation using PCA
x_pca = x - mean(x);
y_pca = y - mean(y);

tic;
pca_covar = cov([x_pca,y_pca]);
area_pca_paper = 2*pi*3 *sqrt(pca_covar(1,1) * pca_covar(2,2) - pca_covar(1,2)^2);

pca_paper_time = toc;


if do_display
    disp(['The final area of pca (paper) method is: ' , num2str(area_pca_paper)]);
end

tic;

pca_covar_1 = cov([x_pca,y_pca]);
[pca_eigen_vector, pca_eigen_value] = eig(pca_covar_1);
area_pca = pi*sqrt(pca_eigen_value(1,1))*sqrt(5.9915)*sqrt(pca_eigen_value(2,2))*sqrt(5.9915);
pca_time = toc;


if pca_eigen_value(2,2)>=pca_eigen_value(1,1)
    higher_eigen_index = 2;
    lower_eigen_index = 1;
else
    higher_eigen_index= 1;
    lower_eigen_index = 2;
end

u = pca_eigen_vector(:,higher_eigen_index);
v = [1;0];

m =1000;
xh = zeros(m,1);
yh = zeros(m,1);
theta = linspace(0,2*pi,m);

for k = 1:m
        xh(k) = sqrt(pca_eigen_value(higher_eigen_index,higher_eigen_index)) * sqrt(5.9915) * cos(theta(k));
        yh(k) = sqrt(pca_eigen_value(lower_eigen_index,lower_eigen_index)) * sqrt(5.9915) * sin(theta(k));
end
CosTheta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
alpha = acos(CosTheta);
R  = [cos(alpha) -sin(alpha); ...
      sin(alpha)  cos(alpha)];
rCoords = R*[xh' ; yh'];
xr = rCoords(1,:)';      
yr = rCoords(2,:)';  

pca_final_percent = percent_finder(x,y,sqrt(pca_eigen_value(higher_eigen_index,higher_eigen_index)) * sqrt(5.9915), sqrt(pca_eigen_value(lower_eigen_index,lower_eigen_index)) * sqrt(5.9915),alpha);
if do_display
    disp(['The percentage of points inside the ellipse (pca method): ', num2str(pca_final_percent)]);
    disp(['The final area of pca method is: ' , num2str(area_pca)]);
end

if do_plot
    plot_pca = plot(xr,yr,'b');
    legend([plot_data_points,plot_data_timmer,plot_optimization,plot_pca],'Original Points','Ellipse data trimmer','Ellipse Optimization','Ellipse PCA','Location','southeast');
    title('Plot of generated ellipse by different methods');
    xlabel('x distance in mm');
    ylabel('y distance in mm');
end


if do_display
    disp('End!');
end


return;