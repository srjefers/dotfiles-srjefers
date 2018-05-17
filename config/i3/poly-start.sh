# Matar procesos
killall -q polybar

#----
while pgrep -u SUID -x polybar >/dev/null; do sleep 1; done

# Iniciar
polybar example -r &

