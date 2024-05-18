% function 2step_task(subID)

%% Load Settings and initialize 

clear, clc
subID = input('subID:','s');
settings_2step; % Load all the settings from the file

%% Run experiment

% Task information
trial_      = 0;            % Start at 0 because each trial is a full volume
n           = 180;          % 6 mins(6*60secs)/TR -> number of trials
ns          = 0;            % refers to slice signals

% Pyschtoolblox info
Priority(MaxPriority(window1)); % Give priority of resources to experiment
% Priority(2); % Testing lower priority
Screen('TextSize', window1, 50);
Screen('DrawText',window1,'A experiência começará em breve', (W/3), (H/2), textColor);
Screen('Flip',window1);

%% Conduct experiment

flag_first = 1;
flush(s) % Flush the serial port buffer (clean data from the port)
while 1 

    aux = [] % Wait for MRI trigger. Gives [] until the trigger is received
    aux = read(s,1,'uint8') % Reads one sample

    if aux == 100 % Signal for slice (100 is the ascii code for 'd')
        ns = ns + 1;
    end

    if (trial_ == n) || (~isempty(aux) && (aux==115)) % 115 is the ASCII code for 's' -> full volume
        
        if (trial_ == n) 
            finish = GetSecs;
            break
        end

        trial_ = trial_ + 1; % Update trial count

        if flag_first

            % 1. Blank screen & Cross
            Screen(window1, 'FillRect', backgroundColor);
            BlankTime = Screen('Flip', window1); % Timestamp for the blank screen
            disp('Estado: Blank / Cross')
            if trial_ == 1
                beg = GetSecs;
            end
            flag_first = 0;
            
        end
    end
end

sca; % sca -- Execute Screen('CloseAll');

fprintf('Tempo total: %f seconds\n', finish-beg)

% Save information is excel spreadsheet
name_file       =       [results_path '\eyes_closed_' num2str(subID) '.xlsx'];
M               =       [BlankTime_', Trigger'];
T               =       [array2table(M)];
T.Properties.VariableNames = {'BlankTime_','Trigger'};
writetable(T,name_file)

% end

