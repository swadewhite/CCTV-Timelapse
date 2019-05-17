#!/bin/bash

#Prerequisites:
# -FFmpeg
# -youtube-upload (optional)

# Set this script as a crontab to run a little after midnight, just so ffmpeg has time to process the previous video.

# Let's set the variables now

L_PATH=/home/swade/CCTV_Footage/Cedar_Point #Path to where the local files will be stored.
S_PATH=/mnt/Backups/CCTV_Footage/Cedar_Point #Path to the NAS where the files will be moved. (If not using a NAS, just set this path to the same as L_PATH)
SPEED=.0025 #Sets the speed the video will be sped up by (.0025=1000x)
YT_CRED=/home/swade/client_secrets.json #Sets the path for the youtube-upload credentials.

# Change directory to camera 1 footage.
cd "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')"

# Use FFmpeg to speed up videos by 1000 times.
for FILE in *.mkv; do
  VIDEO_NAME=${FILE%.*}
  ffmpeg -i $FILE -vf "setpts=$SPEED*PTS" -r 60 -an "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to camera 2 footage.
cd "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')"

# Use FFmpeg to speed up videos by 1000 times.
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  ffmpeg -i $FILE -vf "setpts=$SPEED*PTS" -r 60 -an "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to camera 3 footage.
cd "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')"

# Use FFmpeg to speed up videos by 1000 times.
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  ffmpeg -i $FILE -vf "setpts=$SPEED*PTS" -r 60 -an "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to converted camera 1 footage.
cd "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$(date --date="1 day ago" +'%m-%d-%Y') Camera 1.mp4"

# Change directory to converted camera 2 footage.
cd "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$(date --date="1 day ago" +'%m-%d-%Y') Camera 2.mp4"

# Change directory to converted camera 3 footage.
cd "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$(date --date="1 day ago" +'%m-%d-%Y') Camera 3.mp4"

# Change directory back to home.
cd

# Move finalized .mp4 files to the main folder.
sudo mv "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$(date --date="1 day ago" +'%m-%d-%Y') Camera 1.mp4" "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')"
sudo mv "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$(date --date="1 day ago" +'%m-%d-%Y') Camera 2.mp4" "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')"
sudo mv "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$(date --date="1 day ago" +'%m-%d-%Y') Camera 3.mp4" "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')"

# Delete the sped-up footage.
sudo rm -r "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/"
sudo rm -r "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/"
sudo rm -r "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/"

# Uploads the converted clips to YouTube using youtube-upload. (optional)
sudo youtube-upload --title="$(date --date="1 day ago" +'%m-%d-%Y') Camera 1" --description="A time lapse of Cedar Point's Webcam #1 sped up by 100x." --client-secrets=$YT_CRED "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/$(date --date="1 day ago" +'%m-%d-%Y') Camera 1.mp4"
sudo youtube-upload --title="$(date --date="1 day ago" +'%m-%d-%Y') Camera 2" --description="A time lapse of Cedar Point's Webcam #2 sped up by 100x." --client-secrets=$YT_CRED "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/$(date --date="1 day ago" +'%m-%d-%Y') Camera 2.mp4"
sudo youtube-upload --title="$(date --date="1 day ago" +'%m-%d-%Y') Camera 3" --description="A time lapse of Cedar Point's Webcam #3 sped up by 100x." --client-secrets=$YT_CRED "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/$(date --date="1 day ago" +'%m-%d-%Y') Camera 3.mp4"

# Re-encode the old clips with HEVC to save space. (optional)
cd "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')"
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  sudo ffmpeg -i $FILE -c:v libx265 -crf 30 -y -an "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Archive/$VIDEO_NAME.mp4"
done

cd "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')"
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  sudo ffmpeg -i $FILE -c:v libx265 -crf 30 -y -an "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Archive/$VIDEO_NAME.mp4"
done

cd "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')"
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  sudo ffmpeg -i $FILE -c:v libx265 -crf 30 -y -an "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Archive/$VIDEO_NAME.mp4"
done

# Delete the old raw .mkv files from the camera directory.
cd "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')"
for FILE in *.mkv; do
  FILE_NAME="*"
  sudo rm $FILE_NAME.mkv
done

cd "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv
done

cd "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv

done
cd "$S_PATH/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Archive"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv
done

cd "$S_PATH/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Archive"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv
done

cd "$S_PATH/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Archive"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv
done
