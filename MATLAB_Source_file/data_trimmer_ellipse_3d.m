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

function [x_result, y_result, z_result, a_result, b_result, c_result,percent_data_inside] = data_trimmer_ellipse_3d(x,y,z,a,b,c,eigen_vector)

x_centered = x - mean(x);
y_centered = y - mean(y);
z_centered = z - mean(z);


for i=1:size(x_centered,1)
    initial_state(i,1) = x_centered(i,1);
    initial_state(i,2) = y_centered(i,1);
    initial_state(i,3) = z_centered(i,1);
end
tf_state = initial_state*eigen_vector;

%Finding number of points inside the initial ellipse
initial_number_points = 0;
for i=1:size(tf_state,1)
    tmp_value = (tf_state(i,1).^2 / a^2) + (tf_state(i,2).^2 / b^2) + (tf_state(i,3).^2 / c^2); 
    if(tmp_value<=1)
        initial_number_points = initial_number_points +1;
    end
end


% Iterating to reduce ellipse size until we have 95 percent of data inside
% the ellipse
percent_data_inside = initial_number_points/size(x_centered,1)*100;
while percent_data_inside>95
    number_of_elements = 0;
    for i=1:size(x_centered,1)
        tmp_value = (tf_state(i,1).^2 / a^2) + (tf_state(i,2).^2 / b^2) + (tf_state(i,3).^2 / c^2); 
        if(tmp_value <= 1)
            number_of_elements = number_of_elements +1;
        end
    end
    percent_data_inside = (number_of_elements/size(x_centered,1)) * 100;
    if(percent_data_inside>95)
        a = a - 0.06;
        b = b - 0.01;
        c = c - 0.01;
    end
end


% Recording the index of elements outside of ellipse
list_of_index=[];
for i=1:size(x_centered,1)
    tmp_value = (tf_state(i,1).^2 / a^2) + (tf_state(i,2).^2 / b^2) + (tf_state(i,3).^2 / c^2); 
    if(tmp_value>1)
        list_of_index(end+1) = i;
    end
end

% Removing the data points corresponding to the index of points outside
% ellipse
x_final = [];
y_final = [];
z_final = [];
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
        z_final(end+1) = z(i);
    end

end
x_result = x_final';
y_result = y_final';
z_result = z_final';
a_result = a;
b_result = b;
c_result = c;


return;