#!/bin/bash

function vscode_server_config () {
   printf 'bind-addr: 0.0.0.0:8080\nauth: none\npassword: none\ncert: false' > config.yaml 
}

function run_vscode_server () {
    user=$(whoami)
    mkdir -p "/home/$user/.config/code-server"
    pushd "/home/$user/.config/code-server" > /dev/null
    [ -f config.yaml ] || vscode_server_config
    popd > /dev/null
    
    code-server
}

run_vscode_server
