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
# @deftypefn {Function File} {@var{srsi} =} stochrsi (@var{asset, period, variant})
%
% Calculate StochRSI of an asset from a vector of closing prices (@var{asset}).
% StochRSI indicates the value of the @var{period}-period Relative Strength 
% Index (RSI) relative to its high/low range of @var{period} periods. StochRSI 
% ranges from 0 (when RSI is at its lowest point over @var{period} periods) to 1
% (when RSI is at its highest point).
%
% StochRSI is calculated as RSI minus the lowest RSI over @var{period} periods, all
% divided by the highest RSI minus the lowest RSI.
%
% @var{variant} 1 uses a simple moving average in calculating RSI. @var{variant} 2
% uses the exponential moving average.
%
% @var{period} and @var{variant} are optional. The defaults are 14 and 1.
%
% Dependencies:
% m_average function,
% rsi function,
% Octave financial package.
% @end deftypefn

		
function srsi = stochrsi (asset, period = 14, variant = 1)
% stochrsi Calculate StochRSI.
%	stochrsi(data, per) = Calculate stochrsi. data is column vector.
%	var determines which version of rsi is used, 1 uses sma, 2 uses ema.

pkg load financial;

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

rsindex = rsi (asset, period, variant);
lst_low = llow (rsindex, period);
hst_high = hhigh (rsindex, period);
srsi = (rsindex - lst_low) ./ (hst_high - lst_low);

end
