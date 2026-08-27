volume = {
    up = function (percent)
      return (
        [[spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ ]]
        .. percent
        .. [[%+']]
      )
    end,
    down = function (percent)
      return (
        [[spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ ]]
        .. percent
        .. [[%-']]
      )
    end,
    mute = [[spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle']]
  }
microphone = {
    up = function (percent)
      return [[]]
    end,
    down = function (percent)
      return [[]]
    end,
    mute = [[spawn 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle']]
  }
brightness = {
    up = function (percent)
      return [[spawn 'brightnessctl set +]] .. percent .. [[%']]
    end,
    down = function (percent)
      return [[spawn 'brightnessctl set -- -]] .. percent .. [[%']]
    end,
    mute = [[]]
  }
layout = {
    windows = {
        next = [[send-layout-cmd luatile "scroll_next()"]],
        prev = [[send-layout-cmd luatile "scroll_prev()"]]
      }
  }
screenshot = [[spawn 'grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%s).png']]
terminal = [[spawn 'env LANG=C.UTF-8 LCALL=C.UTF-8 foot']]

return                                {
    ["normal"]                        = {
	["None"]                        = {
            ["XF86AudioRaiseVolume"]      = {volume.up(10)},
            ["XF86AudioLowerVolume"]      = {volume.down(5)},
            ["XF86AudioMute"]             = {volume.mute},
            ["XF86AudioMicMute"]          = {microphone.mute},
            ["XF86MonBrightnessUp"]       = {brightness.up(10)},
            ["XF86MonBrightnessDown"]     = {brightness.down(5)},
            ["Print"]                     = {screenshot},
	                                },
        ["Mod4"]                        = {
            ["D"]                         = {[[enter-mode search]]},
            ["R"]                         = {[[enter-mode resize]]},

            ["T"]                         = {terminal},

            ["F"]                         = {[[toggle-float]]};
            ["J"]                         = {[[focus-view next]]};
            ["K"]                         = {[[focus-view previous]]};
            ["H"]                         = {[[zoom]]};

            ["period"]                    = {
                                              [[focus-view next]],
                                              layout.windows.next
                                            },
            ["comma"]                     = {
                                              [[focus-view previous]],
                                              layout.windows.prev
                                            },

            ["W"]                         = {
                                              [[spawn combining_tags]],
                                              [[enter-mode normal]]
                                            },
            ["B"]                         = {
                                              [[spawn window_add_tags]],
                                              [[enter-mode normal]]
                                            },

            ["1"]                         = {[[set-focused-tags 1]]},
            ["2"]                         = {[[set-focused-tags 2]]},
            ["3"]                         = {[[set-focused-tags 4]]},
            ["4"]                         = {[[set-focused-tags 8]]},
            ["5"]                         = {[[set-focused-tags 16]]},
            ["6"]                         = {[[set-focused-tags 32]]},
            ["7"]                         = {[[set-focused-tags 64]]},
            ["8"]                         = {[[set-focused-tags 128]]},
            ["9"]                         = {[[set-focused-tags 256]]},
                                          },
        ["Mod4+Shift"]                       = {
            ["XF86AudioRaiseVolume"]      = {volume.up(20)},
            ["XF86AudioLowerVolume"]      = {volume.down(10)},
            ["XF86AudioMute"]             = {volume.mute},
            ["XF86AudioMicMute"]          = {microphone.mute},
            ["XF86MonBrightnessUp"]       = {brightness.up(20)},
            ["XF86MonBrightnessDown"]     = {brightness.down(10)},
            ["Print"]                     = {screenshot},

            ["Escape"]                    = {
                                              [[enter-mode screen_sleep]],
                                              [[spawn "wlr-randr --output eDP-1 --off"]]
                                            },
            ["D"]                         = {[[enter-mode search]]},
            ["R"]                         = {[[enter-mode resize]]},

            ["E"]                         = {[[exit]]},
            ["Q"]                         = {[[close]]},
            ["C"]                         = {[[close]]},

            ["F"]                         = {[[toggle-fullscreen]]},

            ["J"]                         = {[[swap next]]},
            ["K"]                         = {[[swap previous]]},

            ["period"]                    = {
                                              layout.windows.next,
                                              [[swap next]]
                                            },
            ["comma"]                     = {
                                              layout.windows.prev,
                                              [[swap previous]]
                                            },

            ["H"]                         = {[[send-layout-cmd rivertile "main-count +1"]]},
            ["L"]                         = {[[send-layout-cmd rivertile "main-count -1"]]},

            ["semicolon"]                 = {[[spawn command_center]]},

            ["1"]                         = {[[set-view-tags 1]]},
            ["2"]                         = {[[set-view-tags 2]]},
            ["3"]                         = {[[set-view-tags 4]]},
            ["4"]                         = {[[set-view-tags 8]]},
            ["5"]                         = {[[set-view-tags 16]]},
            ["6"]                         = {[[set-view-tags 32]]},
            ["7"]                         = {[[set-view-tags 64]]},
            ["8"]                         = {[[set-view-tags 128]]},
            ["9"]                         = {[[set-view-tags 256]]}
                                          },
        ["Control"]                     = {
            ["Up"]                        = {volume.up(10)},
            ["Down"]                      = {volume.down(5)}
                                          }
                                        },
    ["resize"]                        = {
        ["None"]                        = {
            ["XF86AudioRaiseVolume"]      = {volume.up(10)},
            ["XF86AudioLowerVolume"]      = {volume.down(5)},
            ["XF86AudioMute"]             = {volume.mute},
            ["XF86AudioMicMute"]          = {microphone.mute},
            ["XF86MonBrightnessUp"]       = {brightness.up(10)},
            ["XF86MonBrightnessDown"]     = {brightness.down(5)},
            ["Print"]                     = {screenshot},

            ["H"]                         = {[[send-layout-cmd rivertile "main-ratio -0.05"]]},
            ["L"]                         = {[[send-layout-cmd rivertile "main-ratio +0.05"]]},

            ["Super_L"]                   = {[[enter-mode normal]]},
            ["D"]                         = {[[enter-mode search]]}
                                          },
        ["Shift"]                       = {
            ["XF86AudioRaiseVolume"]      = {volume.up(20)},
            ["XF86AudioLowerVolume"]      = {volume.down(10)},
            ["XF86AudioMute"]             = {volume.mute},
            ["XF86AudioMicMute"]          = {microphone.mute},
            ["XF86MonBrightnessUp"]       = {brightness.up(20)},
            ["XF86MonBrightnessDown"]     = {brightness.down(10)},
            ["Print"]                     = {screenshot},

            ["H"]                         = {[[send-layout-cmd rivertile "main-ratio -0.2"]]};
            ["L"]                         = {[[send-layout-cmd rivertile "main-ratio +0.2"]]};
                                          }
                                        },
    ["search"]                        = {
        ["None"]                        = {
            ["XF86AudioRaiseVolume"]      = {volume.up(10)},
            ["XF86AudioLowerVolume"]      = {volume.down(5)},
            ["XF86AudioMute"]             = {volume.mute},
            ["XF86AudioMicMute"]          = {microphone.mute},
            ["XF86MonBrightnessUp"]       = {brightness.up(10)},
            ["XF86MonBrightnessDown"]     = {brightness.down(5)},
            ["Print"]                     = {screenshot},


            ["D"]                         = {
                                              [[spawn 'fuzzel']],
                                              [[enter-mode normal]]
                                            },
            ["E"]                         = {
                                              [[spawn 'wofi-emoji']],
                                              [[enter-mode normal]]
                                            },
            ["L"]                         = {
                                              [[spawn "layoutmenu"]],
                                              [[enter-mode normal]]
                                            },

            ["Escape"]                    = {[[enter-mode normal]]},
            ["Super_L"]                   = {[[enter-mode normal]]},
            ["R"]                         = {[[enter-mode resize]]}
                                          },
        ["Shift"]                       = {
            ["XF86AudioRaiseVolume"]      = {volume.up(20)},
            ["XF86AudioLowerVolume"]      = {volume.down(10)},
            ["XF86AudioMute"]             = {volume.mute},
            ["XF86AudioMicMute"]          = {microphone.mute},
            ["XF86MonBrightnessUp"]       = {brightness.up(20)},
            ["XF86MonBrightnessDown"]     = {brightness.down(10)},
            ["Print"]                     = {screenshot};
                                          }
                                        },
    ["screen_sleep"]                  = {
        ["Shift"]                       = {
            ["Escape"]                    = {
                                              [[enter-mode normal]],
                                              [[spawn "wlr-randr --output eDP-1 --on"]]
                                            }
                                          }
                                        }
                                      }
