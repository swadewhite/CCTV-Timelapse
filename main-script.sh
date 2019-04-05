#!/bin/bash

#Prerequisites:
# -FFmpeg
# -youtube-upload (optional)

# Set this script as a crontab to run a little after midnight, just so ffmpeg has time to process the videos.

# Let's set the variables now

L_PATH=/home/swade/CCTV_Footage/Cedar_Point #Path to where the local files will be stored.
S_PATH=/mnt/Backups/CCTV_Footage/Cedar_Point #Path to the NAS where the files will be moved. (If not using a NAS, just set this path to the same as L_PATH)
SPEED=.025 #Sets the speed the video will be sped up by (.025=100x)
YT_CRED= #Sets the path for the youtube-upload credentials.
Y_DATE=(date --date="1 day ago" +'%Y-%m-%d') #Sets yesterday's date
YT_DATE=(date --date="1 day ago" +'%m-%d-%Y') #Sets yesterday's date but in a more human friendly format

# Change directory to camera 1 footage.
cd "$S_PATH/Cam1/$Y_DATE"

# Use FFmpeg to speed up videos by 100 times.
for FILE in *.mkv; do
  VIDEO_NAME=${FILE%.*}
  ffmpeg -i $FILE -vf "setpts=$SPEED*PTS" -r 60 -an "$S_PATH/Cam1/$Y_DATE/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to camera 2 footage.
cd "$S_PATH/Cam2/$Y_DATE"

# Use FFmpeg to speed up videos by 100 times.
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  ffmpeg -i $FILE -vf "setpts=$SPEED*PTS" -r 60 -an "$S_PATH/Cam2/$Y_DATE/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to camera 3 footage.
cd "$S_PATH/Cam3/$Y_DATE"

# Use FFmpeg to speed up videos by 100 times.
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  ffmpeg -i $FILE -vf "setpts=$SPEED*PTS" -r 60 -an "$S_PATH/Cam3/$Y_DATE/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to converted camera 1 footage.
cd "$S_PATH/Cam1/$Y_DATE/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$YT_DATE Camera 1.mp4"

# Change directory to converted camera 2 footage.
cd "$S_PATH/Cam2/$Y_DATE/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$YT_DATE Camera 2.mp4"

# Change directory to converted camera 3 footage.
cd "$S_PATH/Cam3/$Y_DATE/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$YT_DATE Camera 3.mp4"

# Change directory back to home.
cd

# Move finalized .mp4 files to the main folder.
sudo mv "$S_PATH/Cam1/$Y_DATE/Converted/$YT_DATE Camera 1.mp4" "$S_PATH/Cam1/$Y_DATE"
sudo mv "$S_PATH/Cam2/$Y_DATE/Converted/$YT_DATE Camera 2.mp4" "$S_PATH/Cam2/$Y_DATE"
sudo mv "$S_PATH/Cam3/$Y_DATE/Converted/$YT_DATE Camera 3.mp4" "$S_PATH/Cam3/$Y_DATE"

# Delete the sped-up footage.
sudo rm -r "$S_PATH/Cam1/$Y_DATE/Converted/"
sudo rm -r "$S_PATH/Cam2/$Y_DATE/Converted/"
sudo rm -r "$S_PATH/Cam3/$Y_DATE/Converted/"

# Uploads the converted clips to YouTube using youtube-upload. (optional)
sudo youtube-upload --title="$YT_DATE Camera 1" --description="A time lapse of Cedar Point's Webcam #1 sped up by 100x." --client-secrets="/home/swade/client_secrets.json" "$S_PATH/Cam1/$Y_DATE/$YT_DATE Camera 1.mp4"
sudo youtube-upload --title="$YT_DATE Camera 2" --description="A time lapse of Cedar Point's Webcam #2 sped up by 100x." --client-secrets="/home/swade/client_secrets.json" "$S_PATH/Cam2/$Y_DATE/$YT_DATE Camera 2.mp4"
sudo youtube-upload --title="$YT_DATE Camera 3" --description="A time lapse of Cedar Point's Webcam #3 sped up by 100x." --client-secrets="/home/swade/client_secrets.json" "$S_PATH/Cam3/$Y_DATE/$YT_DATE Camera 3.mp4"

# Re-encode the old clips with HEVC to save space. (optional)
cd "$S_PATH/Cam1/$Y_DATE/Archive"
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  sudo ffmpeg -i $FILE -c:v libx265 -crf 30 -y -an "$S_PATH/Cam1/$Y_DATE/Archive/$VIDEO_NAME.mp4"
done

cd "$S_PATH/Cam2/$Y_DATE/Archive"
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  sudo ffmpeg -i $FILE -c:v libx265 -crf 30 -y -an "$S_PATH/Cam2/$Y_DATE/Archive/$VIDEO_NAME.mp4"
done

cd "$S_PATH/Cam3/$Y_DATE/Archive"
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  sudo ffmpeg -i $FILE -c:v libx265 -crf 30 -y -an "$S_PATH/Cam3/$Y_DATE/Archive/$VIDEO_NAME.mp4"
done

# Delete the old raw .mkv files from the camera directory.
cd "$S_PATH/Cam1/$Y_DATE"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv
done

cd "$S_PATH/Cam2/$Y_DATE"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv
done

cd "$S_PATH/Cam3/$Y_DATE"
for FILE in *.mkv; do
  FILE_NAME="${FILE%.*}"
  sudo rm $FILE_NAME.mkv
done
