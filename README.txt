%% Stop Signal Test %%
Written by Dillon Japko
dillonjapko@gmail.com

%%% Controls: %%%
%%% Left = 'v' %%%
%%% Right = 'b' %%%


%%Instructions:%%
When you click Run, a prompt will pop up asking for a Participant ID.
After typing in the ID and clicking OK, the Test starts immediately.
The test consists of 200 trials.
There are two types of trials: Stop Trial and Go Trial.

%Here is how a Go Trial works:%
First, you see a plus sign for 250 ms. Use this to direct your view to the center.
Then, you will see an arrow pointed either Left or Right.
The arrow will stay on the screen for 1250 ms.
While the arrow is on the screen, press 'v' for Left or 'b' for Right, 
depending on the arrows direction.
If you don't press the button within 1250ms, you fail the trial. The test moves on to the next trial.

%Here is how a Stop Trial works:%
Pretty much the same to start out.
First, you see a plus sign. Then, an arrow.
After the arrow shows up, you will hear a beep. 
The time between the image appearing and the beep
playing varies (100,200,300,400,500 ms).
If you hear a beep, you are in a Stop Trial.
This means that you should NOT press any key. 
If you press 'v' or 'b' in a Stop Trial, you fail the trial.
If you don't press a button within 1250ms, you win the trial.

%%%%Results will be outputed to 'results.xlsx'%%%%
This can be changed, but be sure to change the file name in the xlswrite() function
at the end of this script.
Results for each test get their own sheet in the xlsx file.
The name of the sheet is the ParticipantID you input in the beginning of the test.
So, if you want to save multiple tests for the same UserID, 
save them as "12345_Test2" or something along those lines.
If you just enter the same ParticipantID for two tests, the results of the first will be overwritten.
