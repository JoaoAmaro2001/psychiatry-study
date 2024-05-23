% -------------------------------------------------------------------------
%                             Directories
% -------------------------------------------------------------------------

% orip = uigetdir('C:\'); % Use the GUI
cd('C:\git\JoaoAmaro2001\psychiatry-study');
orip = pwd;
addpath(genpath(orip));

% -------------------------------------------------------------------------
%                     Troubleshooting Psychtoolbox
% -------------------------------------------------------------------------

% root = 'C:\toolbox\Psychtoolbox';
% addpath(genpath(root));
% cd(root);
% SetupPyschtoolbox % -> For troubleshooting

% -------------------------------------------------------------------------
%                            Check Devices
% -------------------------------------------------------------------------

devices = PsychHID('Devices'); % Get a list of all human-interface devices (HID) 

% -------------------------------------------------------------------------
%                         Initiate Training
% -------------------------------------------------------------------------

training;

% -------------------------------------------------------------------------
%                         Initiate Experiment
% -------------------------------------------------------------------------

eyes_closed;
run_main_task;


