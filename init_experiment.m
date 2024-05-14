%% Directories

cd('C:\git\JoaoAmaro2001\psychiatry-study');
orip = pwd;
addpath(genpath(orip));
stim_path = fullfile(orip,'stimuli');
results_path = fullfile(orip,'results');
resting_state_path = fullfile(orip,'resting_state');

% -------------------------------------------------------------------------
%                           Troubleshooting
% -------------------------------------------------------------------------

% root = 'C:\toolbox\Psychtoolbox';
% addpath(genpath(root));
% cd(root);
% SetupPyschtoolbox % -> For troubleshooting

% -------------------------------------------------------------------------
%                               Devices
% -------------------------------------------------------------------------

devices = PsychHID('Devices'); % Get a list of all human-interface devices (HID) 

%% Prelims
settings_2step;

%% Training
settings_training;
training;

%% Paradigm
eyes_closed;
run_images_task;

c.data1 = 'new value'; % Modify some data
c.data2 = 123;

modifiedKeys = flush(c); % Write the changes to the persistence service

disp(modifiedKeys); % Display the keys that have been modified


