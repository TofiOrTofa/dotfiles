if arg[1]==("left" or "right") then
  os.execute("swaymsg focus "..arg[1])
else
  os.execute("swaymsg move "..arg[2])
end

