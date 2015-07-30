% Copyright (C) 2015 Adam Thompson <adammilesthompson [at] gmail [dot] com>
%
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program; if not, see <http://www.gnu.org/licenses/>.

# -*- texinfo -*-
# @deftypefn {Function File} {@var{wr} =} williams (@var{asset, period})
%
% Calculate Williams %R of an asset from a matrix of high, low, and closing 
% prices (@var{asset}). Williams %R is calculated by subtracting the closing 
% price from the highest high over @var{period} periods, then dividing the 
% result by the highest high minus the lowest low, and then multiplying the 
% result by -100.
%
% @var{period} is optional. The default is 14.
%
% Dependencies:
% Octave financial package.
% @end deftypefn
	
		
function wr = williams (asset, period = 14)
% WILLIAMS Calculate Williams %R.
%	williams(asset, period) = Calculate Williams %R. asset is a 4-column matrix
%	of open, high, low, & close prices.

pkg load financial;

if nargin < 1
	printf ('Error: must have at least one argument.')	
elseif nargin > 2
	printf ('Error: must have at most two arguments.')
elseif period > rows (asset)
	error ('Error: period must be <= rows of asset matrix')
elseif ! ismatrix (asset)
	error ('Error: asset must be a matrix')
end

hh = hhigh (asset(:, 1), period);
ll = llow (asset(:, 2), period);
wr = (hh - asset(:, 3)) ./ (hh - ll) * -100;

end
