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
%This software is part of the publication with title "Enclosing 95% confidence 
%area and volume to center of pressure and center of mass in posturography 
%using optimization and coordinate ascent methods." In the Computers in Biology
% and Medicine Journal. Upon usage of this code, please cite the below publication.
% Enclosing 95% confidence area and volume to center of pressure and center of mass in posturography 
%using optimization and coordinate ascent methods.
% (Authors: Alighanbari M., Alighanbari S., Griffin L.).

%% clear all close all,
clear all;
close all;
clc;

%% Questions about path files, MVEE charactristics and what variables will be exported:

%%%%% Provide warning for user before initiation of code:
sizeWarning = errordlg('Please make sure that your CoM Excel file have three columns (X, Y, and Z) and your CoP Excel file has two columns (X and Y)!');
uiwait(sizeWarning);

%%%%% Question about CoP or CoM which one we should select
i = 1;
while i<2
    answer = questdlg('Do you want to add the CoP or CoM data?', 'Data type','CoM','CoP','Cancel','');
    switch answer
        case 'CoP'
            DataSet = 2;
            i = 3;
        case 'CoM'
            DataSet = 3;
            i = 3;
        otherwise
            errordlg('Operation Cancelled!');
            return;
    end
end

%%%%% Question for adding the path to the CoP or CoM file:
prompt = {'Please add the path to your CoM or CoP Excel files?'};
dlgtitle = 'input path';
fieldsize = [1 45];
definput = {'path'};
userinput = inputdlg(prompt,dlgtitle,fieldsize,definput);
if isempty(userinput)
    errordlg('Operation Cancelled!');
    return;
end
path = userinput{1};
clear prompt dlgtitle fieldsize definput userinput

%%%%% Question for the input to the filter applied to the CoM or CoP data:
i = 1;
while i<2
    FilterIn = inputdlg({'Sampling frequency','Cut-off frequency for low-pass filter','Filter Order'},'Filtering Data',[1 50; 1 50; 1 50]);
    if isempty(FilterIn)
        errordlg('Operation Cancelled!')
        return;
    end
    fs = str2num(FilterIn{1});
    Fcut = str2num(FilterIn{2});
    filterOrder = str2num(FilterIn{3});
    if isempty(Fcut)==0 && isempty(filterOrder)==0 && isempty(fs)==0
        i = 3;
    else
        Error1 = errordlg('Please provide input for all fields!');
        uiwait(Error1);
    end
end


%%%%% Question about the MVEE options:
inputTraits = MVEE_trait();

%%%%% Question about the what variable to export:
if answer=='CoM'
    Exportoption = MVEE_Export_3d();
    if length(Exportoption.SelectOptions)<9
        for i = length(Exportoption.SelectOptions):8
            Exportoption.SelectOptions{1,i+1} = [];
        end

    end
else
    Exportoption = MVEE_Export_2d();
    if length(Exportoption.SelectOptions)<11
        for i = length(Exportoption.SelectOptions):10
            Exportoption.SelectOptions{1,i+1} = [];
        end
    end
end
    
%% importing files:
myfolder = fileDatastore(path,'ReadFcn',@importdata,"IncludeSubfolders",true);
fullfilename = myfolder.Files;
for i = 1:length(fullfilename)
    [filepath, name, ext] = fileparts(fullfilename{i});
    filename{i} = [name,ext];
    fprintf('Now reading postvibration file %s\n', fullfilename{i});
    Data{i} = readtable(fullfilename{i});
    clear filepath name ext 
end
clear i myfolder fullfilename;

%% Transfering table to array
for i = 1:length(Data)
    A = Data{i};
    A = table2array(A);
    Data{i} = A;
    clear A
end

%% Gap filling the CoM file:
if answer=='CoM'
    for i = 1:length(Data)
        Data{i} = fillgaps(Data{i});
    end
end

%% filtering the data:
fcl = ((Fcut*2*pi)/fs)/pi;
[b,a]=butter(filterOrder,fcl, 'low');
for i = 1:length(Data)
    A = Data{i};
    A = filtfilt(b,a,A);
    Data{i} = A;
    clear A
end
clear a b fcl

%% make the logical variable:
% create the exporting variable:
for i = 1:length(Exportoption.SelectOptions)
    input(1,i) = isempty(Exportoption.SelectOptions{1,i});
end

