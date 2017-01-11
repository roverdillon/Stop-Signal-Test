%% Stop Signal Test
% Written by Dillon Japko
% dillonjapko@gmail.com
% 
% Instructions:
% When you click Run, a prompt will pop up asking for a Participant ID.
% After typing in the ID and clicking OK, the Test starts immediately.
% The test consists of 200 trials.
% There are two types of trials: Stop Trial and Go Trial.
% 
% Here is how a Go Trial works:
% First, you see a plus sign for 250 ms. Use this to direct your view to the center.
% Then, you will see an arrow pointed either Left or Right.
% The arrow will stay on the screen for 1250 ms.
% While the arrow is on the screen, press 'v' for Left or 'b' for Right, 
% depending on the arrows direction.
% If you don't press the button within 1250ms, you fail the trial. The test moves on to the next trial.
% 
% 
% Here is how a Stop Trial works:
% Pretty much the same to start out.
% First, you see a plus sign. Then, an arrow.
% After the arrow shows up, you will hear a beep. 
% The time between the image appearing and the beep
% playing varies (100,200,300,400,500 ms).
% If you hear a beep, you are in a Stop Trial.
% This means that you should NOT press any key. 
% If you press 'v' or 'b' in a Stop Trial, you fail the trial.
% If you don't press a button within 1250ms, you win the trial.
% 
% Results will be outputed to 'results.xlsx'
% This can be changed, but be sure to change the file name in the xlswrite() function
% at the end of this script.
% Results for each test get their own sheet in the xlsx file.
% The name of the sheet is the ParticipantID you input in the beginning of the test.
% So, if you want to save multiple tests for the same UserID, 
% save them as "12345_Test2" or something along those lines.
% If you just enter the same ParticipantID for two tests, the results of the first will be overwritten.



function stopsignaltask()
close all
clc

%% read images
wait = imread('wait.jpg');
left = imread('left.jpg');
right = imread('right.jpg');
blank = imread('blank.jpg');

%% Sound Parameters
fs = 8000; %8000 Hz sampling rate
T = 0.075; %75 ms duration
t = 0:(1/fs):T;
f = 750; %750 Hz - Sound Frequency
a = 0.5; %Half of max volume
wave = a*sin(2*pi*f*t);
%%
KeyStatusLeft = false; % 'v' is not pressed by default 
KeyStatusRight = false; % 'b' is not pressed by default
%% Create Randomized Matrix with Trial Descriptors
%trial descriptors: trial(x,:) = [arrow direction, stop vs go, delay interval]
%arrow direction = 0 (left) or 1 (right)
%stop vs go = 0 (stop) or 1 (go)
%delay = 0(for go trials b/c no tone), 1(100ms), 2(200ms), 3(300ms), 4(400ms), 5(500ms)

trial = zeros(200,3); %preallocate size of matrix for speed
for j = 1:200
    if j < 11 % 10 Stop Trials w/ 100ms Delay
        trial(j,3) = 1;
        trial(j,2) = 0;
    elseif 10 < j && j < 21 % 10 Stop Trials w/ 200ms Delay
        trial(j,3) = 2;
        trial(j,2) = 0;
    elseif 20 < j && j < 31 % 10 Stop Trials w/ 300ms Delay
        trial(j,3) = 3;
        trial(j,2) = 0;
    elseif 30 < j && j < 41 % 10 Stop Trials w/ 400ms Delay
        trial(j,3) = 4;
        trial(j,2) = 0;
    elseif 40 < j && j < 51 % 10 Stop Trials w/ 500ms Delay
        trial(j,3) = 5;
        trial(j,2) = 0;
    else % 150 Go Trials
        trial(j,3) = 0;
        trial(j,2) = 1;
    end
    if mod(j,2) == 0 % Half of each group of all trials are left arrow
        trial(j,1) = 0;
    else % Half are right arrow
        trial(j,1) = 1;
    end
end
trial = trial(randperm(size(trial,1)),:); % Randomize the order of the rows in the matrix, randomizes order of trials
results = zeros(200,5);
%% Ask for userID
userID = inputdlg('Participant ID');
userID = userID{1,1};
%% Create the one figure used in this program
fig = figure('KeyPressFcn',@MyKeyDown,'KeyReleaseFcn',@MyKeyUp,'DockControls','off','NumberTitle','Off','Name','Stop-Signal Test','ToolBar','none');

