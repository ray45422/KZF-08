function sminov_init()
	if SMIRNOFF_VERSION~=nil then
		dWindow=ray.smirnoff:new(300,400,"DamageWindow")
		dWindow:Move(100,0)
		dWindow:SetBGCol(0)
		dWindow:CreatePen(3,"FF00",1)
		dWindow:CreatePen(2,"FFFF00",1)
		dWindow:CreatePen(1,"FF0000",1)
		dWindow:CreatePen("blue","FF",5)
		dWindow:CreatePen("green","FF00",1)
		dWindow:CreatePen("white","FFFFFF",1)
		dWindow:CreateBrush("orange","FFFF00")
		dWindow:CreateBrush("green","FF00")
		dWindow:CreateBrush("red","FF0000")
		dWindow:CreateFont(1,20)
		dWindow:SetFont(1)
		if _PLAYERS()>0 then
			Rader=ray.Rader:new(300,300)
			Rader:Move(100,430)
		end
	end
end

function sminov_OnFrame()
	if SMIRNOFF_VERSION~=nil then
		dWindow:tick()
		dWindow:DrawText(10,20,"FFFFFF",string.format("Gun:%d",ammo))
		dWindow:DrawText(100,20,"FFFFFF",string.format("Flight Distance:%.1fkm",length/1000))
		dWindow:SetPen("white")
		dWindow:DrawRectangle(231,99,36,12)
		dWindow:MoveTo(243,99)
		dWindow:LineTo(243,111)
		dWindow:MoveTo(255,99)
		dWindow:LineTo(255,111)
		for i=1,3 do
			if _TOP(_G["GEAR"..i])==0 then
				if GANG1<=100 then
					dWindow:SetBrush("green")
					dWindow:FillRectangle(220+10*i+i*2,100,10,10)
				elseif not(GANG1>=180) then
					dWindow:SetBrush("orange")
					dWindow:FillRectangle(220+10*i+i*2,100,10,10)
				end
			else
				dWindow:SetBrush("red")
				dWindow:FillRectangle(220+10*i+i*2,100,10,10)
			end
		end
		for i=1,table.getn(bodyData) do
			size=30
			if _TYPE(bodyData[i][6])~=9 and (_TYPE(bodyData[i][6])<11 or (_TYPE(bodyData[i][6])==33 and _OPTION(bodyData[i][6])~=1)) then
				if _TOP(bodyData[i][6])==0 then
					dWindow:SetPen(damageLevel(bodyData[i][6]))
				else
					dWindow:SetPen(1)
				end
				dWindow:RotRectangle(150-bodyData[i][1]*size,90+bodyData[i][2]*size,size*math.cos(bodyData[i][5]),size*math.cos(bodyData[i][3]),bodyData[i][4])
			end
		end
		if _PLAYERS()>0 then
			if Rader==nil then
				Rader=ray.Rader:new(300,300)
				Rader:Move(100,430)
			end
			Rader:tick(n)
		end
	else
		sminov=0
	end
end