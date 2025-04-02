@echo off
:: Load saved FFMPEG path if it exists
if exist ffmpeg_path.txt (
    set /p ffmpeg_path=<ffmpeg_path.txt
) else (
    set ffmpeg_path=%~dp0ffmpeg
)

:menu
cls
echo Select an option:
echo 1) Download Audio (MP3 first, fallback to M4A)
echo 2) Download Video (MP4)
echo 3) Set FFMPEG Directory
echo 4) Quit
set /p option=Enter your choice (1-4): 

:: Handle the quit option
if "%option%"=="4" (
    echo Exiting...
    exit /b
)

:: Handle invalid input
if not "%option%"=="1" if not "%option%"=="2" if not "%option%"=="3" (
    echo Invalid selection. Please enter 1, 2, 3, or 4.
    pause
    goto menu
)

:: Separate block for setting FFMPEG path to avoid errors
if "%option%"=="3" goto set_ffmpeg

:: Ask for quality selection
echo Select Quality:
echo 1) Best Quality
echo 2) Standard Quality
set /p quality=Enter 1 for Best Quality or 2 for Standard Quality: 

:: Validate quality selection
if not "%quality%"=="1" if not "%quality%"=="2" (
    echo Invalid selection. Please enter 1 or 2.
    pause
    goto menu
)

:: Accept URL
set /p url=Enter the URL of the playlist or video: 

:: Define output directory
set output_dir=D:\yt-downloads

:: Set quality flags
if "%quality%"=="1" (
    set aq=0
) else (
    set aq=5
)

:: Check if cookies.txt exists
if exist cookies.txt (
    set cookies=--cookies cookies.txt
) else (
    echo Warning: cookies.txt not found. Private videos may not download.
    set cookies=
)

:: Download audio or video
if "%option%"=="1" (
    yt-dlp -f "bestaudio[ext=mp3]/bestaudio[ext=m4a]" --extract-audio --audio-format mp3 --audio-quality %aq% --ffmpeg-location "%ffmpeg_path%" %cookies% --output "%output_dir%\%%(playlist_title)s\audio\%%(title)s.%%(ext)s" --continue --no-post-overwrites %url%
) else (
    yt-dlp -f "bv*+ba" --merge-output-format mp4 --ffmpeg-location "%ffmpeg_path%" %cookies% --output "%output_dir%\%%(playlist_title)s\video\%%(title)s.%%(ext)s" --continue --no-post-overwrites %url%
)

echo Download complete!
pause
goto menu

:set_ffmpeg
:: Fix: Separate label for setting FFMPEG path
set /p ffmpeg_path=Enter full path to FFMPEG (Example: C:\ffmpeg\bin): 
echo %ffmpeg_path% > ffmpeg_path.txt
echo FFMPEG path updated!
pause
goto menu
