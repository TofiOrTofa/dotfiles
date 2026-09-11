return {
  hex_off       = function(color) return color:gsub("#", "") end,
  alpha_off     = function(color)
                    if #color == 8 then
                      return color:sub(1, 6)
                    elseif #color == 9 then
                      return color:sub(1, 7)
                    end
                  end
}
