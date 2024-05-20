% function 2step_task(subID)

%% Load Settings and initialize 

clear, clc
subID = input('subID:','s'); % Input subject ID
settings_2step;              % Load all the settings from the file

% Task information
tr_point    = 0;             % Start at 0 because each trial is a full volume
tr_n        = 180;           % 6 mins(6*60secs)/TR -> number of trials
slice_n     = 0;             % refers to slice signals

% Pyschtoolblox info
Priority(MaxPriority(window1)); % Give priority of resources to experiment
Screen('TextSize', window1, 50);
Screen('DrawText',window1,'A experiência começará em breve', (W/3), (H/2), textColor);
Screen('Flip',window1);

% Start recording
flag_cross = 1;
flush(s) % Flush the serial port buffer (clean data from the port)
while 1 

    aux = [] % Wait for MRI trigger. Gives [] until the trigger is received
    aux = read(s,1,'uint8') % Reads one sample

    if aux == 100 % Signal for slice (100 is the ascii code for 'd')
        slice_n = slice_n + 1;
    end

    if (tr_point == tr_n) || (~isempty(aux) && (aux==115)) % 115 is the ASCII code for 's' -> full volume
        
        if (tr_point == tr_n) 
            finish = GetSecs;
            break
        end

        tr_point = tr_point + 1; % Update trial count

        if flag_cross

            % 1. Blank screen & Cross
            Screen(window1, 'FillRect', backgroundColor);
            BlankTime = Screen('Flip', window1); % Timestamp for the blank screen (Important?)
            disp('Estado: Blank / Cross')
            if tr_point == 1
                beg = GetSecs;
            end
            flag_first = 0;
            
        end
    end
end

sca; % sca -- Execute Screen('CloseAll');

fprintf('Tempo total: %f seconds\n', finish-beg)
fprintf('Número de eventos "100": %f \n', slice_n)

% end

