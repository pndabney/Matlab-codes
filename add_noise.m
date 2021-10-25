function varargout=add_noise(X,SNR)
% [Xn, noise, var_signal, var_noise] = add_noise(X,SNR);
%
% Generates Gaussian noise and adds it to a signal
%
% INPUT:
%
% X               Signal
% SNR             Target signal to noise ratio, in dB
%
% OUTPUT:
%
% Xn              Signal with added Gaussian noise
% noise           Gaussian noise
% var_signal      Variance of the signal
% var_noise       Variance of the noise
%
% Last modified by pdabney@princeton.edu, 10/25/21

% Signal length
N = length(X);

% Get the variance of the signal
var_signal = var(X);

% Compute the variance of the noise
var_noise = var_signal/SNR;

% Generate Gaussian noise
sigma = sqrt(var_noise);
noise = sigma * randn(1,N);

% Add noise to signal
Xn = X + noise;


% Optional Output
vars = {Xn, noise, var_signal, var_noise};
varargout = vars(1:nargout);


end

