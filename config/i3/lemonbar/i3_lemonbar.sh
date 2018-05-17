#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar

#echo "Hello Wordl"

# Ventanas en el Workspace
#activewindow(){
#	echo -n $(xdotool getwindowfocus getwindowname)
#}

# Hora del sistema
clock() {
        #DATETIME=$(date "+%a %b %d, %T")
	DAY=$(date "+%A") 
	DATE=$(date "+%d ")
	MONTH=$(date "+%B, %Y")
	TIME=$(date "+%I:%M")
	echo -n "${DAY^} ${DATE} ${MONTH^} - ${TIME}"
}

# Estatus de Bateria
#battery() {
#	BATTACPI=$(acpi --battery)
#	BATPERC=$(echo $BATTACPI | cut -d, -f2 | tr -d '[:space:]')
#
#	if [[ $BATTACPI == *"100%"* ]]
#	then
#		echo -e -n "$BATPERC"
#	elif [[ $BATTACPI == *"Discharging"* ]]
#	then
#		BATPERC=${BATPERC::-1}
#		if [ $BATPERC -le "10" ]
#		then
#			echo -e -n "10"
#		elif [ $BATPERC -le "25" ]
#		then
#			echo -e -n "25"
#		elif [ $BATPERC -le "50" ]
#		then
#			echo -e -n "50"
#		elif [ $BATPERC -le "75" ]
#		then
#			echo -e -n "75"
#		elif [ $BATPERC -le "100" ]
#		then
#			echo -e -n "100"
#		fi
#		echo -e " $BATPERC%"
#	elif [[ $BATTACPI == *"Charging"* && $BATTACPI != *"100%"* ]]
#	then
#		echo -e "$BATPERC"
#	elif [[ $BATTACPI == *"Unknown"* ]]
#	then
#		echo -e "$BATPERC"
#	fi
#}
battery(){
	cat /sys/class/power_supply/BAT0/capacity
}

#------------------------------
# Estatus de CPU
cpuload(){
	LINE=`ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'`
	echo `bc <<< $LINE`
}

#-----------------------------
# Sonido
volume() {
    amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p'
}

#-----------------------------
# Memoria RAM
memused() {
    read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo |awk '{print $2}'`
    echo `bc <<< "scale=2; 100 - $f / $t * 100" | cut -d. -f1`
}

#-----------------------------
#Red
red(){
	WIFISTR=$( iwconfig wlp3s0 | grep "Link" | sed 's/ //g' | sed 's/LinkQuality=//g' | sed 's/\/.*//g')
	if [ ! -z $WIFISTR ] ; then
		WIFISTR=$(( ${WIFISTR} * 100 / 70))
		ESSID=$(iwconfig wlp3s0 | grep ESSID | sed 's/ //g' | sed 's/.*://' | cut -d "\"" -f 2)
		if [ $WIFISTR -ge 1 ] ; then
			echo -e "${ESSID} ${WIFISTR}%"
		fi
	fi
}

#network() {
#    read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
#    if iwconfig $int1 >/dev/null 2>&1; then
#        wifi=$int1
#        eth0=$int2
#    else
#        wifi=$int2
#        eth0=$int1
#    fi
#    ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 ||int=$wifi

    #int=eth0

#    ping -c 1 8.8.8.8 >/dev/null 2>&1 && 
#        echo "$int connected" || echo "$int disconnected"
#}

#----------------------------
# Red
#wifi(){
#	WIFISTR=$( iwconfig wlp1s0 | grep "Link" | sed 's/ //g' | sed 's/LinkQuality=//g' | sed 's/\/.*//g')
#	if [ ! -z $WIFISTR ] ; then
#		WIFISTR=$(( ${WIFISTR} * 100 / 70))
#		ESSID=$(iwconfig wlp1s0 | grep ESSID | sed 's/ //g' | sed 's/.*://' | cut -d "\"" -f 2)
#		if [ $WIFISTR -ge 1 ] ; then
#			echo -e "${ESSID} ${WIFISTR}%"
#		fi
#	fi
#}


while true; do
	BAR_INPUT="%{c}%{F#FFFFFF}%{B#E74C3C}   $(volume)  | $(battery)%  |  $(clock)  |  $(cpuload)% | $(red) %{F-}%{B-}"
#	BAR_INPUT2 = "%{c}LIFE : $(battery)%% TIME : $(clock)"
	echo $BAR_INPUT 
#	echo "%{c}%{F#FFFFFF}%{B#E74C3C} $BAR_INPUT2 %{F-}%{B-}"
#       echo "%{r}$(Battery)"
        sleep 1;
done





#. $(dirname $0)/i3_lemonbar_config

#if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
#    printf "%s\n" "The status bar is already running." >&2
#    exit 1
#fi

#t#rap 'trap - TERM; kill 0' INT TERM QUIT EXIT

#[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
#mkfifo "${panel_fifo}"

### EVENTS METERS

# Window title, "WIN"
#xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${panel_fifo}" &

# i3 Workspaces, "WSP"
# TODO : Restarting I3 breaks the IPC socket con. :(
#$(dirname $0)/i3_workspaces.pl > "${panel_fifo}" &

# IRC, "IRC"
# only for init
#~/bin/irc_warn &

# Conky, "SYS"
#conky -c $(dirname $0)/i3_lemonbar_conky > "${panel_fifo}" &

### UPDATE INTERVAL METERS
#cnt_vol=${upd_vol}
#cnt_mail=${upd_mail}
#cnt_mpd=${upd_mpd}

#while :; do

  # Volume, "VOL"
#  if [ $((cnt_vol++)) -ge ${upd_vol} ]; then
#    amixer get Master | grep "${snd_cha}" | awk -F'[]%[]' '/%/ {if ($7 == "off") {print "VOL×\n"} else {printf "VOL%d%%%%\n", $2}}' > "${panel_fifo}" &
#    cnt_vol=0
#  fi

  # GMAIL, "GMA"
#  if [ $((cnt_mail++)) -ge ${upd_mail} ]; then
#    printf "%s%s\n" "GMA" "$(~/bin/gmail.sh)" > "${panel_fifo}"
#    cnt_mail=0
#  fi

  # MPD
#  if [ $((cnt_mpd++)) -ge ${upd_mpd} ]; then
    #printf "%s%s\n" "MPD" "$(ncmpcpp --now-playing '{%a - %t}|{%f}' | head -c 60)" > "${panel_fifo}"
#    printf "%s%s\n" "MPD" "$(mpc current -f '[[%artist% - ]%title%]|[%file%]' 2>&1 | head -c 70)" > "${panel_fifo}"
#    cnt_mpd=0
#  fi

  # Finally, wait 1 second
#  sleep 1s;

#done &

#### LOOP FIFO

#cat "${panel_fifo}" | $(dirname $0)/i3_lemonbar_parser.sh \
#  | lemonbar -p -f "${font}" -f "${iconfont}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" &

#wait
