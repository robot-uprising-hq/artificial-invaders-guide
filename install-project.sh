#!/bin/bash

trap "exit 1" TERM
export TOP_PID=$$

# Ask user for yes/no with question. q-character exits the script.
# First parameter $1 is the name of repo to setup
function ask_user() {
    echo >&2
    echo >&2
    read -p "Do you want to setup $1 [y/N]?   [q to exit]" response
    if [[ "$response" =~ ^([qQ])$ ]]
    then
        echo "==== Exiting ====" >&2
        kill -s TERM $TOP_PID
    fi
    echo $response
}


# Clone a github repo. First try with SSH if you have the sshkey setup
# in github. Else clone via HTTPS.
# First parameter $1 is the name to print to user
# Second parameter $2 is the repo's path without the protocol prefix
function clone_git_repo() {
    {
        echo "==== Cloning $1 via ssh ===="
        git clone git@github.com:$2
        echo "==== $1 cloned ===="
    } || {
        echo "==== Cloning $1 via https ===="
        git clone https://github.com/$2
        echo "==== $1 cloned ===="
    }
}


# Install Python requirements from requirements.txt with pip
# First parameter $1 is the folder to cd into.
function make_pip_install() {
    echo
    echo "==== Creating Pyhton virtual environment and installing python requirements... ===="
    echo
    cd $1
    python3 -m venv venv
    source venv/bin/activate
    # install pyhton requirements
    pip3 install wheel setuptools
    pip3 install -r requirements.txt
    deactivate
    cd ..
}


# ===
# === TELL ABOUT DEPENDENCIES ===
# ===
echo
echo "Make sure you have installed all requirements:"
echo "- git           // used to pull the repositories (install with 'sudo apt install git)"
echo "- python3       // ml-agents requires Python (3.6.1 or higher)"
echo "- python3-venv  // used to contain python packages (install with 'sudo apt install python3-venv')"
echo "- pip3          // used to install python requirements (install with 'sudo apt install python3-pip')"
echo


mkdir robot-uprising
cd robot-uprising


# ===
# === DOWNLOAD AND INSTALL UNITY SIMULATOR ===
# ===
response=$(ask_user "Unity Simulator")
if [[ $response =~ ^([yY])$ ]]
then
    clone_git_repo "Unity simulator" "robot-uprising-hq/artificial-invaders-ai-unity-simulator.git"
    make_pip_install "artificial-invaders-ai-unity-simulator"
fi

# ===
# === DOWNLOAD UNITY BRAIN SERVER ===
# ===
response=$(ask_user "Unity Brain Server")
if [[ $response =~ ^([yY])$ ]]
then
    clone_git_repo "Unity Brain Server" "robot-uprising-hq/artificial-invaders-ai-unity-brain-server.git"
fi

# ===
# === DOWNLOAD ROBOT BACKEND ===
# ===
response=$(ask_user "Robot Backend")
if [[ $response =~ ^([yY])$ ]]
then
    clone_git_repo "Robot Backend" "robot-uprising-hq/artificial-invaders-ai-robot-backend.git"
    make_pip_install "artificial-invaders-ai-robot-backend"
fi

# ===
# === DOWNLOAD ROBOT FRONTEND ===
# ===
response=$(ask_user "Robot Frontend")
if [[ $response =~ ^([yY])$ ]]
then
    clone_git_repo "Robot Frontend" "robot-uprising-hq/artificial-invaders-ai-robot-frontend.git"
fi

# ===
# === DOWNLOAD VIDEO STREAMER ===
# ===
response=$(ask_user "Video Streamer")
if [[ $response =~ ^([yY])$ ]]
then
    clone_git_repo "Video Streamer" "robot-uprising-hq/artificial-invaders-ai-video-streamer.git"
    make_pip_install "artificial-invaders-ai-video-streamer"
fi

# ===
# === DOWNLOAD INVADERS GUIDE ===
# ===
response=$(ask_user "Invaders Guide")
if [[ $response =~ ^([yY])$ ]]
then
    clone_git_repo "Invaders Guide" "robot-uprising-hq/artificial-invaders-guide.git"
fi

echo
echo "==== Project installed ===="
echo