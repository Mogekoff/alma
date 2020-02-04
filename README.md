```
       _                                 _       _          ____   ___  
      | |                               (_)     | |        |___ \ / _ \ 
  __ _| |_ __ ___   __ _   ___  ___ _ __ _ _ __ | |_  __   ____) | | | |
 / _` | | '_ ` _ \ / _` | / __|/ __| '__| | '_ \| __| \ \ / /__ <| | | |
| (_| | | | | | | | (_| | \__ \ (__| |  | | |_) | |_   \ V /___) | |_| |
 \__,_|_|_| |_| |_|\__,_| |___/\___|_|  |_| .__/ \__|   \_/|____(_)___/ 
                                          | |                           
                                          |_|                           
```
# Arch Linux Maker Automatic
## automatic, recursive, continious, interactive

### 1. Firstly, check your internet connection:
```bash
ping example.com
```
#### If you can't get a response from the site then fix your connection and go next.

### 2. Type this command below:
```bash
sh -c "$(curl -fsSL https://git.io/Jv3s4)"
```
### 3. Follow installer instructions.

#### Q: Automatic?
##### A: [Yes](https://i.kym-cdn.com/photos/images/original/001/650/747/aaf.png). The script will do all the dirty work for you cleanly and quickly.
#### Q: Recursive?
##### A: The installation process consists of three scripts. The first script calls the second, the second calls the third, and the third at the end of the job returns control to the second, and the second to the first. Beauty. You can also refuse to execute the third script and this will not break the [execution chain](https://i.ibb.co/qyCBGj7/image.png).
#### Q: Continious?
##### А: Based on the above, you do not have to enter another command after completing each script to download and run the next part of the installation. During installation, only one computer reboot will occur - upon completion of the script.
#### Q: Interactive?
##### A: You choose how you want to see Vova after installation. We do not decide for you. At each custom moment, we ask a simple question with the answer yes, no or a choice from the list. The script performs only the basic routine work.


##### P.S.:  You can fork and edit this script for yourself. I mean GNU GPL v3.
##### P.S.S: Also, you can download these scripts and edit them with nano or something right on your live ArchISO.
### Script URIs:
#1: https://git.io/Jv3s4

#2: https://git.io/Jv3sR

#3: https://git.io/Jv3s0

## TODO:
### OpenRC Migrating
### Wayland Migrating
