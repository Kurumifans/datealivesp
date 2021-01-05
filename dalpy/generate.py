from xml.dom.minidom import parse
import json
import requests 

def discord(boturl, server, url):
	data = {}
	data["embeds"] = []

	embed = {}
	embed["title"] = "Browse Files"
	embed["description"] = "View updated contents in " + server.upper()
	embed["url"] = url
	embed["color"] = 0x2F3136

	data["embeds"].append(embed)

	result = requests.post(boturl, data=json.dumps(data), headers={"Content-Type": "application/json"})

	try:
	    result.raise_for_status()
	except requests.exceptions.HTTPError as err:
	    print(err)
	else:
	    print("Payload delivered successfully, code {}.".format(result.status_code))

def generate_json(server):
	obj = {
		"name": server.upper(),
		"type": "folder",
		"path": server.upper(),
		"items": []
	}
	xml = parse(server + "/edition.xml")
	version = xml.getElementsByTagName('files')
	version = version[0].attributes['lastVersion'].value + "-" + version[0].attributes['version'].value
	files = xml.getElementsByTagName('f')
	for file in files:
		file_name = file.attributes['p'].value
		if file_name == ".nomedia/nomedia.txt":
			continue
		obj = explodeToNestedArray("/", file_name, obj, file.attributes['m'].value)
	with open(server + "/json/" + version + ".json", "w", encoding="utf-8") as f:
		print("Generating " + server + "/json/" + version + ".json")
		f.write(json.dumps(obj))
	return version

def explodeToNestedArray(delimiter, key, obj, md5):
	keys = key.split(delimiter, 1)
	arr_column = [item.get('name') for item in obj["items"]]
	try:
		k = arr_column.index(keys[0])
		if len(keys) == 2:
			obj["items"][k] = explodeToNestedArray("/", keys[1], obj["items"][k], md5)
	except ValueError:
		new_json = {
			"name": keys[0],
			"path": obj["path"] + "/" + keys[0],
			"type": "file"
		}
		if len(keys) == 2:
			new_json["type"] = 'folder'
			new_json["items"] = []
			new_json = explodeToNestedArray("/", keys[1], new_json, md5)
		elif len(keys) == 1:
			new_json["md5"] = md5
		obj["items"].append(new_json)	
	return obj
