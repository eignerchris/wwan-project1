% 19 Cell Deployment Simulation

%%% SETUP %%%
cell_radiuses      = [.5, .75, 1]      % miles
bs_tx_powers       = [30, 40]          % dBm
bs_ant_height      = 30                % meters
tx_block_sizes     = [500, 1000, 1500] % bytes
target_bler        = [.05, .10, .20]
ms_ant_height      = 1.5               % meters
num_users_per_cell = 25
carrier_freqs      = []
%%%%%%%%%%%%%

%%% UTILITY FUNCTIONS %%%

% calculates carrier to interference and noise ratio
% args:
%   r   - radius of cell
%   Ds  - list of distances from interferers
%   gam - absorption coefficient ( =~ 3.52 )
function cinr(r, Ds, gam)
  
end

% calculates signal to noise ratio
% args:
%   P_s - signal power
%   P_n - noise power
function snr(P_s, P_n)
	return P_s/P_n
end

% calculates urban path loss
% args: 
%   d - distance from src
%   f - carrier freq in GHz
function PL_urban(d, f)
	return [44.9 - 6.55 * log([bs_ant_height])] * log(d/1000) + 45.5 + (35.46 - 1.1 * ms_ant_height) + log(f) - 13.82 * log(bs_ant_height) + 0.7 * ms_ant_height + 3 
end
%%%%%%%%%%%%%%%%%%%%%%%%

N = 10^5;
alphabet = [-3 -1 1 3];												% 4-PAM alphabet
snr = [0:40];																	% 0db to 40db SNR
for i = 1:length(snr)
	
	% MODULATION
	clean_sig = randsrc(1, N, alphabet);				% generate symbol stream from 4-PAM alphabet
	sigma = 10^((snr(i) - 10 * log(5))/20);			% calculate variance
	noise = 1/sigma * randn(1, N);							% generate noise vector
	tx = clean_sig + noise;							  			% transmitted signal = clean signal + noise
	
	% DEMODULATION
	rx = zeros(1,N);	    											% init array for demodulated signal
	rx(find(tx < -2)) = -3;
	rx(find(tx >= 2)) = 3;
	rx(find(tx >= -2 & tx < 0)) = -1;
	rx(find(tx >= 0 & tx < 2)) = 1;

	err(i) = nnz(clean_sig - rx);
end

ber = err/N

close all
figure
semilogy(snr, ber);
hold on
axis([0 40 10^-5 1])
grid on
legend('simulation');
xlabel('snr dB')
ylabel('Bit Error Rate')
title('Bit error probability curve for 4-PAM modulation w/ grey coding')

print('system-a.png', '-dpng')