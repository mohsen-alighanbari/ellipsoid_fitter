% MIT License
% 
% Copyright (c) 2016 Michael J. Todd
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


function u = initwt(X,print)
% obtains the initial weights u using the Kumar-Yildirim algorithm,
% taking into account that X represents [X,-X].
if (nargin < 2), print = 0; end;
if print, st = cputime; end;
[n,m] = size(X);
u = zeros(m,1);
Q = eye(n);
d = Q(:,1);
% Q is an orthogonal matrix whose first j columns span the same space
% as the first j points chosen X(:,ind) (= (X(:,ind) - (-X(:,ind)))/2).
for j = 1:n,
    % compute the maximizer of | d *x | over the columns of X.
    dX = abs(d'*X);
    [maxdX,ind] = max(dX);
    u(ind) = 1;
    if j == n, break, end;
    % update Q.
    y = X(:,ind);
    z = Q'*y;
    if j > 1, z(1:j-1) = zeros(j-1,1); end;
    zeta = norm(z); zj = z(j); if zj < 0, zeta = - zeta; end;
    zj = zj + zeta; z(j) = zj;
    Q = Q - (Q * z) * ((1/(zeta*zj)) * z');
    d = Q(:,j+1);
end;
u = u / n;
if print,
    fprintf('\n Initialization time = %5.2f \n',cputime - st);
end;
return;