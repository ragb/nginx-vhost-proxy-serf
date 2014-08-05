#!/usr/bin/env python

import codecs
import itertools
import json
import os
import subprocess
import sys
from jinja2 import Environment, FileSystemLoader

event = os.getenv('SERF_EVENT')
if not event or event not in ('member-join', 'member-leave', 'member-failed'):
	print "No event sent."
	sys.exit(0)

output = subprocess.check_output(["serf", "members", "-format", "json", "-tag", "role=xweb"])

info =  json.loads(output)

hosts = []
for member in info['members']:
	ip, port = member['addr'].split(":")
	if "http_vhost" in member['tags']:
		vhost = member['tags']['http_vhost']
		port = member['tags'].get('http:port', 80)
		hosts.append((vhost.split("|"), ip, port))
print "%s\t%s\t%d" % (vhost, ip, port)

if not hosts:
	sys.exit(0)

# Sort by virtual host.
hosts = sorted(hosts, key=lambda k : k[0])

nodes = []
for vhosts, members in itertools.groupby(hosts, lambda k : k[0]):
	node = {'vhosts' : vhosts, 'members' : []}
	for member in members:
		node['members'].append({'ip' : member[1], 'port' : member[2]})
	nodes.append(node)


env = Environment(loader=FileSystemLoader('/opt/templates/'))
template = env.get_template('site-default.jinja2')
with codecs.open('/etc/nginx/sites-enabled/default', 'w', 'utf-8') as f:
	output = template.render(nodes=nodes)
	f.write(output)


# Reload nginx
subprocess.check_call(["nginx", "-s", "reload"])
