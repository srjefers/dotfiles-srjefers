#Matar procesos
killall -q lemonbar

#---
while pgrep -u SUID -x lemonbar >/dev/null; do sleep 1; done

#iniciar
./i3_lemonbar.sh
