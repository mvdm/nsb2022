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
cd('Z:\NSB_2022\03 Mouse\data\FAMS\2022-07-01_20-13-08_GoodOne'); % replace this with where you saved the data
 
cfg = [];
cfg.fc = {'TT2_LFP.ncs'};
%cfg.fc = {'CSC5.ncs'};% cell array with filenames to load
csc = LoadCSC(cfg);
csc.tvec = csc.tvec - csc.tvec(1); % set start of session time to 0

% Only for WH11

x=diff(csc.tvec);
[xx,ind]=max(x);
starting=csc.tvec>csc.tvec(ind);
csc.tvec=csc.tvec(starting);
csc.data=csc.data(starting);

%

% pos = LoadPos([]);
% pos.tvec = pos.tvec - pos.tvec(1);

%%

Fs = 1./median(diff(csc.tvec));

%% Plot Raw data

% figure
% plot(csc.tvec,csc.data);
% 
% sess_dur=numel(csc.tvec)/Fs;
% x=120;
% spt=(x*numel(csc.tvec))/sess_dur; % Sample point after 120 secs
% 
% figure
% plot(spt:spt+(60*Fs),csc.data(spt:spt+(60*Fs)));
% axis tight
% axis square
% ylabel('Voltage [V]','FontSize',16)
% xlabel('Time [s]','FontSize',16)
% ylim([-2e-03 2e-03])


%% Power spectra

figure

fvec = 0.1:0.1:150; 
wlen = 8192;
[p,f] = pwelch(csc.data, hanning(wlen), wlen/2, fvec, Fs); % hanning is a bell shaped curve for smoothing
plot(f,10*log10(p),'k'); xlabel('Frequency (Hz)','FontSize',16); ylabel('Power (dB)','FontSize',16);
set(gca, 'XTick', [0:5:150], 'TickDir', 'out'); grid on;
xlim([0 150]);
title('WH10 - Good One')