%% Begin the test!

for k = 1:200 % 200 iterations = 200 trials
    imshow(wait); % Show the plus sign for 250ms
    pause(0.25);
    %% Go Trials
    if trial(k,2) == 1 % If current trial is a Go Trial
        delay = 0;
        %% Left Go Trial
        if trial(k,1) == 0
            imshow(left) % Show Left Arrow
            tic % Start Timer
            score = 0; % Default Score is 0 - Remains unchanged if no button is pressed, so they fail
            running = 1; % Tells program to search for keystrokes
            while toc < 1.25 % Until timer reaches 1250ms:
                if running % Only check for keystrokes if no input detected yet
                    if KeyStatusLeft % Pressed 'v'
                        running = 0; % Stop checking for keystrokes
                        score = 1; % Correct! Score for this trial is '1'
                        time = toc; % Reaction time is recorded
                    end
                    if KeyStatusRight % Pressed 'b'
                        running = 0; % Stop checking for keystrokes
                        score = 0; % Wrong answer, the arrow was left
                        time = toc; % Reaction time is still recorded
                    end
                end
                pause(0.05); % THESE PAUSES ARE NECESSARY FOR DETECTING KEYSTROKES. Took me wayyyyy too long to figure that out :/
            end
        %% Right Go Trial
        % Pretty much the same as above but 'v' is correct now
        else
            imshow(right) 
            tic 
            time = 0;
            score = 0;
            running = 1;
            while toc < 1.25
                if running
                    if KeyStatusLeft
                        time = toc;
                        running = 0;
                        score = 0;
                    end
                    if KeyStatusRight
                        time = toc;
                        running = 0;
                        score = 1;
                    end
                end
                pause(0.05);
            end
        end
%% Stop Trials
    else
        delay = trial(k,3) / 10; % Delay for this trial in ms
        if trial(k,1) == 0 % Show left or right arrow
            imshow(left)
        else
            imshow(right)
        end
            tic % Start timer
            time = 0;
            score = 1; % Default score is 1, b/c if they don't type anything they pass the trial
            running = 1; % Search for input
                while toc < delay % First chunk of waiting for user input
                    if running
                        if KeyStatusLeft
                            time = toc;
                            score = 0; % Any input is a fail
                            running = 0;
                        end
                        if KeyStatusRight
                            time = toc;
                            score = 0; % Any input is a fail
                            running = 0;
                        end
                    end
                    pause(0.05); % THESE PAUSES ARE NECESSARY FOR DETECTING KEYSTROKES.
                end
                sound(wave,fs) % Play the tone
                while toc < 1.25 && toc > delay % Go back to searching for input
                    if running
                        if KeyStatusLeft
                            time = toc;
                            score = 0; % Any input is a fail
                            running = 0;
                        end
                        if KeyStatusRight
                            time = toc;
                            score = 0; % Any input is a fail
                            running = 0;
                        end
                    end
                    pause(0.05); % THESE PAUSES ARE NECESSARY FOR DETECTING KEYSTROKES.
                end
    end
    imshow(blank) % Show plain white image for .25ms
    %% Store results into matrix
    results(k,1) = score;
    results(k,2) = time;
    results(k,3) = trial(k,1);
    results(k,4) = trial(k,2);
    results(k,5) = delay;
    pause(.25)
end

%% Keypress Functon
    function MyKeyDown(hObject, event, handles)
            key = get(hObject,'CurrentKey');
            KeyStatusLeft = (strcmp(key, 'v') | KeyStatusLeft); % Set Status of 'v' to active if 'v' is pressed
            KeyStatusRight = (strcmp(key, 'b') | KeyStatusRight); % Same for 'b'
    end
%% Key Release Function
    function MyKeyUp(hObject, event, handles)
            key = get(hObject,'CurrentKey');
            KeyStatusLeft = (~strcmp(key, 'v') & KeyStatusLeft); % Set Status of 'v' to inactive
            KeyStatusRight = (~strcmp(key, 'b') & KeyStatusRight); % Same for 'b'
    end
results = num2cell(results);
xlsresults = vertcat({'Score','Reaction Time(s)','Arrow Direction - 0 is Left, 1 is Right','Trial Type - 0 is Stop, 1 is Go','Delay (s) - 0 is Stop Trial'},results);
xlswrite('results.xlsx',xlsresults,userID)
end