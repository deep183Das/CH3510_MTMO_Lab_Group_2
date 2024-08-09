from moviepy.editor import VideoFileClip
import moviepy.video.fx.all as vfx
import os
import numpy as np
import pandas as pd 

def with_moviepy(filename):
    from moviepy.editor import VideoFileClip
    clip = VideoFileClip(filename)
    duration       = clip.duration
    fps            = clip.fps
    width, height  = clip.size
    return duration, fps, (width, height)

def change_filename(file):
    out_str = ""
    if file[0] == '1':
        out_str = out_str + "GL_0"
    if file[0] == '2':
        out_str = out_str + "GL_50"
    if file[0] == '3':
        out_str = out_str + "GL_75"
    if file[0] == '4':
        out_str = out_str + "GL_100"
    out_str = out_str + "_"
    if file[2] == '1':
        out_str = out_str + "brown"
    if file[2] == '2':
        out_str = out_str + "clear"
    if file[2] == '3':
        out_str = out_str + "white"
    if file[2] == '4':
        out_str = out_str + "green"
    if file[2] == '5':
        out_str = out_str + "grey"
    if file[2] == '6':
        out_str = out_str + "irregular"
    return out_str

time_data = np.zeros((6, 4))
# COLUMNS -> GL_0, GL_50, GL_75, GL_100 -> 1, 2, 3, 4
# ROWS -> brown, clear, white, green, grey, irregular -> 1, 2, 3, 4, 5, 6

time_ratio = 4

input_dir = "/Users/Bhakna/MyDrive/5th_semester/MTMO_lab_reports/trimmed_records/" # folder with trimmed .mp4 files
# format of filename in input_dir -> [column_no]_[row_no].mp4 -> example : 3_6.mp4

output_dir = "/Users/Bhakna/MyDrive/5th_semester/MTMO_lab_reports/actual_records/" # folder with actual .mp4 files

files = os.listdir(input_dir)
for file in files:
    in_loc = input_dir + str(file)
    out_str = str(change_filename(file))
    out_loc = output_dir + out_str + ".mp4"

    # Import video clip
    clip = VideoFileClip(in_loc)

    # Modify the FPS
    clip = clip.set_fps(clip.fps * time_ratio)

    #Apply speed up
    final = clip.fx(vfx.speedx, time_ratio)

    # Save video clip
    final.write_videofile(out_loc)

    vid_time, vid_fps, vid_size = with_moviepy(in_loc)
    print("---------------------------------------------------------")
    print("Video: {}".format(out_str))
    print("trimmed fps: {}".format(vid_fps))
    print("actual fps: {}".format(final.fps))
    print("trimmed duration (seconds): {}".format(vid_time))
    print("actual duration (seconds): {}".format(vid_time/time_ratio))
    print("---------------------------------------------------------")
    
    time_data[int(file[2])-1, int(file[0])-1] = vid_time/time_ratio
    
print("---------------------------------------------------------")
print("Final Data: seconds")
print(time_data)
print("---------------------------------------------------------")
print("---------------------------------------------------------")

# convert array into dataframe 
DF_time = pd.DataFrame(time_data) 
  
# save the dataframe as a csv file 
DF_time.to_csv("time_data.csv")

# convert time into speed
speed_data = time_data
speed_data[:, 0] = 0.766 / speed_data[:, 0] # 0.766 m is distance in GL_0
speed_data[:, 1] = 0.685 / speed_data[:, 1] # 0.685 m is distance in GL_50
speed_data[:, 2] = 0.76 / speed_data[:, 2] # 0.760 m is distance in GL_75
speed_data[:, 3] = 0.727 / speed_data[:, 3] # 0.727 m is distance in GL_100

# convert array into dataframe 
DF_speed = pd.DataFrame(speed_data) 
  
# save the dataframe as a csv file 
DF_speed.to_csv("speed_data.csv")

print("Final Data: m/s")
print(speed_data)
print("---------------------------------------------------------")
print("---------------------------------------------------------")