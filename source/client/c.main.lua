QuitPlayer = {}
QuitPlayer.__index = QuitPlayer

function QuitPlayer:new(dados)
    local obj = setmetatable({}, self)
    obj.name = dados['Name']
    obj.id = dados['ID']
    obj.motivo = dados['Motivo']
    obj.pos = dados['Pos']
    obj.int = dados['Int']
    obj.dim = dados['Dim']
    obj.timestamp = dados['Timestamp']
    return obj
end

function QuitPlayer:isVisibleToPlayer()
    local px, py, pz = getElementPosition(localPlayer)
    local x, y, z = unpack(self.pos)
    return getDistanceBetweenPoints3D(x, y, z, px, py, pz) < settings['gerais']['distancia']['quit']
end

function QuitPlayer:draw()
    local px, py, pz = getElementPosition(localPlayer)
    local x, y, z = unpack(self.pos)
    local sx, sy = getScreenFromWorldPosition(x, y, z)
    if sx and sy then
        local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        local distance = settings['gerais']['distancia']['quit']
        if distanceBetweenPoints < distance then
            local scale = 1.5 - (distanceBetweenPoints / distance)
            dxDrawText('Saiu do Servidor', sx, sy+2, sx, sy+2, tocolor(255, 74, 74, 255), scale, 'sans', 'left', 'center')
            dxDrawText('ID: ', sx+30, sy+20, sx, sy+20, tocolor(255, 255, 255, 255), scale, 'sans', 'left', 'center')
            dxDrawText(self.id, (sx+26) + dxGetTextWidth('ID: ', scale, 'sans'), sy+20, sx, sy+20, tocolor(255, 77, 77, 255), scale, 'sans', 'left', 'center')
            dxDrawText('Motivo: ', sx, sy+38, sx, sy+38, tocolor(255, 255, 255, 255), scale, 'sans', 'left', 'center')
            dxDrawText(self.motivo, (sx-13) + dxGetTextWidth('Motivo: ', scale, 'sans'), sy+38, sx, sy+38, tocolor(255, 77, 77, 255), scale, 'sans', 'left', 'center')
        end
    end
end

QuitManager = {}
QuitManager.__index = QuitManager

function QuitManager:new()
    local obj = setmetatable({}, self)
    obj.data = {}
    return obj
end

function QuitManager:add(dados)
    table.insert(self.data, QuitPlayer:new(dados))
end

function QuitManager:update()
    for i = #self.data, 1, -1 do
        local qp = self.data[i]
        if getRealTime().timestamp > qp.timestamp then
            table.remove(self.data, i)
        end
    end
end

function QuitManager:render()
    for _, qp in ipairs(self.data) do
        if qp.int == getElementInterior(localPlayer) and qp.dim == getElementDimension(localPlayer) then
            if qp:isVisibleToPlayer() then
                qp:draw()
            end
        end
    end
end

quitManager = QuitManager:new()

addEventHandler('onClientRender', root, function()
    quitManager:update()
    quitManager:render()
end)

addEvent('Atlas.QuitPlayer', true)
addEventHandler('Atlas.QuitPlayer', root, function(dados)
    quitManager:add(dados)
end)


--[[addCommandHandler('qt', function()
    local x, y, z = getElementPosition(localPlayer)
    local dados = {
        Name = getPlayerName(localPlayer),
        ID = getElementData(localPlayer, settings['gerais']['data_id']) or '123',
        Motivo = 'Teste',
        Pos = {x, y, z},
        Int = getElementInterior(localPlayer),
        Dim = getElementDimension(localPlayer),
        Timestamp = getRealTime().timestamp + 30
    }
    triggerEvent('Atlas.QuitPlayer', localPlayer, dados)
end)--]]
