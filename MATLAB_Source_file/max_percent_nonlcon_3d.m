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

function [c,ceq] = max_percent_nonlcon_3d(p)

load('optim_required_3d2.mat');

for i=1:size(X_optim,1)
    initial_state(i,1) = X_optim(i,1);
    initial_state(i,2) = Y_optim(i,1);
    initial_state(i,3) = Z_optim(i,1);
end
tf_state = initial_state*eigen_vector;

number_of_elements = 0;
for i=1:size(tf_state,1)
    tmp_value = (tf_state(i,1).^2 / p(1)^2) + (tf_state(i,2).^2 / p(2)^2) + (tf_state(i,3).^2 / p(3)^2); 
    if(tmp_value<=1)
        number_of_elements = number_of_elements +1;
    end
end

percent = (number_of_elements/size(X_optim,1)) * 100;

if percent < 95 
    output_value = 1000*(95-percent);
else
    output_value = -10000;
end

c = output_value;

ceq = [];

return;