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
% cd('Z:\NSB_2022\03 Mouse\data\FAMS\WH10-2022-06-30_LT1');
cd('Z:\NSB_2022\03 Mouse\data\FAMS\WH10-2022-07-01_LT2_t1');

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

% LT1
% WH=[80 100 145 165 190 210]; % WH10  
% WH=[980 1000 1075 1095 1130 1150]; % WH11
% WH=[77 97 155 175 200 220]; % WH12

% LT2
WH=[90 105 130 145 155 170]; % WH10
% WH=[87 107 127 147 155 175]; % WH10

for i=1:6
    indxs(i)=find(round(csc.tvec)==WH(i),1,'first');
end

    Pre=csc.tvec>csc.tvec(indxs(1)) & csc.tvec<csc.tvec(indxs(2));
    Trans=csc.tvec>csc.tvec(indxs(3)) & csc.tvec<csc.tvec(indxs(4));
    Post=csc.tvec>csc.tvec(indxs(5)) & csc.tvec<csc.tvec(indxs(6));


%%

Fs = 1./median(diff(csc.tvec));

%% Power spectra

% Putative Diff 15 and 40 Hz

figure

fvec = 0.1:0.1:150; 
wlen = 8192;
[p1,f] = pwelch(csc.data(Pre), hanning(wlen), wlen/2, fvec, Fs); % hanning is a bell shaped curve for smoothing
plot(f,10*log10(p1),'b'); xlabel('Frequency (Hz)','FontSize',16); ylabel('Power (dB)','FontSize',16);

[p2,f] = pwelch(csc.data(Trans), hanning(wlen), wlen/2, fvec, Fs); 
hold on
plot(f,10*log10(p2),'r'); xlabel('Frequency (Hz)','FontSize',16); ylabel('Power (dB)','FontSize',16);

[p3,f] = pwelch(csc.data(Post), hanning(wlen), wlen/2, fvec, Fs);
hold on
plot(f,10*log10(p3),'k'); xlabel('Frequency (Hz)','FontSize',16); ylabel('Power (dB)','FontSize',16);
set(gca, 'XTick', [0:5:150], 'TickDir', 'out'); grid on;
xlim([0 150]);
legend('Pre','Trans','Post')
title('WH10')

ylim([-130 -60])

% self=f>15 & f<40;

self=f>25 & f<45;

signrank(p1(self),p2(self))
signrank(p1(self),p3(self))
signrank(p2(self),p3(self))