%% Set the input for the functions:
%Q1:
if strcmp(inputTraits.Q1,'No')
    do_plot = false;
else
    do_plot = true;
end
%Q2:
if strcmp(inputTraits.Q2,'No')
    do_display = false;
else
    do_display =  true;    
end
%Q3:
if strcmp(inputTraits.Q3,'No')
    tolerance = 1e-7;
else
    tolerance = 1e-3;
end

%% Run the MVEE for getting the 95% confidence ellipse or ellipsoid:
if answer=='CoM'
    % for the CoM
    for i = 1:length(Data)
        A = Data{i};
        x = A(:,1);
        y = A(:,2);
        z = A(:,3);
        % run the MVEE option:
        [Export(i,1),Export(i,2),Export(i,3),Export(i,4), ...
            Export(i,5),Export(i,6),Export(i,7),Export(i,8), ...
            Export(i,9),Export(i,10),Export(i,11)] = MVEE_3d_v12(x,y,z,do_plot,do_display,tolerance);
        clear x y z A
    end
else
    % for the CoP
    for i = 1:length(Data)
        A = Data{i};
        x = A(:,1);
        y = A(:,2);
        [Export(i,1),Export(i,2),Export(i,3),Export(i,4), ...
            Export(i,5),Export(i,6),Export(i,7),Export(i,8), ...
            Export(i,9),Export(i,10),Export(i,11),Export(i,12)] = MVEE_2d_v11(x,y,do_plot,do_display,tolerance);
        clear A x y
    end
end

%% segregating variables of interest:
if answer=='CoM'
    % optimization volume:
    if input(1,1)==1
        volume(:,1) = 0;
    else
        volume(:,1) = Export(:,2);
    end
        % data trimmer volume:
    if input(1,2) ==1
        volume(:,2) = 0;
    else
        volume(:,2) = Export(:,1);
    end
        % pca volume
    if input(1,3)==1
        volume(:,3) = 0;
    else
        volume(:,3) = Export(:,3);
    end
        % optimization percentage of data in ellipsoid
    if input(1,4)==1
        percent(:,1) = 0;
    else
        percent(:,1) = Export(:,6);
    end
        % data trimmer percentage of data in ellisoid
    if input(1,5)==1
        percent(:,2) = 0;
    else
        percent(:,2) = Export(:,5);
    end
        % pca percentage of data in ellipsoid
    if input(1,6)==1
        percent(:,3) = 0;
    else
        percent(:,3) = Export(:,7);
    end
        % run time for the optimization method
    if input(1,7)==1
        time(:,1) = 0;
    else
        time(:,1) = Export(:,9);
    end
        % run time for the data trimmer method
    if input(1,8)==1
        time(:,2) = 0;
    else
        time(:,2) = Export(:,10);
    end
        % run time for the pca method
    if input(1,9)==1
        time(:,3) = 0;
    else
        time(:,3) = Export(:,11);
    end
    clear x y z A
else
    % for the CoP
    % optimization area
    if input(1,1) ==1
        area(:,1) = 0;
    else
        area(:,1) = Export(:,1);
    end
    % data trimmer area 
    if input(1,2)==1
        area(:,2) = 0;
    else
        area(:,2) = Export(:,3);
    end
    % pca area
    if input(1,3)==1
        area(:,3) = 0;
    else
        area(:,3) = Export(:,4);
    end
    % covariance area
    if input(1,4)==1
        area(:,4) = 0;
    else
        area(:,4) = Export(:,2);
    end
    % optimization algorithm percentage of data in ellipse
    if input(1,5)==1
        percent(:,1) = 0;
    else
        percent(:,1) = Export(:,5);
    end
    % data trimmer percentage of data in ellipse
    if input(1,6)==1
        percent(:,2) = 0;
    else
        percent(:,2) = Export(:,6);
    end
    % pca percentage of data in ellipse
    if input(1,7)==1
        percent(:,3) = 0;
    else
        percent(:,3) = Export(:,7);
    end
    % run time for optimization algorithm
    if input(1,8)==1
        time(:,1) = 0;
    else
        time(:,1) = Export(:,10);
    end
    % run time for data trimmer method
    if input(1,9)==1
        time(:,2) = 0;
    else
        time(:,2) = Export(:,9);
    end
    % run time for the pca method
    if input(1,10)==1
        time(:,3) = 0;
    else
        time(:,3) = Export(:,12);
    end
    % run time for the covariance method
    if input(1,11)==1
        time(:,4) = 0;
    else
        time(:,4) = Export(:,11);
    end
    clear A x y
