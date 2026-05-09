#системные настройки
xset s off & xset -dpms &

#обои
feh --bg-fill ~/wallpapers/static/wallpaper4

#тачпад
~/.config/i3/scripts/touchpad-mac.sh

#полибар
sleep 2
~/.config/polybar/launch3.sh

exec autotiling-rs
#autotiling
picom --config ~/.config/picom/picom_not_animate.conf

#видиообои
#~/.config/i3/scripts/dinamic-wallpaper.sh -a ~/wallpapers/dinamic/wallpaper4.mp4
