#!/bin/bash

# Set this script as a crontab to run a little after midnight, just so ffmpeg has time to precess the videos.

# Create a new folder with a date stamp.
mkdir "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')"
mkdir "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')"
mkdir "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')"

# Create a new folder for converted files.
mkdir "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"
mkdir "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"
mkdir "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"

# Move videos from the previous day to the new folder.
find "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/Cam1_"*$(date --date="1 day ago" +'%Y-%m-%d')*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')"
find "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/Cam2_"*$(date --date="1 day ago" +'%Y-%m-%d')*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')"
find "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/Cam3_"*$(date --date="1 day ago" +'%Y-%m-%d')*".mkv" -maxdepth 1 -type f -print0 | xargs -0 sudo mv -t "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')"

# Change directory to camera 1 footage.
cd "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')"

# Use Handbrake to speed up videos by 50 times.
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  ffmpeg -i $FILE -vf "setpts=.05*PTS" -r 60 -an "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to camera 2 footage.
cd "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')"

# Use Handbrake to speed up videos by 50 times.
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  ffmpeg -i $FILE -vf "setpts=.05*PTS" -r 60 -an "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to camera 3 footage.
cd "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')"

# Use Handbrake to speed up videos by 50 times.
for FILE in *.mkv; do
  VIDEO_NAME="${FILE%.*}"
  ffmpeg -i $FILE -vf "setpts=.05*PTS" -r 60 -an "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$VIDEO_NAME-faster.mkv"
done

# Change directory to converted camera 1 footage.
cd "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$(date --date="1 day ago" +'%m-%d-%Y') Camera 1.mp4"

# Change directory to converted camera 2 footage.
cd "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$(date --date="1 day ago" +'%m-%d-%Y') Camera 2.mp4"

# Change directory to converted camera 3 footage.
cd "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mkv > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c copy "$(date --date="1 day ago" +'%m-%d-%Y') Camera 3.mp4"

# Uploads the converted clips to YouTube.
sudo youtube-upload --title="$(date --date="1 day ago" +'%m-%d-%Y') Camera 1" --description="A time lapse of Cedar Point's Webcam #1 sped up by 50x." --client-secrets="/home/swade/client_secrets.json" "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam1/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$(date --date="1 day ago" +'%m-%d-%Y') Camera 1.mp4"
sudo youtube-upload --title="$(date --date="1 day ago" +'%m-%d-%Y') Camera 2" --description="A time lapse of Cedar Point's Webcam #2 sped up by 50x." --client-secrets="/home/swade/client_secrets.json" "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam2/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$(date --date="1 day ago" +'%m-%d-%Y') Camera 2.mp4"
sudo youtube-upload --title="$(date --date="1 day ago" +'%m-%d-%Y') Camera 3" --description="A time lapse of Cedar Point's Webcam #3 sped up by 50x." --client-secrets="/home/swade/client_secrets.json" "/mnt/Backups/CCTV_Footage/Cedar_Point/Cam3/$(date --date="1 day ago" +'%Y-%m-%d')/Converted/$(date --date="1 day ago" +'%m-%d-%Y') Camera 3.mp4"