end

%% Make the variables of interest ready for export:
if answer =='CoM'
    Volume {1,1} = 'Trial Name';
    Percent{1,1} = 'Trial Name';
    Time{1,1} = 'Trial Number';
    for i = 1:length(filename)
        Volume {i+1,1} = filename{i};
        Percent{i+1,1} = filename{i};
        Time{i+1,1} = filename{i};
    end
    title = {'Optimization algorithm','Data trimmer method','PCA method'};
    for i = 1:3
        Volume{1,i+1} = title{i};
        Percent{1,i+1} = title{i};
        Time{1,i+1} = title{i};
    end
    % Volume:
    if any(volume(1,:)~=0)
        for i = 1:length(filename)
            for j = 1:3
                if volume(i,j)==0
                    Volume{i+1,j+1} = [];
                else
                    Volume{i+1,j+1} = volume(i,j);
                end
            end
        end
    else
        for i = 1:length(filename)
            for j = 1:3
                Volume{i+1,j+1} = [];
            end
        end
    end
    % Percentage:
    if any(percent(1,:)~=0)
        for i = 1:length(filename)
            for j = 1:3
                if percent(i,j)==0
                    Percent{i+1,j+1} = [];
                else
                    Percent{i+1,j+1} = percent(i,j);
                end
            end
        end
    else
        for i = 1:length(filename)
            for j = 1:3
                Percent{i+1,j+1} = [];
            end
        end
    end
    % Time;
    if any(time(1,:)~=0)
        for i = 1:length(filename)
            for j = 1:3
                if time(i,j)==0
                    Time{i+1,j+1} = [];
                else
                    Time{i+1,j+1} = time(i,j);
                end
            end
        end
    else
        for i = 1:length(filename)
            for j = 1:3
                Time{i+1,j+1} = [];
            end
        end
    end
    clear time percent volume;
else
    Area {1,1} = 'Trial Name';
    Percent{1,1} = 'Trial Name';
    Time{1,1} = 'Trial Number';
    for i = 1:length(filename)
        Area {i+1,1} = filename{i};
        Percent{i+1,1} = filename{i};
        Time{i+1,1} = filename{i};
    end
    title = {'Optimization algorithm','Data trimmer method','PCA method','Covariance method'};
    for i = 1:4
        Area{1,i+1} = title{i};
        Time{1,i+1} = title{i};
    end
    for i = 1:3
        Percent{1,i+1} = title{i};
    end
    % Area:
    if any(area(1,:)~=0)
        for i = 1:length(filename)
            for j = 1:4
                if area(i,j)==0
                    Area{i+1,j+1} = [];
                else
                    Area{i+1,j+1} = area(i,j);
                end
            end
        end
    else
        for i = 1:length(filename)
            for j = 1:4
                Area{i+1,j+1} = [];
            end
        end
    end
    % Percentage:
    if any(percent(1,:)~=0)
        for i = 1:length(filename)
            for j = 1:3
                if percent(i,j)==0
                    Percent{i+1,j+1} = [];
                else
                    Percent{i+1,j+1} = percent(i,j);
                end
            end
        end
    else
        for i = 1:length(filename)
            for j = 1:3
                Percent{i+1,j+1} = [];
            end
        end
    end
    % Run time:
    if any(time(1,:)~=0)
        for i = 1:length(filename)
            for j = 1:4
                if time(i,j)==0
                    Time{i+1,j+1} = [];
                else
                    Time{i+1,j+1} = time(i,j);
                end
            end
        end
    else
        for i = 1:length(filename)
            for j = 1:4
                Time{i+1,j+1} = [];
            end
        end
    end
    clear time percent area;
end

