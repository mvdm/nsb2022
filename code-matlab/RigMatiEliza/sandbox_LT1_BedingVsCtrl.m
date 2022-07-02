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
cd('Z:\NSB_2022\03 Mouse\data\FAMS\WH12-2022-06-30_LT1'); % replace this with where you saved the data
 
cfg = [];
cfg.fc = {'TT2_LFP.ncs'};
%cfg.fc = {'CSC5.ncs'};% cell array with filenames to load
csc = LoadCSC(cfg);
csc.tvec = csc.tvec - csc.tvec(1); % set start of session time to 0

%% Only for WH11

% x=diff(csc.tvec);
% [xx,ind]=max(x);
% starting=csc.tvec>csc.tvec(ind);
% csc.tvec=csc.tvec(starting);
% csc.data=csc.data(starting);

pos = LoadPos([]);

% pos.tvec=pos.tvec(starting);

%%

pos.tvec = pos.tvec - pos.tvec(1);
figure
plot(pos.data(2,:),pos.tvec)

% WH=[80 140 155 215]; % WH10
% WH=[980 1050 1083 1157]; % WH11
WH=[77 139 160 220]; % WH12

for i=1:4
    indxs(i)=find(round(csc.tvec)==WH(i),1,'first');
end

    Control=csc.tvec>csc.tvec(indxs(1)) & csc.tvec<csc.tvec(indxs(2));
    Beding=csc.tvec>csc.tvec(indxs(3)) & csc.tvec<csc.tvec(indxs(4));


%%

Fs = 1./median(diff(csc.tvec));

%% Power spectra

figure

fvec = 0.1:0.1:150; 
wlen = 8192;
[p,f] = pwelch(csc.data(Control), hanning(wlen), wlen/2, fvec, Fs); % hanning is a bell shaped curve for smoothing
plot(f,10*log10(p),'k'); xlabel('Frequency (Hz)','FontSize',16); ylabel('Power (dB)','FontSize',16);

[p,f] = pwelch(csc.data(Beding), hanning(wlen), wlen/2, fvec, Fs); 
hold on
plot(f,10*log10(p),'r'); xlabel('Frequency (Hz)','FontSize',16); ylabel('Power (dB)','FontSize',16);
set(gca, 'XTick', [0:5:150], 'TickDir', 'out'); grid on;
xlim([0 150]);
legend('Control','Beding')
title('WH12')

ylim([-130 -60])


