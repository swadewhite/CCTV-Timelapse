# CCTV-Timelapse
A collection of scripts I made to import 3 remote CCTV cameras, encode it, convert it to a time lapse, and upload it to YouTube using FFmpeg and youtube-upload. These scripts can be customized to work under pretty much any circumstances, such as more (or less) cameras, or a customized time lapse speed. The default purpose of the scripts are:
1) Record 3 remote webcam streams from an m3u8 file in the background at all times.
2) Save it in the .mkv format in hour segments to a SMB shared hard drive.
3) Create a date-stamped folder 10 minutes after midnight.
4) Move the footage from the previous day into that new folder.
5) Speed up all clips in the folder by 50x.
6) Concatenate all clips into one .mp4 file.
7) Upload the 3 finished .mp4 files to YouTube.
