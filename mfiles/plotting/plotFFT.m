%% J Ivers
%% 03-30-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotFFT(x_I,fs)

L = length(x_I);
N = pow2(nextpow2(L));          %find next higer power of 2 of X_I len
f = fs*(0:(N-1)/2)/N;                 %freq axis
% f = fs*(-(N-1)/2:(N-1)/2)/N;                 %freq axis
X_I = fft(x_I,N);               %power of 2 DFT
M_X_I = abs(X_I)*2/N;           %take the magnitude and cancel out DFT gains
Ph_X_I = unwrap(angle(X_I)).*(360/(2*pi));
l = length(f);

figure;
% subplot(2,1,1)
plot(f,M_X_I(1:l))
% subplot(2,1,2)
% plot(f,Ph_X_I(1:l))



