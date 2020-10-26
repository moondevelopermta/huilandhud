local screenW,screenH = guiGetScreenSize()
local px,py = 1600,900
local x,y = (screenW/px), (screenH/py)

local font1 = dxCreateFont("files/Gilroy-Light.ttf", 16)
local font2 = dxCreateFont("files/Gilroy-Medium.ttf", 20)
local font3 = dxCreateFont("files/Gilroy-Regular.ttf", 40)

function enableCustomHUD()
	customHUDEnabled = not customHUDEnabled
	setPlayerHudComponentVisible("ammo", not customHUDEnabled)
	setPlayerHudComponentVisible("health", not customHUDEnabled)
	setPlayerHudComponentVisible("armour", not customHUDEnabled)
	setPlayerHudComponentVisible("breath", not customHUDEnabled)
	setPlayerHudComponentVisible("clock", not customHUDEnabled)	
	setPlayerHudComponentVisible("money", not customHUDEnabled)
	setPlayerHudComponentVisible("weapon", not customHUDEnabled)
	setPlayerHudComponentVisible("vehicle_name", not customHUDEnabled)
	setPlayerHudComponentVisible("area_name", not customHUDEnabled)
	setPlayerHudComponentVisible("radio", not customHUDEnabled)
    setPlayerHudComponentVisible("wanted", not customHUDEnabled)
	--setPlayerHudComponentVisible("radar", not customHUDEnabled)
end

--addCommandHandler("customhud", enableCustomHUD)
enableCustomHUD()

--------------------------------------------------

function dxHud()
	if getElementData(getLocalPlayer(), "hideHUD") then
   		return
	end

	local name = getPlayerName (localPlayer)
    
    local money = string.gsub(getPlayerMoney(), "^(-?%d+),(%d%d%d)", "%1 %2")
    local money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1 %2")
    local money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1 %2")
    
    local level = getElementData(localPlayer, "player:level") or 1
    local xp = getElementData(localPlayer, "player:xp") or 0
    
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
    if minutes <= 9 then
        minutes = "0"..minutes
    end
    
    --local dia = ("%02d"):format(time.monthday)
    --local mes = ("%02d"):format(time.month+1)
    --dxDrawText(name, x*1245, y*35, x*1670, y*25, tocolor(255, 255, 255, 255), 0.5, font2, "left", "center", false, false, true, true, false)
    dxDrawText(money.." ₽", x*1355, y*55, x*1670, y*25, tocolor(255, 255, 255, 255), 0.75, font1, "center", "center", false, false, true, true, false)
   -- dxDrawText("Уровень: "..level, 1250*x, 77*y, 1670*x, 25*y, tocolor(255, 255, 255, 255), 0.4, font2, "left", "center", false, false, true, true, false)
    --dxDrawText("Опыт: "..math.floor(xp).."/"..(level*400), 1355*x, 77*y, 1670*x, 25*y, tocolor(255, 255, 255, 255), 0.4, font2, "left", "center", false, false, true, true, false)
    
    --dxDrawText(hours..":"..minutes, x*1415, y*240, x*1670, y*25, tocolor(255,255,255, 255), 0.5, font3, "center", "center", false, false, true, true, false)
    
    --dxDrawText(dia, x*1290, y*220, x*1670, y*25, tocolor(255, 255, 255, 255), 0.55, font1, "center", "center", false, false, true, true, false)
    --dxDrawText(mes, x*1290, y*260, x*1670, y*25, tocolor(255, 255, 255, 255), 0.55, font1, "center", "center", false, false, true, true, false)
    dxDrawImage(1400*x, 5*y, 63*x, 75*y,"files/hud2.png",0.0,0.0,0.0,tocolor(255,255,255,255), false)
    Health = math.floor(getElementHealth(localPlayer))
    armor = math.floor(getPedArmor(localPlayer))
    dxDrawRectangle(1451.2*x, 56*y, 1.24*x*Health, (8/y)*y, tocolor(98,139,84,255), false) -- Здоровье
    dxDrawRectangle(1418*x, 22.5*y, 29.6*x, (0.45/y)*y*armor, tocolor(98,139,84,100), false) -- армор
    
    dxDrawImage(1430*x, 5*y, 159*x, 66*y,"files/hud.png",0.0,0.0,0.0,tocolor(255,255,255,255), false)
end

function renderDxHud()
	addEventHandler("onClientRender", getRootElement(), dxHud)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), renderDxHud)


function toggleHud()
	if isVisible then
		addEventHandler("onClientRender", root, dxHud)
	else
		removeEventHandler("onClientRender", root, dxHud)
	end
	isVisible = not isVisible
end
addCommandHandler("hud", toggleHud)

local playerMoney = getPlayerMoney ( localPlayer )
local messages =  { }

addEventHandler ( "onClientRender", root, function ( )
	local tick = getTickCount ( )
	if ( playerMoney ~= getPlayerMoney ( localPlayer ) ) then
		local pM = getPlayerMoney ( localPlayer ) 
		if ( pM > playerMoney ) then
			local diff = pM - playerMoney
			table.insert ( messages, { diff, true, tick + 2500, 180 } )
		else
			local diff = playerMoney - pM
			table.insert ( messages, { diff, false, tick + 2500, 180 } )
		end
		playerMoney = pM
	end
	
	if ( #messages > 7 ) then
		table.remove ( messages, 1 )
	end
	
	for index, data in ipairs ( messages ) do
		local v1 = data[1]
		local v2 = data[2]
		local v3 = data[3]
		local v4 = data[4]
        
		if ( v2 ) then
			dxDrawText ( "+ "..convertNumber(v1).." ₽", 2970*x, 150*y -(index*25), 50*x, 20*y, tocolor(0, 255, 0, v4+75), 0.75, font1, "center", "center", false, false, true, true, false)
		else
			dxDrawText ( "- "..convertNumber(v1).." ₽", 2970*x, 150*y -(index*25), 50*x, 20*y, tocolor(255, 0, 0, v4+75), 0.75, font1, "center", "center", false, false, true, true, false)
		end
		
		if (tick >= v3) then
			messages[index][4] = v4-2
			if (v4 <= 25) then
				table.remove (messages, index)
			end
		end
	end
end )



function convertNumber(number)  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')    
		if (k==0) then      
			break   
		end  
	end  
	return formatted
end