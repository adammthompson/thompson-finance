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
# @deftypefn {Function File} {[@var{fast_k, full_k, full_d]} =} stochastic (@var{asset, k_period, full_period})
%
% Calculate stochastic oscillators (fast %K, full %K, and full %D) of an asset from a
% matrix of high, low, and closing prices (@var{asset}). Fast %K is calculated by
% subtracting the lowest low over the past @var{k_period} periods from the current 
% closing price, multiplying that by 100 and then dividing by the highest high 
% minus the lowest low.
%
% Full %K is the @var{full_period}-period simple moving average of fast %K. Full %D
% is in turn the @var{full_period}-period SMA of full %K.
%
% @var{k_period} and @var{full_period} are optional. The defaults are 14 and 3.
%
% Dependencies:
% m_average function,
% Octave financial package.
% @end deftypefn
	
		
function [fast_k, full_k, full_d] = stochastic (asset, k_period = 14, full_period = 3)
% K Calculate fast %K, full %K, & full %D.
%	stochastic (asset, k_period, full_period) = Calculate stochastic oscillators 
%	fast %K, full %K, & full %D. data is a 3-column matrix of high,
%	low, & close prices. k_period is the period for fast %K. full_period is 
%	the period for full %K & full %D.

if nargin < 1
	printf ('Error: must have at least one argument.')	
elseif nargin > 3
	printf ('Error: must have at most three arguments.')
elseif k_period > rows (asset)
	error ('Error: k_period must be <= rows of asset vector')
elseif full_period > rows (asset)
	error ('Error: full_period must be <= rows of asset vector')
elseif ! ismatrix (asset)
	error ('Error: asset must be a matrix')
end

% Fast %K:
lwst_low = llow (asset(:, 2), k_period);
hst_high = hhigh (asset(:, 1), k_period);
fast_k = (asset(:, 3) - lwst_low) ./ (hst_high - lwst_low) * 100;

% Full %K (fast %K smoothed w/ x-period SMA):
full_k = m_average (fast_k, full_period, 1);

%% Full percent D (full percent K smoothed w/ x-period SMA):
full_d = m_average (full_k, full_period, 1);

end
