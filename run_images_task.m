% function 2step_task(subID)

% 2step task experiment template
% To run, call this function with the id code for your subject, eg:
% 2step_task('ke1');
%
% See instructions file for more detailed instructions.

%-------------------------------------------------------------------------------


clear, clc
subID = input('subID:','s');
settings_2step; % Load all the settings from the file

% Run experiment


% % % %% Code to present images
% % %
% % % file = imageList{t};
% % % moviename = fullfile(imageFolder,file);
% % %
% % % % Open movie file:
% % % movie = Screen('OpenMovie', window1, moviename);
% % % % Start playback engine:
% % % Screen('PlayMovie', movie, 1);
% % %
% % % shift_left=(W/4);
% % % shift_bottom=(H/4);
% % % % dst_rect = [shift_left shift_bottom shift_left*3 shift_bottom*3];
% % % dst_rect = [0 0 W H];
% % %
% % % present_image(window1,movie,dst_rect)
% % %
% % % % Open movie file:
% % % movie = Screen('OpenMovie', window1, moviename);
% % % % Start playback engine:
% % % Screen('PlayMovie', movie, 1);
% % %  vid = Screen('GetMovieImage', window1, movie);
% % %
% % %  new_dst_rect=[];
% % %  shift_left=(W/4);
% % %  shift_bottom=(H/4);
% % %  new_dst_rect = [shift_left shift_bottom shift_left*3 shift_bottom*2];
% % %
% % %  % Draw the new texture immediately to screen:
% % %  Screen('DrawTexture', window1, vid,[],new_dst_rect);
% % %
% % %  % Update display:
% % %  Screen('Flip', window1);
% % %
% % %  % Release texture:
% % %  Screen('Close', vid);
% % %
% % %  break
% % %
% % %  end
% % %
% % %  % Close movie:
% % %  Screen('CloseMovie', movie);
% % %
% % %  imageTime=Screen('Flip', window1);
% % %
% % % sca;




% -------------------------------------------------------------------------
%                           State Information:
%                               
% 0. Blank screen
% 1. Blank screen & Cross
% 2. Load active stimulus
% 3. Load active stimulus response
% 4. Load neutral stimulus
% 5. Load neutral stimulus response
% -------------------------------------------------------------------------


state = 1;

%% Conduct experiment

% Wait for MRI trigger
flush(s)
while 1
    aux = []
    tic
    aux = read(s,1,'uint8') % Reads one sample
    toc
    if (trial_==n && state==13) || (~isempty(aux) && (aux==115) ) || (time_to_vote==1) 
        varstr='yes'
        if (state==13)
            break
        end
        if aux==115
            nt=nt+1;
            display(nt);
            flag_=1;
        end
    
    switch state
        case 1
            % 1. Blank screen & Cross
            Screen(window1, 'FillRect', backgroundColor);
            BlankTime=Screen('Flip', window1);
            disp('Estado: Blank / Cross')
            disp(nt)
            if trial_ ==1
                TriggerStart=BlankTime;
            end
            
            % Cross
            imread(fullfile(stim_path,'crosses','crosses_00002.png')); % Load the image
            texture = Screen('MakeTexture', window1, img); % Make a texture from the image
            Screen('DrawTexture', window1, texture); % Draw the texture to the screen
            tFixation = Screen('Flip', window1, BlankTime + (2*TR-fixationDuration1) - slack);  %Cross should appear during the same blank TR
            %             NetStation('Event', 'cross');
            disp('Cross')
            time_cross=GetSecs - TriggerStart
            aux=[];
            state = 2;
