#!/bin/bash

# 1. find directories from the list, 1 up, 1 down
# 2. feed output to fzf
# 3. use dir name from fzf as session name
# 3.a. handle empty output from fzf gracefully
# 4. if tmux session with this name doesn't exist, create new one with target dir
# 4.a. handle tmux no such session error gracefully
# 4.b. if creating new session, create two tmux windows as well, nvim and just bash
# 5. tmux switch client to session
# 
#
#
# 
