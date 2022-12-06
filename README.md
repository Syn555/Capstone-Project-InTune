# InTune Overview
InTune is a real time music note detection mobile/web application that provides users with an efficient and effective way to practice and compose music. The InTune application utilizes the internal microphone of the device it is run on to record live audio and then display each note in real time within the application. InTune can be used to tune instruments or match pitch by informing users if the note being played into the microphone is flat or sharp. InTune also allows users to upload sheet music so the application can compare it with the live input audio and provide users a visual representation of where within a song they are out of tune. This system is also a way for users to play or sing original pieces that are transcribed into sheet music in real time with the capability to edit and save. Users can connect with other users from separate devices to compose pieces together with the virtual band tool. InTune is a great way for users to get into the world of music. 

# Account
Create a free account with InTune by going to the Login/SignUp page. Users email and password is securely stored through Firebase authentication.

# LINK TO PRE-RELEASE
https://github.com/Capstone-Projects-2022-Fall/capstone-project-intune/releases/tag/v3.0

# Testing document is called "InTune Acceptance QA Testing doc.xlsx"

# Profile
- "Update Account" : User can update their previous email to a new email. User can also change their password.
- "Upload Sheets & Created Sheets" : Does nothing. This has yet to be finished implemented. If you wish to upload files and see the files you have uploaded go to "Practice/Intonation Practice".
-  "Log Out" : Will log user out of their account.
-  "Delete Account" : Will delete the user account.

# Tuning
Users can access the Tuning feature whether they are logged in or not
How to use:
1. Select desired note to tune to.
2. Press 'Start' button
3. Tune note by adjusting pitch according to prompts within the application
4. 'TUNED!!!' InTune will tell you when you're note is tuned correctly
5. Press Stop button inorder to select another note to tune, and press start...
Note: You can click on the piano to select the notes, also it'll play the piano notes when picked :)).

# Intonation Practice 
Users must be logged in to access
1) "Browse" button : You can browse all your saved files that you have uploaded.
2) "Upload" button : You can upload your xml music sheet files into our database.
-"Start" & "Stop" button : Does nothing. This has yet to be finished implemented.

# Composition 
Users must be logged in to access
1) "Start" button : Will start recording the notes played.
2) "Stop" button : Will take you to a free 3rd party online music sheet creator. This is where you can see all the notes you played and then you can proceed to edit your music to your desire. 

# Virtual Band
Users must be logged in to access
1) "Create" button : Create a recording room ID
2) "Join" button : Join the created room session by entering the room ID and clicking join.
  Note: Only the people who did not create the room ID should enter in the room ID to join it. The person who created the room ID automatically joined the room.
3) "Start" : Start the recording.
  Note: Only one person needs to hit the start button, it'll automatically start recording for all users in the room.
4) "Stop" : Stops the recording session. (Only one person needs to hit the stop button in order to stop all recordings)
5) "Merge" : Merge all the audio recording and it'll then be downloaded into the users download files int their device. (The mixed audio will be called "mixed_....",       individual audios will have their own names.
-"Call" button : Join a video call session.
  Steps needed for using the call button on Live Band
  1. Need to make an agora.io account
  2. Create a project (doesn't matter what name)
  3. Go to the project configuration (config)
  4. Generate a Temp token for audio/video call 
  5. Copy the APP ID and Token and replace it in the lib/Helpers/setting.dart file.
![image](https://user-images.githubusercontent.com/89527340/206043108-3b089dec-244a-4536-a0e2-1fcbc4b42b5e.png)
  6. When agora ask you to create a channel name when creating the token. Go to the file lib/on_change_practice.dart file, go to line 196 and replace "Call" with the        your channel name that you made on agora.
![image](https://user-images.githubusercontent.com/89527340/206044243-187eb428-11a5-43bb-ab6c-a3e54e47f01f.png)
  7. You are all set to use the call in Live Band.


# Contributors
Amira Annous </br>
Alexsis Davis</br>
Tommy Ngo</br>
Rachel Rubin</br>
Akshay Varghese</br>
Jason Zhang
