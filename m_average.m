## Copyright (C) 2015 Adam Thompson <adammilesthompson [at] gmail [dot] com>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
# @deftypefn {Function File} {[@var{ma}] =} m_average (@var{asset, period, variant})
#
# Calculate the moving average of an @var{asset}.
#
# If @var{variant} is 1 (the default), calculate the simple moving average. If
# @var{variant} is 2, calculate the exponential moving average. A simple 
# moving average is just the average price of the @var{asset} over a specific 
# number of periods. The exponential moving average applies more weight to 
# recent prices. The weighting applied to the most recent price depends on the 
# number of periods: a factor of 2 divided by the number of periods + 1 is used.
#
% If @var{variant} is 1, the beginning of the moving average is padded with NANs to 
% match the size of @var{asset}.
#
# Dependencies:
# none.
# @end deftypefn


function ma = m_average (asset, period, variant = 1)
# M_AVERAGE Create moving average.
# ma = M_AVERAGE (asset, period, variant) creates column vector of	moving
# average. Inputs are column vector of asset and period for moving average.
# If variant is 1, calculate the simple moving average. If variant is 2,
# calculate the exponential moving average.
#
# Formulas for calculating moving averages provided by James Sherman, Jr.
# http://octave.1599824.n4.nabble.com/vectorized-moving-average-td2132090.html

if variant == 1
	ma = filter ((1 / period) * ones(1, period), 1, asset);
	ma(1: period - 1) = nan (period - 1, 1);
elseif variant == 2
	alpha = 2 / (period + 1);
	ma = filter (alpha, [1 (alpha - 1)], asset, asset(1) * (1 - alpha));
else
	error ('Error: variant must be 1 or 2.')
end

end
