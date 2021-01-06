import requests
import time
from xml.dom.minidom import parseString
import os, os.path
import errno

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
	checks = {
		"dal_test": "http://cdn.datealive.com/dal/test/check.xml",
		"dal_experience": "http://cdn.datealive.com/dal/release_experience/check.xml"
	}
	servers = {
		"dal_test": "http://cdn.datealive.com/dal/DAL_TEST/MainSorceCode/",
		"dal_experience": "http://cdn.datealive.com/dal/DAL_EXPERIENCE/MainSorceCode/"
	}

	r = requests.get(checks[server] + "?" + str(time.time())) # Prevent caching
	xml = parseString(r.text)
	new_ver = xml.getElementsByTagName('version')[0].attributes['current'].value # Newest version
	with open(server + "/.nomedia/nomedia.txt","r") as file:
		old_ver = file.read().split('\n')[0] # Last version, remove new line character
	if old_ver == new_ver:
		return False
	edition_url = servers[server] + "edition/" + new_ver + "/" + old_ver + "-" + new_ver + ".xml"

	r = requests.get(edition_url) # Get update's file list
	with open(server + "/edition.xml", "w", encoding="utf-8") as f:
	    f.write(r.text)
	xml = parseString(r.text)
	files = xml.getElementsByTagName('f')
	
	for file in files:
		file_name = file.attributes['p'].value
		print("Processing " + file_name)
		with safe_open_w(server + "/" +file_name, "wb") as f:
			f.write(requests.get(servers[server] + "source/" + file_name + "?" + str(time.time())).content)
	return True

# check_updates("DAL_EXPERIENCE")