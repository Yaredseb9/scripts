@echo off
:menu
cls
echo Select download option:
echo 1) Audio (MP3 first, fallback to M4A)
echo 2) Video (MP4)
echo 3) Quit
set /p option=Enter your choice (1-3): 

:: Validate the user input
if "%option%"=="3" (
    echo Exiting...
    exit /b
)
if "%option%" NEQ "1" if "%option%" NEQ "2" (
    echo Invalid selection. Please enter 1, 2, or 3.
    pause
    goto menu
)

:: Ask for quality selection
echo Select Quality:
echo 1) Best Quality
echo 2) Standard Quality
set /p quality=Enter 1 for Best Quality or 2 for Standard Quality: 

:: Validate quality selection
if "%quality%" NEQ "1" if "%quality%" NEQ "2" (
    echo Invalid selection. Please enter 1 or 2.
    pause
    goto menu
)

:: Accept URL as a parameter
set /p url=Enter the URL of the playlist or video: 

:: Define the common output directory
set output_dir=D:\yt-downloads

:: Set audio quality flag
if "%quality%"=="1" (
    set aq=0
) else (
    set aq=5
)

:: Download audio or video based on user selection
if "%option%"=="1" (
    :: Download audio (MP3 first, fallback to M4A), user-selected quality
    yt-dlp -f "bestaudio[ext=mp3]/bestaudio[ext=m4a]" --extract-audio --audio-quality %aq% --ffmpeg-location "C:\ffmpeg\bin" --output "%output_dir%\%%(playlist_title)s\audio\%%(title)s.%%(ext)s" --continue --no-post-overwrites %url%
) else (
    :: Download video (best video + best audio)
    yt-dlp -f "bv*+ba" --merge-output-format mp4 --output "%output_dir%\%%(playlist_title)s\video\%%(title)s.%%(ext)s" --continue --no-post-overwrites %url%
)

echo Download complete!
pause
goto menu
