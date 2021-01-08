import subprocess, sys, os

server = sys.argv[1]

try:
	with open(server + "/" + "video.txt", "r") as f:
		files = f.read().split('\n')
except:
	sys.exit(1) # No video files in this update
for file in files:
	os.makedirs(os.path.dirname("dal_video/" + server + "/" + file), exist_ok=True)
	subprocess.call(['ffmpeg', '-y', '-i', server + "/" + file, "-c:v", "libx264", "-crf", "23", "-vf", "format=yuv420p", "-c:a", "copy", "dal_video/" + server + "/" + file])
	# ffmpeg -y -i input.mp4 -c:v libx264 -crf 28 -vf format=yuv420p -c:a copy output.mp4