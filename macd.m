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
# @deftypefn {Function File} {[@var{macdvec}, @var{sigline}] =} macd (@var{asset, period1, period2, sigline_period})
%
% Calculate the Moving Average Convergence/Divergence oscillator (MACD) of an
% asset from a vector of closing prices (@var{asset}).
%
% The MACD line (@var{macdvec}) is calcuated by subtracting the @var{period2} exponential
% moving average from the @var{period1} exponential moving average. The signal line
% (@var{sigline}) is a @var{sigline_period}-day exponential moving average of the MACD
% line.
%
% @var{period1}, @var{period2}, and @var{sigline_period} are optional. The defaults are 
% 12, 26, and 9.
%
% Dependencies:
% m_average function.
% @end deftypefn

	
function [macdvec, sigline] = macd (asset, period1 = 12, period2 = 26, sigline_period = 9)
% macd Compute MACD line & signal line for MACD.
% macd(period1, period2, sigline_period) = Calculate MACD line & signal line for
%	MACD.
%	asset is a column vector. period1 is length of shorter 
%	exponential moving avg.	period2 is length of longer EMA. sigline_period 
%	is length of signal line EMA.

if nargin < 1
	printf ('Error: must have at least one argument.')	
elseif nargin > 4
	printf ('Error: must have at most four arguments.')
elseif period1 > length (asset)
	error ('Error: period1 must be <= the number of rows in asset matrix')
elseif period2 > length (asset)
	error ('Error: period2 must be <= the number of rows in asset matrix')
elseif sigline_period > length (asset)
	error ('Error: sigline_period must be <= the number of rows in asset matrix')
elseif ! isvector (asset)
	error ('Error: closeprice must be a vector')
end

s_ema = m_average (asset, period1, 2);
l_ema = m_average (asset, period2, 2);
macdvec = s_ema - l_ema;

sigline = m_average (macdvec, sigline_period, 2);

end
