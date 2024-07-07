local alt = {}

function alt.req(info)
    local req = nil
    if syn and syn.req then
        req = syn.req
    elseif http and http.req then
        req = http.req
    elseif http_r then
        req = http_r
    else
        error("alt - not supported - HTTP Requests")
        return nil
    end
    return req(info)
end

local signals = {}

function alt.createSignal()
    local sig = {
        connections = {},
    }

    function sig:fire(...)
        local args = {...}
        for _, con in ipairs(sig.connections) do
            local success, err = pcall(con.callback, ...)
            if not success then
                warn("sigma fire failed:", err)
            end
        end
    end

    function sig:connect(callback)
        local connection = {
            callback = callback,
        }

        function connection:disconnect()
            for i, con in ipairs(sig.connections) do
                if con == connection then
                    table.remove(sig.connections, i)
                    break
                end
            end
        end

        table.insert(sig.connections, connection)
        return connection
    end

    function sig:clear()
        sig.connections = {}
    end

    table.insert(signals, sig)
    return sig
end

function alt.protUI(ui)
    if syn and syn.prot_gui then
        syn.prot_gui(ui)
    elseif p then
        p(ui)
    else
        warn("alt - not supported - GUI Protection!")
    end
    ui.Parent = (g and g()) or game.CoreGui
end

function alt.kickPlayer(msg)
    local success, err = pcall(function()
        if msg then
            game.Players.LocalPlayer:Kick(msg)
        else
            game.Players.LocalPlayer:Kick()
        end
    end)
    if not success then
        warn("alt - failed kick:", err)
    end
end

function alt.loadFile(path)
    local file = isfile(path)
    if file then
        return readfile(path)
    else
        error("alt - invalid - file missing")
        return nil
    end
end

function alt.sendChat(msg)
    return game:GetService("TextChatService"):WaitForChild("TextChannels"):WaitForChild("RBXGeneral"):SendAsync(msg)
end

alt.onPlayerChat = game.TextChatService.TextChannels.RBXGeneral.MessageReceived

return alt
