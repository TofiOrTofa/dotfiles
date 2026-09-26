local Display = {}
Display.__index = Display
do
  function Display.new(parent, config)
    local self = setmetatable(config or {}, Display)
    self.parent = parent
    self.window = {
      current = (config.current_window or 1),
      history = 1
    }
    return self
  end
  function Display:scroll_next()
    local max_windows = self.parent.current.count
    local w = self.window.current
    self:update((w < max_windows) and (w + 1) or 1)
    return self
  end
  function Display:scroll_prev()
    local max_windows = self.parent.current.count
    local w = self.window.current
    self:update((w > 1) and (w - 1) or max_windows)
    return self
  end
  function Display:check()
    if self.window.current > self.parent.current.count then
      self:update(self.window.history > self.parent.current.count
        and 1 or self.window.history)
    end
    return self
  function Display:update(current_window)
    self.winodw.history = self.window.current
    self.window.current = current_window
    return self
  end
end

local Tag = {}
Tag.__index = Tag
do
  function Tag.new(tag_num, display, count)
    local instance = {
      num     = tag_num,
      current = {
        count   = count   or 0,
        max     = math.max(0, (count or 0) - 1)
      },
      history = {
        count   = count   or 0
      }
    }
    setmetatable(instance, Tag)
    instance.display = Display.new(instance, { current_window = display })
    return instance
  end

  function Tag:del_winodow()
    self.history.count = self.current.count
    self.current.count = self.current.count - 1
    self.display:check()
    return self
  end
  function Tag:add_window()
    self.history.count = self.current.count
    self.current.count = self.current.count + 1
    return self
  end

  function Tag:log(message)
    message = message or ""
    print(string.format(
      "[Tag %d] (display: %d) (correct count: %d) %s",
      self.num, self.current.display, self.current.count,
      message
    ))
    return self
  end

end

local calculate = {}
do
  do
    local SHIFTS = { next = 1, prev = -1 }
    function calculate.valid_index(current_index, count, action)
      if not count or count <= 1 then return 0 end
      if max_index == 0 then return 0 end
      return (current_index + (SHIFTS[action] or 0)) % count
    end
  end
end

local start, handle_layout, handle_metadata, scroll_next, scroll_prev
do
  local WIDTH, HEIGHT = 1920, 1068
  local GAP  = 10
  local PEEK = 0.3

  local state = {}

  local VIEW_W  = WIDTH * (1 - PEEK)
  local VIEW_H  = HEIGHT - GAP * 2
  local STEP    = VIEW_W + GAP
  local CENTER_X  = (WIDTH - VIEW_W) / 2
  local LEFT_X    = 0
  local RIGHT_X   = WIDTH - VIEW_W

  local function generate_layout_coords(count, offset_index)
    local position = {
      [0]         = LEFT_X,
      [count - 1] = RIGHT_X
    }
    local target_x = (count > 1 and position[offset_index]) or CENTER_X
    local screen_base_x = target_x - (offset_index * STEP)
    local coords = {}
    for i = 0, count - 1 do
      coords[i + 1] = {
        screen_base_x + (i * STEP), GAP,    --> coords    x, y
        VIEW_W, VIEW_H                      --> size      w, h
      }
    end
    return coords
  end

  function handle_layout(args)
      local tag_num = args.tags
      local tag = state[tag_num] or Tag.new(
        tag_num, 0, args.count)
      state[tag_num] = tag:update({
        count = args.count,
        display = calculate.valid_index(
          tag.current.display, args.count
        )
      }):log()
      state.current_tag = tag_num
      return generate_layout_coords(
        tag.current.count, state[tag_num].current.display)
  end

  function handle_metadata() --> arguments: args
    return { name = "lua-scroll" }
  end

  do
    local function perform_scroll(direction)
      local tag_num = state.current_tag or 1
      local tag = state[tag_num]
      if not tag then return "not init tag" end
      local tag_current = tag.current
      state[tag_num] = tag:update{
        display = calculate.valid_index(
          tag_current.display, tag_current.count, direction
        )
      }
      return;
    end

    function scroll_next()
      local err = perform_scroll("next")
      if err then print(tostring(err)) end
    end
    function scroll_prev()
      local err = perform_scroll("prev")
      if err then print(tostring(err)) end
    end
  end

  function start() os.execute("riverctl default-attach-mode above") end

end

_G.start                    = start
_G.handle_layout            = handle_layout
_G.handle_metadata          = handle_metadata
_G.scroll_next              = scroll_next
_G.scroll_prev              = scroll_prev

