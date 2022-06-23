function update_fig(src, event)
% UPDATE_FIG nsb2021 figure callback function for updating video and photometry
% trace
%
% KEYBOARD COMMANDS:
%
%    Move Viewing Window
%    j:           user inputs a timepoint to "jump" to (seconds)
%    leftarrow:   0.5 windows left
%    rightarrow:  0.5 windows right

%% Declare global variables

global t hdl vid


%%
limits = get(hdl.s2h, 'XLim'); %get current limits; exists as limits(1) and limits(2), in array [1 2]
t = mean(limits); % finds center of current viewing window
flank = 0.5;

if strcmp(event.Key,'j')
    jumpHere = inputdlg('Jump to time = ___ seconds');
    if ~isempty(jumpHere) && ~isnan(str2double(jumpHere{1})) && isscalar(str2double(jumpHere{1}))
        next_location = str2double(jumpHere{1});
        limits = [next_location-flank next_location+flank];
    end 
end

if strcmp(event.Key, 'leftarrow')
    t = t - 1;
    limits = limits - 1;
end

if strcmp(event.Key, 'rightarrow')
    t = t + 1;
    limits = limits + 1;
end

%%
set(hdl.s2h, 'XLim', limits)

%%
idx = nearest_idx3(t, vid.tvec); % find which frame to load
this_frame = read(vid.Obj, idx);
axes(hdl.s1h); imshow(this_frame);