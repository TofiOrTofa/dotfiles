local socket = require("socket.unix");
local json = require("cjson");

return {
    ["__init__"] = function(self)
        self.path = self.getPath();
        self.client = self:connect();
    end,
    ["getPath"] = function()
        local path = os.getenv("SWAYSOCK");
        if not path then
            local handle = io.popen("sway --get-socketpath");
            path = handle:read("*a"):gsub("%s+", "");
            handle:close();
        end;
        return path;
    end,
    ["connect"] = function(self)
        client = socket();
        assert(client:connect(self.path));
        return client;
    end,
    ["read"] = function(self, payload) -- subscribe
        local payload = json.encode(payload)
        local len = #payload;
        local msg = "i3-ipc" .. string.pack("I4I4", len, 2) .. payload;
        self.client:send(msg);
    end,
    ["read2"] = function(self, payload)
        local commands = {
            ["all"] = function()
                return client:send("SWAY-IPC\0\0\0\0\4\0\0\0")
            end,
            ["workspace"] = function()
                return client:send()
            end,
            ["windows"] = function()end,
            ["workspaceWithWindows"] = function()end,
        };
        for _, command in ipairs(payload) do
            return xpcall(commands[payload], function (err)
                return "function" .. payload .. ": " .. err
            end)
        end
    end,
    ["write"] = function(self, payload)
        local msg = "i3-ipc" .. string.pack("I4I4", #payload, 0) .. payload;
        self.client:send(msg);
    end,
};