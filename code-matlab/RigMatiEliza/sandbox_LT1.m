restoredefaultpath; clear classes; % start with a clean slate
 
cd('C:\Users\Administrator\Documents\GitHub\nsb2022\code-matlab\shared\'); % or, wherever your code is located -- NOTE \shared subfolder!
p = genpath(pwd); % create list of all folders from here
addpath(p);
 
% can optionally add FieldTrip here when needed (commented out for now)
% cd('D:\My_Documents\GitHub\FieldTrip'); % or whatever you chose, obviously
% ft_defaults;
% rmpath('D:\My_Documents\GitHub\GitHub\fieldtrip\external\signal\') % needed to preserve use of MATLAB filtfilt.m

%%
% load data
cd('Z:\NSB_2022\03 Mouse\data\FAMS\WH12-2022-06-29_mazerecording'); % replace this with where you saved the data
 
cfg = [];
cfg.fc = {'CSC1.ncs'}; % cell array with filenames to load
csc = LoadCSC(cfg);

figure
plot(csc.tvec,csc.data);
%%
% FS=2000;

Fs = 1./mean(diff(csc.tvec));
%%

cfg = [];
cfg.fc = {'CSC7.ncs'}; % cell array with filenames to load
csc = LoadCSC(cfg);

figure
plot(csc.tvec,csc.data);

sess_dur=numel(csc.tvec)/Fs;
x=120;
spt=(x*numel(csc.tvec))/sess_dur; % Sample point after 120 secs

figure
plot(spt:spt+(60*Fs),csc.data(spt:spt+(60*Fs)));
axis tight
axis square
ylabel('Voltage [V]','FontSize',16)
xlabel('Time [xx]','FontSize',16)
ylim([-2e-03 2e-03])

%%

% check if sampling is ok
plot(diff(csc.tvec)); % only minimal differences


dsf = 4;
csc.data = decimate(csc.data,dsf);
csc.tvec = downsample(csc.tvec,dsf);
csc.cfg.hdr{1}.SamplingFrequency = csc.cfg.hdr{1}.SamplingFrequency./dsf;

wSize = 1024;
[Pxx,F] = periodogram(csc.data,hamming(length(csc.data)),length(csc.data),Fs);
plot(F,10*log10(Pxx),'k'); xlabel('Frequency (Hz)','FontSize',16); ylabel('Power (dB)','FontSize',16);
xlim([0 100]);

figure
plot(csc.tvec,csc.data);
axis tight
axis square
ylabel('Voltage [V]','FontSize',16)
xlabel('Time [us]','FontSize',16)
%% Trying power spectra

[p,f] = pspectrum(csc.data,FS);
 
[p,f] = pwelch(csc.data,Fs);

% win=5;
% [p,f] = pwelch(csc.data,2000*win,'',2^14);

figure
plot(f(1:150),abs(p(1:150)))

% s = spectrogram(csc.data,FS);




