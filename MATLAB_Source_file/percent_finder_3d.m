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

function [percent] = percent_finder_3d(x,y,z,a,b,c,eigen_vector)

x_centered = x - mean(x);
y_centered = y - mean(y);
z_centered = z - mean(z);


for i=1:size(x_centered,1)
    initial_state(i,1) = x_centered(i,1);
    initial_state(i,2) = y_centered(i,1);
    initial_state(i,3) = z_centered(i,1);
end
tf_state = initial_state*eigen_vector;
number_of_elements = 0;


for i=1:size(tf_state,1)
    tmp_value = (tf_state(i,1).^2 / a^2) + (tf_state(i,2).^2 / b^2) + (tf_state(i,3).^2 / c^2); 
    if(tmp_value<=1)
        number_of_elements = number_of_elements +1;
    end
end

percent = (number_of_elements/size(x_centered,1)) * 100;

return;