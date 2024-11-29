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


function [x_result, y_result, major_length_result, minor_length_result] = data_trimmer_ellipse(x,y,major_length,minor_length,angle)

% Centering the data around its mean
x_centered = x - mean(x);
y_centered = y - mean(y);

%Finding number of points inside the initial ellipse
initial_number_points_inside=0;
for i=1:size(x,1)
    tmp_value = (x_centered(i,1)*cos(angle)+y_centered(i,1)*sin(angle))^2/major_length^2 + (-x_centered(i,1)*sin(angle) + y_centered(i,1)*cos(angle))^2/minor_length^2;
    if(tmp_value <=1)
    initial_number_points_inside = initial_number_points_inside+1;
    end
end

% Iterating to reduce ellipse size until we have 95 percent of data inside
% the ellipse
percent_data_inside = initial_number_points_inside/size(x,1)*100;
while percent_data_inside>95
    number_of_elements = 0;
    for i=1:size(x_centered,1)
        tmp_value = (x_centered(i,1)*cos(angle)+y_centered(i,1)*sin(angle))^2/major_length^2 + (-x_centered(i,1)*sin(angle) + y_centered(i,1)*cos(angle))^2/minor_length^2;
        if(tmp_value <= 1)
            number_of_elements = number_of_elements +1;
        end
    end
    percent_data_inside = (number_of_elements/size(x_centered,1)) * 100;
    if(percent_data_inside>95)
        major_length = major_length - 0.01;
        minor_length = minor_length - 0.01;
    end
end


% Recording the index of elements outside of ellipse
list_of_index=[];
for i=1:size(x_centered,1)
    tmp_value = (x_centered(i,1)*cos(angle)+y_centered(i,1)*sin(angle))^2/major_length^2 + (-x_centered(i,1)*sin(angle) + y_centered(i,1)*cos(angle))^2/minor_length^2;
    if(tmp_value>1)
        list_of_index(end+1) = i;
    end
end

% Removing the data points corresponding to the index of points outside
% ellipse
x_final = [];
y_final = [];
in_size = size(list_of_index);
for i=1:size(x_centered,1)
    flag=0;
    for j=1:in_size(2)
        if(i==list_of_index(1,j))
            flag=1;
        end
    end
    if(flag==0)
        x_final(end+1) = x(i);
        y_final(end+1) = y(i);
    end

end
x_result = x_final';
y_result = y_final';

major_length_result = major_length;
minor_length_result = minor_length;


return;