%             flush(s)

        case 2
            % Load image
            disp('Estado: Nada para fazer')
            disp(nt)
                        
            file = imageList{randomizedTrials(trial_)};
            image_name_trial{trial_}=file;
            moviename = fullfile(imageFolder,file);
            movienames_trials{trial_}=moviename;
            disp(moviename)
            % Open movie file:
            movie = Screen('OpenMovie', window1, moviename);
            % Start playback engine:
            Screen('PlayMovie', movie, 1);
            
            BlankTime_(trial_)=BlankTime-TriggerStart;
            FixTime(trial_)=tFixation-TriggerStart;
            Trigger(trial_)=TriggerStart;
            
            Screen('FillRect', window1, backgroundColor);
            
            aux=[];
            state = 3;
            %3.  Show the image
            dst_rect = [0 0 W H];
            
        case 3
            tic
            [vid,VidTime]=present_image(window1,movie,dst_rect);
            %             imageTime=Screen('Flip', window1);
            time_image = VidTime - TriggerStart;
            
            % Load Score image
            image1Time(trial_)=time_image;
            %Variables for scoring
            
            % Open movie file:
            movie_frame1=moviename
            a=strsplit(movie_frame1,'.mp4')
            movie_frame1=strcat(a{1,1},'_Moment.jpg')
            vid = imread(movie_frame1);
            vid = imresize( vid , 0.6);
            imageSize = size(vid);
            
            % Make the new texture (i.e., the #1 image frame):
            shift_left=(W/4);
            shift_bottom=(H/4);
            new_dst_rect = [shift_left shift_bottom shift_left*3 shift_bottom*2];
            
            % Release texture:
%             Screen('Close', vid);
            % Close movie:
%             Screen('CloseMovie', movie);
            
            imageDisplay=Screen('MakeTexture', window1, vid);
            
            % Make the new texture (i.e., score image):
            file2='Score_Valence.JPG'
            img = imread(fullfile(imageFolder_score,file2));
            img = imresize( img , 0.7);
            imageSize = size(img);
            shift_left=(W-imageSize(2))/2;
            shift_bottom=((3/2)*H-imageSize(1))/2;
            posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
           
            imagescoreDisplay=Screen('MakeTexture', window1, img);

            % ADDED 
%             Screen(window1, 'FillRect', backgroundColor);
%             END_VID_Time=Screen('Flip', window1);
                        
            bothDisplay=[imageDisplay imagescoreDisplay];
            pos=[new_dst_rect' posimage'];
            
            % Draw the new texture immediately to screen:
            Screen('DrawTextures', window1, bothDisplay, [], pos);
            
            aux=[];
            state=4;
            toc

            flush(s)

        case 4
            % Update display:
            disp((~isempty(aux) &&( (aux==115) )))
            tempo_4=GetSecs - TriggerStart
            ValenceTime=Screen('Flip', window1);
            SelectValenceTime(trial_)=ValenceTime-TriggerStart;
            disp('Estado: 4')
            time_to_vote=1;
            aux=[];
            state=5;
%             flush(s)
            
        case 5
            disp((~isempty(aux) &&( (aux==115) )))
            if (aux~=115)
                rtValence(trial_) = GetSecs - ValenceTime; % Reaction time measured after start score image/text
            end
            disp('Estado: 5')
            disp(nt)
            disp(aux)
            tempo_5=GetSecs - TriggerStart
            try
            switch aux
                case 97 %98 %Left button up
                    score_=1
                    
                case 98 % 97 %Left button down
                    score_ = 2 %Start in image score = 5
                    
                case 100 %99
                    score_=3 %Right button down
                    
                case 99 %100 %Right button up
                    score_ = 4
                    
                case 115 %Trigger of Next trial
                    state=6;
                    b=1
                    aux=[];
%                     flush(s)
            end
            catch
                state=6;
                b=1
                aux=[];
            end
            if score_>0
                choiceValence(trial_)=score_;
                file=strcat('Score_',string(score_),'.JPG')
                img = imread(fullfile(imageFolder_score,file));
                img = imresize( img , 0.7);
                imageSize = size(img);
                shift_left=(W-imageSize(2))/2;
                shift_bottom=((3/2)*H-imageSize(1))/2;
                posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                imagescoreDisplay=Screen('MakeTexture', window1, img);
                
                bothDisplay=[imageDisplay imagescoreDisplay];
                pos=[new_dst_rect' posimage'];
                
                % Draw the new texture immediately to screen:
                Screen('DrawTextures', window1, bothDisplay, [], pos);
                ImageTime = Screen('Flip', window1);
                time_to_vote=0;
                flag_vote_state4=1;
                score_=0;
                state=6;
                
%                 % ADDED
%                 Screen(window1, 'FillRect', backgroundColor);
%                 VOTED_VALENCE_Time=Screen('Flip', window1);
                
%                 flush(s)

            end
            aux=[];
            
        case 6
            disp('Estado: 6')
            disp(nt)
            disp(aux)
            tempo_6=GetSecs - TriggerStart

            if flag_vote_state4~=1
                %%%for state 6 scoring
                if (aux~=115)
                    rtValence(trial_) = GetSecs - ValenceTime; % Reaction time measured after start score image/text
                end
                
                try
                switch aux
                    case 97 %98 %Left button up
                        score_=1
                        
                    case 98 %97 %Left button down
                        score_ = 2 %Start in image score = 5
                        
                    case 100 %99
                        score_=3 %Right button down
                        
                    case 99 %100 %Right button up
                        score_ = 4
                        
                    otherwise
                        % ADDED
%                         Screen(window1, 'FillRect', backgroundColor);
                        NO_VALENCE_Time=Screen('Flip', window1);
                        state=7;
                end
                
                catch
                        NO_VALENCE_Time=Screen('Flip', window1);
                        state=7;
                end
                        
                if score_>0
                    choiceValence(trial_)=score_;
                    file=strcat('Score_',string(score_),'.JPG')
                    img = imread(fullfile(imageFolder_score,file));
                    img = imresize( img , 0.7);
                    imageSize = size(img);
                    shift_left=(W-imageSize(2))/2;
                    shift_bottom=((3/2)*H-imageSize(1))/2;
                    posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                    imagescoreDisplay=Screen('MakeTexture', window1, img);
                    
                    bothDisplay=[imageDisplay imagescoreDisplay];
                    pos=[new_dst_rect' posimage'];
                    
                    % Draw the new texture immediately to screen:
                    Screen('DrawTextures', window1, bothDisplay, [], pos);
                    ImageTime = Screen('Flip', window1);
                    
                    time_to_vote=0;
%                     state=7;

                    %MODIFIED!!!!
                    state=61;

                    score_=0;
                    aux=[];
                    
                end
                
%                 %% Added!!!    
%             % Make the new texture (i.e., score image):
%             file2='Score_Arousal.JPG'
%             img = imread(fullfile(imageFolder_score,file2));
%             img = imresize( img , 0.7);
%             imageSize = size(img);
%             shift_left=(W-imageSize(2))/2;
%             shift_bottom=((3/2)*H-imageSize(1))/2;
%             posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
%             imagescoreDisplay=Screen('MakeTexture', window1, img);
%             
%             bothDisplay=[imageDisplay imagescoreDisplay];
%             pos=[new_dst_rect' posimage'];
%             
%             % Draw the new texture immediately to screen:
%             Screen('DrawTextures', window1, bothDisplay, [], pos);
%             
                
            else
                %ADDED
                state=61;
            end
            
            
            %%%% ADDED!!!!!
            if state~=61
                % Make the new texture (i.e., score image):
                file2='Score_Arousal.JPG'
                img = imread(fullfile(imageFolder_score,file2));
                img = imresize( img , 0.7);
                imageSize = size(img);
                shift_left=(W-imageSize(2))/2;
                shift_bottom=((3/2)*H-imageSize(1))/2;
                posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                imagescoreDisplay=Screen('MakeTexture', window1, img);
                
                bothDisplay=[imageDisplay imagescoreDisplay];
                pos=[new_dst_rect' posimage'];
                
                % Draw the new texture immediately to screen:
                Screen('DrawTextures', window1, bothDisplay, [], pos);
            end
            
            
            aux=[];
            time_to_vote=0;    
            flag_vote_state4=0;

            disp(state)
            
            
        case 61
            % Make time until total 6s prior to next state:
            %ADDED
            VALENCE_Time1=Screen('Flip', window1);
            
            disp('Estado 61')
            tempo_61=GetSecs-TriggerStart
            aux=[];
            state=7;
            
            %% Added!!!    
            % Make the new texture (i.e., score image):
            file2='Score_Arousal.JPG'
            img = imread(fullfile(imageFolder_score,file2));
            img = imresize( img , 0.7);
            imageSize = size(img);
            shift_left=(W-imageSize(2))/2;
            shift_bottom=((3/2)*H-imageSize(1))/2;
            posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
            imagescoreDisplay=Screen('MakeTexture', window1, img);
            
            bothDisplay=[imageDisplay imagescoreDisplay];
            pos=[new_dst_rect' posimage'];
            
            % Draw the new texture immediately to screen:
            Screen('DrawTextures', window1, bothDisplay, [], pos);
            

        case 7
            % Update display:
            tempo_7=GetSecs - TriggerStart
            ArousalTime=Screen('Flip', window1);
            SelectArousalTime(trial_)=ArousalTime-TriggerStart;
            disp('Estado: 7')
            time_to_vote=1;
            aux=[];
            state=8;
            
        case 8
            if (aux~=115)
                rtArousal(trial_) = GetSecs - ArousalTime; % Reaction time measured after start score image/text
            end
            disp('Estado: 8')
            disp(aux)
            disp(nt)
            tempo_8=GetSecs - TriggerStart
            try
            switch aux
                case 97 %98 %Left button up
                    score_=1;
                    
                case 98 % %Left button down
                    score_ = 2; %Start in image score = 5
                    
                case 100 %99
                    score_=3; %Right button down
                    
                case 99 %100 %Right button up
                    score_ = 4;
                    
                case 115 %Trigger of Next trial
                    state=9;
                    b=1
                    aux=[];
%                     flush(s)
            end
            catch
                state=9;
                b=1
                aux=[];
            end
            if score_>0
                choiceArousal(trial_)=score_;
                file=strcat('Score_',string(score_),'.JPG')
                img = imread(fullfile(imageFolder_score,file));
                img = imresize( img , 0.7);
                imageSize = size(img);
                shift_left=(W-imageSize(2))/2;
                shift_bottom=((3/2)*H-imageSize(1))/2;
                posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                imagescoreDisplay=Screen('MakeTexture', window1, img);
                
                bothDisplay=[imageDisplay imagescoreDisplay];
                pos=[new_dst_rect' posimage'];
                
                % Draw the new texture immediately to screen:
                Screen('DrawTextures', window1, bothDisplay, [], pos);
                ImageTime = Screen('Flip', window1);
                time_to_vote=0;
                flag_vote_state4=1;
                score_=0;
                state=9;
                
%                                 % ADDED
%                 Screen(window1, 'FillRect', backgroundColor);
%                 VOTED_AROUSAL_Time=Screen('Flip', window1);
                
            end
            aux=[];
%             flush(s)
            
        case 9
            disp('Estado: 9')
            disp(nt)
            tempo_9=GetSecs - TriggerStart

            if flag_vote_state4~=1
                %%%for state 6 scoring
                if (aux~=115)
                    rtArousal(trial_) = GetSecs - ArousalTime; % Reaction time measured after start score image/text
                end
                
                try
                switch aux
                    case 97 %98 %Left button up
                        score_=1
                        
                    case 98 %97 %Left button down
                        score_ = 2 %Start in image score = 5
                        
                    case 100 %99
                        score_=3 %Right button down
                        
                    case 99 %100 %Right button up
                        score_ = 4
                    
                    otherwise
%                     Screen(window1, 'FillRect', backgroundColor);
                    NO_AROUSAL_Time=Screen('Flip', window1);
                    state=10;
                end
                
                catch
                    NO_AROUSAL_Time=Screen('Flip', window1);
                    state=10;
                end
                
                if score_>0
                    choiceArousal(trial_)=score_;
                    file=strcat('Score_',string(score_),'.JPG')
                    img = imread(fullfile(imageFolder_score,file));
                    img = imresize( img , 0.7);
                    imageSize = size(img);
                    shift_left=(W-imageSize(2))/2;
                    shift_bottom=((3/2)*H-imageSize(1))/2;
                    posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                    imagescoreDisplay=Screen('MakeTexture', window1, img);
                    
                    bothDisplay=[imageDisplay imagescoreDisplay];
                    pos=[new_dst_rect' posimage'];
                    
                    % Draw the new texture immediately to screen:
                    Screen('DrawTextures', window1, bothDisplay, [], pos);
                    ImageTime = Screen('Flip', window1);
                    
                    time_to_vote=0;
%                     state=10;

                    %MODIFIED!!!!
                    state=91;

                    score_=0;
                    aux=[];
                    
%                     score_=0;
%                     aux=[];
%                    
%                     %ADDED
%                     AROUSAL_Time2=Screen('Flip', window1,ImageTime+0.5);
                    
                end
                
%                             % Make the new texture (i.e., score image):
%             file2='Score_Familiarity.JPG'
%             img = imread(fullfile(imageFolder_score,file2));
%             img = imresize( img , 0.7);
%             imageSize = size(img);
%             shift_left=(W-imageSize(2))/2;
%             shift_bottom=((3/2)*H-imageSize(1))/2;
%             posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
%             imagescoreDisplay=Screen('MakeTexture', window1, img);
%             
%             bothDisplay=[imageDisplay imagescoreDisplay];
%             pos=[new_dst_rect' posimage'];
%             
%             % Draw the new texture immediately to screen:
%             Screen('DrawTextures', window1, bothDisplay, [], pos);
                
            else

                state=91;
            end
            
              
            %%%% ADDED!!!!!
            if state~=91
                % Make the new texture (i.e., score image):
                file2='Score_Familiarity.JPG'
                img = imread(fullfile(imageFolder_score,file2));
                img = imresize( img , 0.7);
                imageSize = size(img);
                shift_left=(W-imageSize(2))/2;
                shift_bottom=((3/2)*H-imageSize(1))/2;
                posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                imagescoreDisplay=Screen('MakeTexture', window1, img);
                
                bothDisplay=[imageDisplay imagescoreDisplay];
                pos=[new_dst_rect' posimage'];
                
                % Draw the new texture immediately to screen:
                Screen('DrawTextures', window1, bothDisplay, [], pos);
            end
            
            
            aux=[];
            time_to_vote=0;
            flag_vote_state4=0;           

            disp(state)

%             % Make the new texture (i.e., score image):
%             file2='Score_Familiarity.JPG'
%             img = imread(fullfile(imageFolder_score,file2));
%             img = imresize( img , 0.7);
%             imageSize = size(img);
%             shift_left=(W-imageSize(2))/2;
%             shift_bottom=((3/2)*H-imageSize(1))/2;
%             posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
%             imagescoreDisplay=Screen('MakeTexture', window1, img);
%             
%             bothDisplay=[imageDisplay imagescoreDisplay];
%             pos=[new_dst_rect' posimage'];
%             
%             % Draw the new texture immediately to screen:
%             Screen('DrawTextures', window1, bothDisplay, [], pos);
            
        case 91
            % Make time until total 6s prior to next state:
            %ADDED
            AROUSAL_Time1=Screen('Flip', window1);
            
            disp('Estado 91')
            tempo_91=GetSecs-TriggerStart
            aux=[];
            state=10;
            
            %% Added!!!
            % Make the new texture (i.e., score image):
            file2='Score_Familiarity.JPG'
            img = imread(fullfile(imageFolder_score,file2));
            img = imresize( img , 0.7);
            imageSize = size(img);
            shift_left=(W-imageSize(2))/2;
            shift_bottom=((3/2)*H-imageSize(1))/2;
            posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
            imagescoreDisplay=Screen('MakeTexture', window1, img);
            
            bothDisplay=[imageDisplay imagescoreDisplay];
            pos=[new_dst_rect' posimage'];
            
            % Draw the new texture immediately to screen:
            Screen('DrawTextures', window1, bothDisplay, [], pos);
            
        case 10
            % Update display:
            tempo_10=GetSecs - TriggerStart

            FamiliarityTime=Screen('Flip', window1);
            SelectFamiliarityTime(trial_)=FamiliarityTime-TriggerStart;
            disp('Estado: 10')
            time_to_vote=1;
            aux=[];
            state=11;
%             flush(s)
        
        case 11
            if (aux~=115)
                rtFamiliarity(trial_) = GetSecs - FamiliarityTime; % Reaction time measured after start score image/text
            end
            disp('Estado: 11')
            disp(nt)
            tempo_11=GetSecs - TriggerStart
            try
            switch aux
                case 97 %98 %Left button up
                    score_=1
                    
                case 98 %97 %Left button down
                    score_ = 2 %Start in image score = 5
                    
                case 100 %99
                    score_=3 %Right button down
                    
                case 99 %100 %Right button up
                    score_ = 4
                    
                case 115 %Trigger of Next trial
                    state=12;
                    b=1
                    aux=[];
            end
            catch
                state=12;
                b=1
                aux=[];
            end
            if score_>0
                choiceFamiliarity(trial_)=score_;
                file=strcat('Score_',string(score_),'.JPG')
                img = imread(fullfile(imageFolder_score,file));
                img = imresize( img , 0.7);
                imageSize = size(img);
                shift_left=(W-imageSize(2))/2;
                shift_bottom=((3/2)*H-imageSize(1))/2;
                posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                imagescoreDisplay=Screen('MakeTexture', window1, img);
                
                bothDisplay=[imageDisplay imagescoreDisplay];
                pos=[new_dst_rect' posimage'];
                
                % Draw the new texture immediately to screen:
                Screen('DrawTextures', window1, bothDisplay, [], pos);
                ImageTime = Screen('Flip', window1);
                time_to_vote=0;
                flag_vote_state4=1;
                score_=0;
                state=12;
                
                                % ADDED
%                 Screen(window1, 'FillRect', backgroundColor);
%                 VOTED_FAMIL_Time=Screen('Flip', window1);
                
            end
            aux=[];
            
        case 12
            disp('Estado: 12')
            disp(nt)
            tempo_12=GetSecs - TriggerStart
            
            if flag_vote_state4~=1
                %%%for state 12 scoring
                if (aux~=115)
                    rtFamiliarity(trial_) = GetSecs - FamiliarityTime; % Reaction time measured after start score image/text
                end
                
                try
                switch aux
                    case 97 %98 %Left button up
                        score_=1
                        
                    case 98 %97 %Left button down
                        score_ = 2 %Start in image score = 5
                        
                    case 100 %99
                        score_=3 %Right button down
                        
                    case 99 % 100 %Right button up
                        score_ = 4
                        
                    otherwise
                        % ADDED
                    NO_FAMIL_Time=Screen('Flip', window1);
                    state=1;
                end
                catch
                    NO_FAMIL_Time=Screen('Flip', window1);
                    state=1;
                end
                
                if score_>0
                    choiceFamiliarity(trial_)=score_;
                    file=strcat('Score_',string(score_),'.JPG')
                    img = imread(fullfile(imageFolder_score,file));
                    img = imresize( img , 0.7);
                    imageSize = size(img);
                    shift_left=(W-imageSize(2))/2;
                    shift_bottom=((3/2)*H-imageSize(1))/2;
                    posimage = [shift_left shift_bottom shift_left+imageSize(2) shift_bottom+imageSize(1)];
                    imagescoreDisplay=Screen('MakeTexture', window1, img);
                    
                    bothDisplay=[imageDisplay imagescoreDisplay];
                    pos=[new_dst_rect' posimage'];
                    
                    % Draw the new texture immediately to screen:
                    Screen('DrawTextures', window1, bothDisplay, [], pos);
                    ImageTime = Screen('Flip', window1);
                    
                    %ADDED ??
                    time_to_vote=0;
%                     state=1;

                    %MODIFIED!!!!
                    state=121;
                    
                    score_=0;
                    aux=[];

                end
                
                %NEW!!
                
                if trial_==n
                    state=13
                end
%                             
%                 %ADDED
%                 FAMIL_Time2=Screen('Flip', window1,ImageTime+0.5);
                    
            else
               state=121; 
            end
            
            aux=[];
            time_to_vote=0;
            flag_vote_state4=0;
            

            %%%% ADD SOMETHING??
            if state~=121
                trial_=trial_+1
            end
            
            % Close movie:
%             Screen('CloseMovie', movie);
            
        case 121
            %ADDED
            FAMIL_Time1=Screen('Flip', window1);
            
            % Make time until total 6s prior to next state:
            disp('Estado 121')
            tempo_121=GetSecs-TriggerStart
            aux=[];
            state=1;
            
            if trial_==n
                state=13
            end
            trial_=trial_+1
            
            % Close movie:
%             Screen('CloseMovie', movie);
            
    end
    end
end

end_exp = GetSecs;
fprintf('Tempo total: %f seconds\n', end_exp-start_exp) % Total time of the experiment

% Save results in excel file
name_file = [results_path '/resultfile_' num2str(subID) '.xlsx'];

movienames_trials
M=[BlankTime_', FixTime', image1Time', SelectValenceTime', SelectArousalTime', SelectFamiliarityTime', ...
    rtValence', rtArousal', rtFamiliarity', choiceValence', choiceArousal', choiceFamiliarity', Trigger']
T = [array2table(M), cell2table(image_name_trial')]
T.Properties.VariableNames = {'BlankTime_','FixTime','image1Time','SelectValenceTime','SelectArousalTime',...
    'SelectFamiliarityTime','rtValence','rtArousal','rtFamiliarity','choiceValence','choiceArousal','choiceFamiliarity','Trigger','image_name_trial'}
writetable(T,name_file)
sca;

% end