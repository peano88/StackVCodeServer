# StackVCodeServer

StackVCodeServer allows to have a ready-to-go development environment including [Stack][2] and the [Haskell Language Server][1]. It leverages on [code-server][3] to let the environment directly available from your browser. 

## How to use

Retrieve the image from the docker hub
```bash
$ docker pull peano88/stack-code:version0.1
```  
> The default image will use a special created user ` alonzo`. If this is not OK with you and you want to change the user name you can build the image yourself using the included Dockerfile and providing the username as build argument ` user` . 

Once the image downloaded use the ` stack_vcodeserver.sh`  script to start a container. Please be aware that you might need to edit such script if you changed the default username of the image.

```bash
$ ./stack_vcodeserver.sh
```  

Time to open your browser and point to `localhost:8080` : your brand new environment is ready for you to develop. Fire up the terminal (you might need to change it to /bin/bash) and tap:
```bash
$ stack new hello_world
``` 
As expected you will have created a new project named ` hello_world`

![hello-world](img/hello-world)

### Plugins workaround

Unfortunately, code-server can't use the same plugins market of the original visual studio code. And if you really want to unleash the true potential of hls you should use the latest version of the [vscode-haskell][4] plugin, which is not available in the code-server market. As a workaround, you can build the plugin from source and install it directly. You will need ` npm`  so let's start by install it:
```bash
$ sudo apt-get install npm
```
and then install [vsce][5] and plugin [language-haskell][6] which is a required dependency (and again not available):
```bash
$ sudo npm install -g vsce
$ git clone https://github.com/JustusAdam/language-haskell.git
$ cd language-haskell
$ npm ci
$ vsce package
```
This will create a ` .vsix`  file that you can install manually in code-server by selecting ` Extensions: Install from VSIX...`  from the command palette.

Once done that, you can install the [vscode-haskell][4] plugin:
```bash
$ git clone https://github.com/haskell/vscode-haskell.git
$ cd vscode-haskell
$ npm install
$ vsce package
```
and install it manually as described above.

Once installed all features, including autocomplete and on-hover will be available.

### Persistency
The script will create a docker volume and use it in the container to share the whole ` /home/alonzo`  directory with the host. This will allow you to persist systematically every changes you will operate in the container. Thus, no need to re-download every plugin and dependency every time.

## Customize code-server
You can increase security, change default options and so on. You can do it directly in the container: since we are using a volume, all changes are persisted and will stay after reboot of the container. You can refer to the documentation available directly in the [code-server repository][3] to discover all available options.

[1]:https://github.com/haskell/haskell-language-server
[2]:https://docs.haskellstack.org/en/stable/README/
[3]:https://github.com/cdr/code-server
[4]:https://github.com/haskell/vscode-haskell
[5]:https://www.npmjs.com/package/vsce
[6]:https://marketplace.visualstudio.com/items?itemName=justusadam.language-haskell