import mutagen
from mutagen.mp3 import MP3
import  os

# function to convert the information into
# some readable format
def audio_duration(length):
	hours = length // 3600 # calculate in hours
	length %= 3600
	mins = length // 60 # calculate in minutes
	length %= 60
	seconds = length # calculate in seconds

	return hours, mins, seconds # returns the duration


def get_duration(audio_file):
    # Create a WAVE object
    # Specify the directory address of your wavpack file
    # "alarm.wav" is the name of the audiofile
    audio = MP3(audio_file)

    # contains all the metadata about the wavpack file
    audio_info = audio.info
    length = int(audio_info.length)
    hours, mins, seconds = audio_duration(length)
    print ('{:02d}:{:02d}:{:02d}'.format(hours, mins, seconds)+'|'+audio_file.rsplit('.', maxsplit=1)[0])


dirname = '.\\'
 
# giving file extension
ext = ('.mp3')
# print(os.listdir(dirname))
# iterating over all files
for files in os.listdir(dirname):
    # get_duration(files)
    if files.endswith(ext):
        get_duration(files)  # printing file name of desired extension
    else:
        continue
