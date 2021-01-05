from dalpy import update
import sys

server = sys.argv[1]

if update.check_updates(server) == False: # No Update
	sys.exit(1) # Nonzero exit code results in Workflow Failure
else:
	sys.exit(0) # Zero exit code results in Workflow Success