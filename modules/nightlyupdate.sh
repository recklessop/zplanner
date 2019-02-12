#!/bin/bash

echo "Updating zPlanner from github"
(cd /home/zplanner/zplanner/ && git reset --hard HEAD && git pull http://www.github.com/recklessop/zplanner/)
echo "Running Update Helper Script"
(/bin/bash /home/zplanner/zplanner/updates.sh)

