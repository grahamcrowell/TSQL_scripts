clc; close all; clear all;      % Clean up the workspace

Fs = 1000;                      % Sampling frequency
Ts = 1/Fs;                      % Sample period
N = 2^10;                       % Length of signal. Must be a power of two
t = (0:N-1)*Ts;                 % Time vector
% Sum of a 40 Hz sinusoid, 80 Hz sinusoid and a 240 Hz sinusoid
s = 8*sin(2*pi*40*t) + 4*sin(2*pi*80*t)+2*sin(2*pi*240*t); 

% Plot signal.
figure(1)
plot(t,s) 
title('Signal s(t)')
xlabel('Time (s)')
ylabel('s')


X = fft(s,N)/N;                 %FFT
f = Fs/2*linspace(0,1,N/2+1); 	%frequencies

% Plot single-sided amplitude spectrum.
figure(2)
plot(f,2*abs(X(1:N/2+1))) 
title('Single-Sided Amplitude Spectrum of s(t)')
xlabel('Frequency (Hz)')
ylabel('|X(f)|')
grid on