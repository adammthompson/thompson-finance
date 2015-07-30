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
# @deftypefn {Function File} {@var{rsindex} =} rsi (@var{asset, period, variant})
%
% Calculate the Relative Strength Index (RSI) of an asset from a vector of closing prices
% (@var{asset}).
%
% RSI is calcuated by first calculating the relative strength (RS), which is the ratio of
% average gain over the last @var{period} periods to the average loss. Then 100 is 
% divided by 1 + RS, and that quotient is subtracted from 100.
%
% @var{variant} 1 uses a simple moving average for the average gains and losses.
% @var{variant} 2 uses the exponential moving average.
%
% @var{period} and @var{variant} are optional. The defaults are 14 and 1.
%
% Dependencies:
% m_average function.
% @end deftypefn

	
function rsindex = rsi (asset, period = 14, variant = 1)
% RSI Calculate RSI.
%	rsi(asset, period) = Calculate relative strength index. asset is column vector.
%	variant: 1 uses simple moving average (original Wilder), 2 uses exponential 
%	moving average (AIQ Systems).

if nargin < 1
	printf ('Error: must have at least one argument.')	
elseif nargin > 3
	printf ('Error: must have at most three arguments.')
elseif period > length (asset)
	error ('Error: period must be <= length of asset vector')
elseif variant < 1 || variant > 2
	error ('Error: variant must be either 1 or 2')
elseif ! isvector (asset)
	error ('Error: asset must be a vector')
end

rsindex  = nan (size (asset));
m = rows (asset);
changes = diff (asset);
ups = changes .* (changes > 0);
downs = -changes .* (changes < 0);	% absolute value of neg changes

if variant == 1
	up_avg = m_average (ups, period, 1);	% simple mov avg
	dn_avg = m_average (downs, period, 1);
elseif variant == 2
	up_avg = m_average (ups, period, 2);
	dn_avg = m_average (downs, period, 2);
else
	error ('Variant must be set to 1 or 2, not %d.', variant)
end

if up_avg == 0
	rsindex = 0;
elseif dn_avg == 0
	rsindex = 100;
else
	rs = up_avg ./ dn_avg;			% relative strength
	rs = [nan; rs];
	rsindex = 100 - (100 ./ (1 + rs));
end

end
