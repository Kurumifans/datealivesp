import requests
import time
from xml.dom.minidom import parseString
import os, os.path
import errno
import re

# Taken from https://stackoverflow.com/a/23794010/8326486
# Taken from https://stackoverflow.com/a/600612/119527
def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else: raise

def safe_open_w(path, per):
    ''' Open "path" for writing, creating any parent directories as needed.
    '''
    mkdir_p(os.path.dirname(path))
    return open(path, per)

def check_updates(server):
	url = {
		"dal": "http://cdn.datealive.com/dal/",
		"heitao": "http://c.dal.heitao2014.com/dal/"
	}
	checks = {
		"dal_test": "http://cdn.datealive.com/dal/test/check.xml",
		"dal_experience": "http://cdn.datealive.com/dal/release_experience/check.xml"
	}
	servers = {
		"dal_test": "DAL_TEST/MainSorceCode/",
		"dal_experience": "DAL_EXPERIENCE/MainSorceCode/"
	}
	zipsource = {
		"dal_test": "http://cdn.datealive.com/dal/test/zipsource/",
		"dal_experience": "http://cdn.datealive.com/dal/release_experience/zipsource/"
	}
	# Using check.xml
	# r = requests.get(checks[server] + "?" + str(time.time())) # Prevent caching
	# xml = parseString(r.text)
	# new_ver = xml.getElementsByTagName('version')[0].attributes['current'].value # Newest version

	# Using zipsource folder
	r = requests.get(zipsource[server] + "?" + str(time.time())) # Prevent caching
	regex = re.findall(r"<a\shref=\"([\w\W]*?)\"[\w\W]*?<\/a>\s*([\w\d\-]*)\s([\d:]*)", r.text)
	new_ver = regex[-1][0].replace("/", "") # Newest version
	#return new_ver

	with open(server + "/.nomedia/nomedia.txt","r") as file:
		old_ver = file.read().split('\n')[0] # Last version, remove new line character
	if old_ver == new_ver:
		return False
	edition_url = url["dal"] + servers[server] + "edition/" + new_ver + "/" + old_ver + "-" + new_ver + ".xml"

	r = requests.get(edition_url) # Get update's file list
	with open(server + "/edition.xml", "w", encoding="utf-8") as f:
	    f.write(r.text)
	xml = parseString(r.text)
	files = xml.getElementsByTagName('f')
	
	for file in files:
		file_name = file.attributes['p'].value
		print("Processing " + file_name)
		with safe_open_w(server + "/" + file_name, "wb") as f:
			try:
				req = requests.get(url["dal"] + servers[server] + "source/" + file_name + "?" + str(time.time()))
			except:
				try:
					req = requests.get(url["heitao"] + servers[server] + "source/" + file_name + "?" + str(time.time()))
				except:
					print("Failed to download " + file_name)
					continue
			f.write(req.content)
	return True
#print(check_updates("dal_test"))