from dalpy import generate
import sys

server = sys.argv[1]
boturl = sys.argv[2]
with open(server + "/" + "version.txt", "r") as f:
	version = f.read().split('\n')[0]

generate.discord(boturl, server, "https://dalfc.github.io/dalsp/viewer/" , version)