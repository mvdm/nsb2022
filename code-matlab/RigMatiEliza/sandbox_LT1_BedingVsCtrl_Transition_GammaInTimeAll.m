restoredefaultpath; clear classes; % start with a clean slate
 
cd('C:\Users\Administrator\Documents\GitHub\nsb2022\code-matlab\shared\'); % 
p = genpath(pwd); % create list of all folders from here
addpath(p);

cd('C:\Users\Administrator\Documents\GitHub\nsb2022\code-matlab\shared\'); %
p = genpath(pwd); % create list of all folders from here
addpath(p);
 
% can optionally add FieldTrip here when needed (commented out for now)
% cd('D:\My_Documents\GitHub\FieldTrip'); % or whatever you chose, obviously
% ft_defaults;
% rmpath('D:\My_Documents\GitHub\GitHub\fieldtrip\external\signal\') % needed to preserve use of MATLAB filtfilt.m

%%
% load data
cd('Z:\NSB_2022\03 Mouse\data\FAMS\2022-07-01_20-13-08_GoodOne');
% cd('Z:\NSB_2022\03 Mouse\data\FAMS\WH10-2022-06-30_LT1');
% cd('Z:\NSB_2022\03 Mouse\data\FAMS\WH10-2022-07-01_LT2_t1');

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
% WH=[80 210]; % WH10  

% LT1
WH=[1 11]; % WH10 Good One


for i=1:2
    indxs(i)=find(round(csc.tvec)==WH(i),1,'first');
end

    All=csc.tvec>csc.tvec(indxs(1)) & csc.tvec<csc.tvec(indxs(2));


for i=1:2
    indxsp(i)=find(round(pos.tvec)==WH(i),1,'first');
end

    Allp=pos.tvec>pos.tvec(indxsp(1)) & pos.tvec<pos.tvec(indxsp(2));

f_lg = [20 40]; % low-gamma freq band, to get power
f_hg = [65 85]; % high-gamma freq band, to get power

Fs = 1./median(diff(csc.tvec));

% low-gamma
datalg = bandpass(csc.data(All),f_lg,Fs); % 
datalg = abs(hilbert(datalg)).^2;

% xt=(145*30:165*30);

% datalg2 = downsample(datalgc,dsf);

figure
plot(csc.tvec(All),datalg./max(datalg),'r','Linewidth',2)
% plot(csc.tvec(Trans),datalg./max(datalg),'r','Linewidth',2)
hold on
plot(pos.tvec(Allp),pos.data(1,Allp)./max(pos.data(2,Allp)),'k','Linewidth',2)
% plot(pos.data(2,xt),datalg2,'r','Linewidth',2)

% hold on
% plot(csc.tvec(All),envelope(datalg./max(datalg)),'b','Linewidth',2)

 
% high-gamma
datahg = bandpass(csc.data(Trans),f_hg,Fs); % 
datahg = abs(hilbert(datahg)).^2;

% datalh2 = downsample(csc_pre.tvec,dsf);

hold on
plot(csc.tvec(Trans),datahg,'k','Linewidth',2)
% plot(csc.tvec(Trans),datahg./max(datahg),'k','Linewidth',2)
% plot(pos.data(2,xt),datahg2,'k','Linewidth',2)

xlim([145 165])

indx=(indxs(4)-indxs(3))/2;

signrank(datalg(1:(numel(datalg))/2),datalg(numel(datalg)/2:end-1))


%%


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


