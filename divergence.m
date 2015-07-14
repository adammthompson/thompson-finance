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

% -*- texinfo -*-
% @deftypefn {Function File} {[@var{diver}] =} divergence (@var{price, indicator, delta_pr, delta_ind})
%
% Calculate bullish and bearish divergences between an indicator and the price
% of an asset.
%
% Divergence results when an indicator and the price of an asset are heading 
% in opposite directions. A bullish divergence occurs when price forms a lower
% low but the indicator forms a higher low. This function returns a 1 for
% a bullish divergence. A bearish divergence occurs when price forms a higher
% high but the indicator forms a lower low. This function returns a -1 for a
% bearish divergence.
%
% @var{price} and @var{indicator} are both vectors and must be of equal length.
% @var{delta_pr} is used to determine the height of price peaks required to be
% counted as new highs. Similarly @var{delta_ind} determines the height of 
% indicator peaks required to be counted. These must be determined by trial
% and error for each series.
%
% Dependencies:
% Octave signal package, 
% function peakdet by Eli Billauer (http://www.billauer.co.il/peakdet.html).
% @end deftypefn

	
function diver = divergence (price, indicator, delta_pr, delta_ind)
% divergence Calculate bullish and bearish divergences.
% A bullish divergence (1) occurs when price records a lower low and the 
%	indicator forms a higher low.
% A bearish divergence (-1) occurs when price records a higher high and the 
%	indicator forms a lower high.
% price and indicator are both vectors and must be of equal length.
% delta_pr is used to determine height of price peaks required to be counted.
% delta_ind is used to determine height of indicator peaks required to be
% counted. These must be determined empirically for each series.

pkg load signal;

d_size = length (price);
if d_size ~= length (indicator)
	error ('Error!!! Price and indicator must be of equal length!')
end

% First determine highs & lows for both price & indicator:
[price_pks, price_trghs] = peakdet (price, delta_pr);
[ind_pks, ind_trghs] = peakdet (indicator, delta_ind);
% price_pks, price_trghs, ind_pks, and ind_trghs are all 2 column vectors.
% Column 1 has the indices in of the peaks and column 2 has the values.

% FIXME: peakdet uses a for loop. This function would be much faster if
% it used a vectorized function for finding peaks. But I have not been able
% to find an adequate one or to figure out how to program one.

% Make vector of lower lows for price.  (1 if latest low was lower than
% the previous high, 0 otherwise):
price_ll = zeros (length (price), 1);
for i = 2: rows (price_trghs) - 1
	if price_trghs(i, 2) < price_trghs(i - 1, 2)
		price_ll(price_trghs(i, 1): price_trghs(i + 1, 1) - 1) = ones (price_trghs(i + 1, 1) - price_trghs(i, 1), 1);
	end
end
% The last new low needs special treatment:
if price_trghs(end, 2) < price_trghs(end - 1, 2)
	price_ll(price_trghs(end, 1): end) = ones (size(price_ll(price_trghs(end, 1): end)), 1);
end

% Make vector of higher lows for indicator:
ind_hl = zeros (length (indicator), 1);
for i = 2: rows (ind_trghs) - 1
	if ind_trghs(i, 2) > ind_trghs(i - 1, 2)
		ind_hl(ind_trghs(i, 1): ind_trghs(i + 1, 1) - 1) = ones (ind_trghs(i + 1, 1) - ind_trghs(i, 1), 1);
	end
end
if ind_trghs(end, 2) > ind_trghs(end - 1, 2)
	ind_hl(ind_trghs(end, 1): end) = ones (size(ind_hl(ind_trghs(end, 1))), 1);
end

% Make vector of higher highs for price:
price_hh = zeros (length (price), 1);
for i = 2: rows (price_pks) - 1
	if price_pks(i, 2) > price_pks(i - 1, 2)
		price_hh(price_pks(i, 1): price_pks(i + 1, 1) - 1) = ones (price_pks(i + 1, 1) - price_pks(i, 1), 1);
	end
end
if price_pks(end, 2) > price_pks(end - 1, 2)
	price_hh(price_pks(end, 1): end) = ones (size(price_hh(price_pks(end, 1): end)), 1);
end

% Make vector of lower highs for indicator:
ind_lh = zeros (length (indicator), 1);
for i = 2: rows (ind_pks) - 1
	if ind_pks(i, 2) < ind_pks(i - 1, 2)
		ind_lh(ind_pks(i, 1): ind_pks(i + 1, 1) - 1) = ones (ind_pks(i + 1, 1) - ind_pks(i, 1), 1);
	end
end
if ind_pks(end, 2) < ind_pks(end - 1, 2)
	ind_lh(ind_pks(end, 1): end) = ones (size(ind_lh(ind_pks(end, 1): end)), 1);
end

% Bullish divergence (= 1) forms when the price forms a lower low but the
% indicator forms a higher low.
% Bearish divergence (= -1) forms when price forms a higher high but the
% indicator forms a lower high.
diver = price_ll .* ind_hl - price_hh .* ind_lh;

end
