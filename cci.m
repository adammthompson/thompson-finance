% Copyright (C) 2019 Adam Thompson <adammilesthompson [at] gmail [dot] com>
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

% -*- texinfo -*-
% @deftypefn {Function File} {[@var{ccindex}] =} cci(@var{asset, period, constant})
%
% Calculate the Commodity Channel Index (CCI) of an asset from the matrix whose
% columns are high, low, and closing prices (@var{asset}).
%
% The CCI is calculated as the typical price minus the @var{period}-period 
% simple moving average of the typical price, all divided by the mean 
% deviation of the typical price. The typical price for each day is the 
% average of the high, low, and closing prices.
%
% @var{period} and @var{constant} are optional. Defaults are 20 and 0.015
% respectively.
%
% With a @var{constant} of 0.015, approximately 70 to 80 percent of CCI values
% will typically fall between -100 and +100.
%
% The beginning of the CCI is padded with NANs to match the size of @var{asset}.
%
% Dependencies:
% m_average function.
% @end deftypefn


function ccindex = cci(asset, period = 20, constant = 0.015)
% CCI Calculate Commodity Channel Index.

% cci(asset, period, constant) = Calculate commodity channel index. asset
% is 3-column matrix (columns are high, low, & close). If constant = 0.015,
% ~75% of values will be [-100, 100].

pkg load statistics;

if nargin < 1
	printf('Error: must have at least one argument.')	
elseif nargin > 3
	printf('Error: must have at most three arguments.')
elseif period > rows(asset)
	error('Error: period must be <= the number of rows in asset matrix')
elseif !ismatrix(asset)
	error('Error: asset must be a matrix')
end

m = rows(asset);
ccindex = nan(m, 1);
typ_price = mean(asset, 2);

cci_sma = m_average(typ_price, period, 1);

mean_dev = zeros(m, 1);

sma_rep = repmat(cci_sma, 1, period);
idx = [1: m - period + 1]' + [0: period - 1];
mean_dev(period: m) = mean(abs(typ_price(idx) - sma_rep(period: m, :)), 2);

ccindex = (typ_price - cci_sma) ./ (constant * mean_dev);

end
