#!/bin/bash
exec serf agent -tag role=lb -event-handler="member-join,member-leave,member-failed=/generate-vhosts.py>>/tmp/vhosts.log"