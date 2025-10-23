QuitServer = {}
QuitServer.__index = QuitServer

function QuitServer:new()
    local obj = setmetatable({}, self)
    obj.gerais = settings['gerais']
    return obj
end

function QuitServer:handlePlayerQuit(player, quitType)
    local times = getRealTime().timestamp
    local dados = {
        Dim = getElementDimension(player),
        Int = getElementInterior(player),
        Name = removeHex(getPlayerName(player)),
        ID = getElementData(player, self.gerais['data_id']) or 'N/A',
        Motivo = settings['type:disconnect'][quitType],
        Pos = {getElementPosition(player)},
        Timestamp = times + (self.gerais['tempo'] * 60)
    }

    triggerClientEvent(root, 'Atlas.QuitPlayer', root, dados)

    sendDiscord("Banido", {
        "`👤` Jogador(a): "..dados['Name'],
        "`📄` ID: "..dados['ID'],
        "`⏺️` Motivo: "..settings['type:disconnect'][quitType],
        "`🛡️` Serial: "..getPlayerSerial(player),
    }, settings['webhook'])

    self:notifyNearbyPlayers(player, quitType)
end

function QuitServer:notifyNearbyPlayers(player, quitType)
    for _, v in ipairs(getElementsByType('player')) do
        if v ~= player and getElementDimension(v) == getElementDimension(player) and getElementInterior(v) == getElementInterior(player) then
            local x, y, z = getElementPosition(v)
            local x2, y2, z2 = getElementPosition(player)
            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < settings['gerais']['distancia']['chat'] then
                outputChatBox('player id: '..(getElementData(player, self.gerais['data_id']) or 'N/A')..' saiu ('..settings['type:disconnect'][quitType].. ')', v, 255, 255, 255, true)
            end
        end
    end
end

quitServer = QuitServer:new()

addEventHandler('onPlayerQuit', root, function(quitType)
    quitServer:handlePlayerQuit(source, quitType)
end)
