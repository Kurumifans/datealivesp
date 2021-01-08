import subprocess, sys

server = sys.argv[1]

with open(server + "/" + "video.txt", "r") as f:
	files = f.read().split('\n')
for file in files:
	subprocess.call(['ffmpeg', '-y', '-i', server + "/" + file, "-c:v", "libx264", "-crf", "28", "-vf", "format=yuv420p", "-c:a", "copy", "dal_video/" + server + "/" + file])
	# ffmpeg -y -i input.mp4 -c:v libx264 -crf 28 -vf format=yuv420p -c:a copy output.mp4