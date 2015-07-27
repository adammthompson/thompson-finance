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
# @deftypefn {Function File} {[@var{trix_val, sigline} =} trix (@var{asset, t_period, s_period})
%
% Calculate the TRIX of an asset from a vector of closing prices (@var{asset}). TRIX is
% a momentum oscillator consisting of the rate of change of a triple-smoothed moving
% average.
%
% @var{trix_val} is the TRIX, a 1-period percent change in the triple-smoothed 
% @var{t_period}-period exponential moving average of @var{asset}. @var{sigline} is 
% the signal line, a @var{s_period}-period exponential moving average of @var{trix_val}.
%
% The beginning of TRIX is padded with NANs to match the size of @var{asset}.
%
% @var{t_period} and @var{s_period} are optional. The defaults are 15 and 9.
%
% Dependencies:
% m_average function.
% @end deftypefn

	
function [trix_val, sigline] = trix (asset, t_period = 15, s_period = 9)
% TRIX Calculate TRIX & signal line (x-day (9 typical) EMA).
%	trix(asset, t_period, s_period) = Calculate TRIX & s_period-day 
%	EMA of TRIX.
% asset is vector of closing prices.

if nargin < 1
	printf ('Error: must have at least one argument.')	
elseif nargin > 3
	printf ('Error: must have at most three arguments.')
elseif t_period > length (asset)
	error ('Error: t_period must be <= length of asset vector')
elseif s_period > length (asset)
	error ('Error: s_period must be <= length of asset vector')
elseif ! isvector (asset)
	error ('Error: asset must be a vector')
end

% 1) Single-smoothed EMA:
sm_ema1 = m_average (asset, t_period, 2);

% 2) Double-smoothed EMA:
sm_ema2 = m_average (sm_ema1, t_period, 2);

% 3) Triple-smoothed EMA:
sm_ema3 = m_average (sm_ema2, t_period, 2);

% 4) TRIX:
trix_val = [0; (diff (sm_ema3) ./ sm_ema3(1: end - 1))] * 100;

% Signal line:
sigline = [0; (m_average (trix_val(2: end), s_period, 2))];

end
