from dalpy import dalsp_decrypt, generate
from xml.dom.minidom import parse
import sys

class Options:
  def __init__(self, filepath):
    self.input_path = filepath
    self.output_path = "/".join(filepath.split('/')[:-1])
    self.file_mode = True
    self.verbose = False
    self.keepPVR = False
    self.overwrite = True

def decrypt_from_xml(server):
	xml = parse(server + "/edition.xml")
	files = xml.getElementsByTagName('f')
	for file in files:
		file_name = server + "/" + file.attributes['p'].value
		print("Decrypting " + file_name)
		options = Options(file_name)
		decrypt = dalsp_decrypt.DateALive_decryption(options)
		decrypt.crypt_single_file()

server = sys.argv[1]

decrypt_from_xml(server)
version = generate.generate_json(server)

with open(server + "/" + "version.txt", "w") as f:
	f.write(version)
