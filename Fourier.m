% read audio file
directory = pwd;
audio = input('Which file?');
path = append('Sounds\', audio);
info = audioinfo(fullfile(directory, path));
[y,Fs] = audioread(fullfile(directory, path));

% get total samples from file and round to the next
% highest power of 2 (for better frequency resolution)
L = 2^nextpow2(info.TotalSamples);

Ts = 1/Fs; % sampling period
dt = 0:Ts:info.Duration - Ts; % signal duration vector

% compute Fourier transform of signal
ff = fft(y, L); 
fff = ff(1:L/2);

freq = Fs*(0:(L/2)-1)/L; % calculate frequency
amp = abs(fff); % get amplitude (real part of transform)
namp = amp/max(amp); % normalize amplitude

% plot original signal
subplot(2,1, 1);
plot(dt,y);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Original Signal');

% plot transformed signal
subplot(2,1, 2);
plot(freq, namp);
xlim([0, 5000]);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Transformed Signal');

thresh = 0.5; % threshold

% filter data for frequency peaks
% (aka the "notes" we're looking for)
init_peaks = findpeaks(namp);
filter = init_peaks > thresh;
peaks = init_peaks(filter);

% make a list of identified pitches from signal
lop = [];
for i = 1:length(peaks)
    index = find(namp == peaks(i));
    pitch = freq(index);
    lop = [lop, pitch];
end

% all pitch names
names = {'C0';
    'C#0/D-0';
    'D0';
    'D#0/E-0';
    'E0';
    'F0';
    'F#0/G-0';
    'G0';
    'G#0/A-0';
    'A0';
    'A#0/B-0';
    'B0';
    'C1';
    'C#1/D-1';
    'D1';
    'D#1/E-1';
    'E1';
    'F1';
    'F#1/G-1';
    'G1';
    'G#1/A-1';
    'A1';
    'A#1/B-1';
    'B1';
    'C2';
    'C#2/D-2';
    'D2';
    'D#2/E-2';
    'E2';
    'F2';
    'F#2/G-2';
    'G2';
    'G#2/A-2';
    'A2';
    'A#2/B-2';
    'B2';
    'C3';
    'C#3/D-3';
    'D3';
    'D#3/E-3';
    'E3';
    'F3';
    'F#3/G-3';
    'G3';
    'G#3/A-3';
    'A3';
    'A#3/B-3';
    'B3';
    'C4';
    'C#4/D-4';
    'D4';
    'D#4/E-4';
    'E4';
    'F4';
    'F#4/G-4';
    'G4';
    'G#4/A-4';
    'A4';
    'A#4/B-4';
    'B4';
    'C5';
    'C#5/D-5';
    'D5';
    'D#5/E-5';
    'E5';
    'F5';
    'F#5/G-5';
    'G5';
    'G#5/A-5';
    'A5';
    'A#5/B-5';
    'B5';
    'C6';
    'C#6/D-6';
    'D6';
    'D#6/E-6';
    'E6';
    'F6';
    'F#6/G-6';
    'G6';
    'G#6/A-6';
    'A6';
    'A#6/B-6';
    'B6';
    'C7';
    'C#7/D-7';
    'D7';
    'D#7/E-7';
    'E7';
    'F7';
    'F#7/G-7';
    'G7';
    'G#7/A-7';
    'A7';
    'A#7/B-7';
    'B7';
    'C8';
    'C#8/D-8';
    'D8';
    'D#8/E-8';
    'E8';
    'F8';
    'F#8/G-8';
    'G8';
    'G#8/A-8';
    'A8';
    'A#8/B-8';
    'B8'};
    

% create array of frequencies associated with above notes
pitches = zeros(108, 1);
for i = 1:108
    pitches(i) = 440 * (2^(1/12))^(i-58);
end
pitches(1);

err = 3; % error margin 

% match frequencies to note names
chord = '';
for i = 1:length(lop)
    curr = lop(i);
    for j = 1:108
        comp = pitches(j);
        if curr > (comp - err) && curr < (comp + err)
            chord = append(chord, names{j}, ' ');
        end
    end
end
chord

% pyversion C:\Users\harri\AppData\Local\Programs\Python\Python38\python.exe
py.music21.chord.Chord(chord).pitchedCommonName