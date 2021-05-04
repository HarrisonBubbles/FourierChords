% read audio file
directory = pwd;
info = audioinfo(fullfile(directory, 'Sounds\CMajor.wav'));
[y,Fs] = audioread(fullfile(directory, 'Sounds\CMajor.wav'));

% get total samples from file and round to the next
% highest power of 2 (for better frequency resolution)
L = 2^nextpow2(info.TotalSamples);

ff = fft(y, L);
fff = ff(1:L/2);

freq = Fs*(0:(L/2)-1)/L;
amp = abs(fff);

plot(freq, amp)
xlim([0, 500])

% dy=gradient(amp(:))./gradient(freq(:));
% plot(freq,dy);


% threshold 
% error margin 