%% Exporting the variables of interest:
if answer=='CoM'
    % Generate file path:
    if contains(path,'\')==1
        Resultpath = strcat(path,'\RESULTS');
        if ~exist(Resultpath,'dir')
            mkdir(Resultpath);
        end
        % exporting excel file:
        Vname = strcat(Resultpath,'\95% confidence volume for the CoM using different methods.xlsx');
        Pname = strcat(Resultpath,'\Percentage of numbers of points in the ellipsoid for different approach.xlsx');
        Rname = strcat(Resultpath,'\Run time for each method when enclosing ellsoid to 95% of CoM data.xlsx');
        writecell(Volume,Vname);
        writecell(Percent,Pname);
        writecell(Time,Rname);
        % saving figures if any:
        if do_plot==1
            Picnumber= findall(0, 'Type', 'figure');
            for i = 1:length(Picnumber)
                fig = Picnumber(i);
                pic = '\Figure ';
                pic = strcat(pic,string(i));
                picjpg = strcat(pic,' .jpg');
                picfig = strcat(pic,' .fig');
                Picname1 = strcat(Resultpath,picjpg);
                Picname2 = strcat(Resultpath,picfig);
                saveas(fig,Picname1);
                saveas(fig,Picname2);
            end
        end
    else
        Resultpath = strcat(path,'/RESULTS');
        if ~exist(Resultpath,'dir')
            mkdir(Resultpath);
        end
        % export excel file:
        Vname = strcat(Resultpath,'/95% confidence volume for the CoM using different methods.xlsx');
        Pname = strcat(Resultpath,'/Percentage of numbers of points in the ellipsoid for different approach.xlsx');
        Rname = strcat(Resultpath,'/Run time for each method when enclosing ellsoid to 95% of CoM data.xlsx');
        writecell(Volume,Vname);
        writecell(Percent,Pname);
        writecell(Time,Rname);
        % export figure
        if do_plot==1
            Picnumber= findall(0, 'Type', 'figure');
            for i = 1:length(Picnumber)
                fig = Picnumber(i);
                pic = '/Figure ';
                pic = strcat(pic,string(i));
                picjpg = strcat(pic,' .jpg');
                picfig = strcat(pic,' .fig');
                Picname1 = strcat(Resultpath,picjpg);
                Picname2 = strcat(Resultpath,picfig);
                saveas(fig,Picname1);
                saveas(fig,Picname2);
            end
        end
    end
else
    if contains(path,'\')==1
        Resultpath = strcat(path,'\RESULTS');
        if ~exist(Resultpath,'dir')
            mkdir(Resultpath);
        end
        % export excel file:
        Aname = strcat(Resultpath,'\95% confidence area for the CoP using different methods.xlsx');
        Pname = strcat(Resultpath,'\Percentage of numbers of points in the ellipse for different approach.xlsx');
        Rname = strcat(Resultpath,'\Run time for each method when enclosing ellipse to 95% of CoP data.xlsx');
        writecell(Area,Aname);
        writecell(Percent,Pname);
        writecell(Time,Rname);
        % Export figure:
        if do_plot==1
            Picnumber= findall(0, 'Type', 'figure');
            for i = 1:length(Picnumber)
                fig = Picnumber(i);
                pic = '\Figure ';
                pic = strcat(pic,string(i));
                picjpg = strcat(pic,' .jpg');
                picfig = strcat(pic,' .fig');
                Picname1 = strcat(Resultpath,picjpg);
                Picname2 = strcat(Resultpath,picfig);
                saveas(fig,Picname1);
                saveas(fig,Picname2);
            end
        end
    else 
        Resultpath = strcat(path,'/RESULTS');
        if ~exist(Resultpath,'dir')
            mkdir(Resultpath);
        end
        % export excel file:
        Aname = strcat(Resultpath,'/95% confidence area for the CoP using different methods.xlsx');
        Pname = strcat(Resultpath,'/Percentage of numbers of points in the ellipse for different approach.xlsx');
        Rname = strcat(Resultpath,'/Run time for each method when enclosing ellipse to 95% of CoP data.xlsx');
        writecell(Area,Aname);
        writecell(Percent,Pname);
        writecell(Time,Rname);
        % export figure:
        if do_plot==1
            Picnumber= findall(0, 'Type', 'figure');
            for i = 1:length(Picnumber)
                fig = Picnumber(i);
                pic = '/Figure ';
                pic = strcat(pic,string(i));
                picjpg = strcat(pic,' .jpg');
                picfig = strcat(pic,' .fig');
                Picname1 = strcat(Resultpath,picjpg);
                Picname2 = strcat(Resultpath,picfig);
                saveas(fig,Picname1);
                saveas(fig,Picname2);
            end
        end
    end
end

%% Message box:
msgbox("The process is successful!","Success");
