#!/usr/local/bin/bash
#/*
# * ----------------------------------------------------------------------------
# * "THE BEER-WARE LICENSE" (Revision 42):
# * <plasmoduck@gmail.com> wrote this file.  As long as you retain this notice you
# * can do whatever you want with this stuff. If we meet some day, and you think
# * this stuff is worth it, you can buy me a beer in return.   Plasmoduck
# * ----------------------------------------------------------------------------
# */

# You can use either mpc or mpd here to display now playing info
playing () {
	 mpc -h /usr/home/cjg/.mpd/socket | awk 'NR==1 {song = $0} NR==2 {if ($1 == "[playing]") p=1; len=$(NF-1); sub(/.*\//, "", len)} END {printf("%s (%s) %s\n", p?"":"", len, song)}'
}

# Covid19 tracking api set to Australia, change to your country
covid19 () {
	curl https://corona-stats.online/australia\?format\=json | python3 -c 'import sys,json;data=json.load(sys.stdin)["data"][0];print("",data["cases"],"",data["deaths"])'
}

# Memory management - this is FreeBSD specific. Change to suit Linux.
memory (){
	free | awk '(NR == 18) {print $6}'
}

# Hard drive free space.
drive (){
	df -h | grep '/$' | awk '{print $5}'
}

# CPU temp. Again, this is FreeBSD specific. Change variables for Linux.
cpu_temp (){
	sysctl dev.cpu.0.temperature | sed -e 's|.*: \([0-9.]*\)C|\1|'
}

# Mixer volume level
volume (){
	mixer -s vol | grep -Eo '[0-9]+$'
}

# Show the time
print_date (){
	date "+%r "
}

# Show the local temperature. Change 'Parramatta' to your local area.
weather() {
     LOCATION=Parramatta

     printf "%s" "$SEP1"
     if [ "$IDENTIFIER" = "unicode" ]; then
         printf "%s" "$(curl -s wttr.in/$LOCATION?format=1)"
     else
         printf "%s" "$(curl -s wttr.in/$LOCATION?format=1 | grep -o "[0-9].*")"
     fi
     printf "%s\n" "$SEP2"
 }

while true
do
	xsetroot -name " $(playing) | $(covid19) | $(memory) | $(drive) | $(cpu_temp) | $(volume)% | $(weather) | $(print_date)  "
	sleep 1s
done
