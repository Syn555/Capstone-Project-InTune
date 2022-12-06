# InTune Overview
InTune is a real time music note detection mobile/web application that provides users with an efficient and effective way to practice and compose music. The InTune application utilizes the internal microphone of the device it is run on to record live audio and then display each note in real time within the application. InTune can be used to tune instruments or match pitch by informing users if the note being played into the microphone is flat or sharp. InTune also allows users to upload sheet music so the application can compare it with the live input audio and provide users a visual representation of where within a song they are out of tune. This system is also a way for users to play or sing original pieces that are transcribed into sheet music in real time with the capability to edit and save. Users can connect with other users from separate devices to compose pieces together with the virtual band tool. InTune is a great way for users to get into the world of music. 

# Account
Create a free account with InTune by going to the Login/SignUp page. Users email and password is securely stored through Firebase authentication.

# Tuning
Users can access the Tuning feature whether they are logged in or not
How to use:
1. Select desired note to tune to.
2. Press 'Start' button
3. Tune note by adjusting pitch according to prompts within the application
4. 'TUNED!!!' InTune will tell you when you're note is tuned correctly
5. Select another note to tune, and press start...

# LINK TO PRE-RELEASE
https://github.com/Capstone-Projects-2022-Fall/capstone-project-intune/releases/tag/v3.0

# Testing document is called "InTune Acceptance QA Testing doc.xlsx"

# Intonation Practice 
Users must be logged in to access

# Composition 
Users must be logged in to access

# Virtual Band
Users must be logged in to access

#Needed for using the call button on Live Band
1. Need to make an agora.io account
2. Create a project (doesn't matter what name)
3. Go to the project configuration (config)
4. Generate a Temp token for audio/video call 
5. Copy the APP ID and Token and replace it in the lib/Helpers/setting.dart file.
![image](https://user-images.githubusercontent.com/89527340/206043108-3b089dec-244a-4536-a0e2-1fcbc4b42b5e.png)
6. When agora ask you to create a channel name when creating the token. Go to the file lib/on_change_practice.dart file, go to line 196 and replace "Call" with the your channel name that you made on agora.
![image](https://user-images.githubusercontent.com/89527340/206044243-187eb428-11a5-43bb-ab6c-a3e54e47f01f.png)
7. You are all set to use the call in Live Band.


# Contributors
Amira Annous </br>
Alexsis Davis</br>
Tommy Ngo</br>
Rachel Rubin</br>
Akshay Varghese</br>
Jason Zhang
