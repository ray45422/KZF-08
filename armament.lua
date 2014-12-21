function arm()
	if ammo>0 then
		if math.mod(_TICKS(),2)==0 then
			GUN1=GUN1+10000
		else
			GUN2=GUN2+10000
		end
	else
		GUN1=0
		GUN2=0
	end
	if _E(ARM1)==0 or _E(ARM2)==0 then
		ammo=ammo-1
	end
end

function arm_ctrl()
	if btlm==0 then
		if _KEY(7)>0 then
			arm()
		end
	else
		if _KEYDOWN(14)>0 then
			armament_select=selecter(armament_select+1,armament_num)
		end
		out(24,"selected armament:",armament_select)
		if _KEY(7)>0 then
			if armament_select==0 then
				arm()
			end
		end
		if _KEYDOWN(7)>0 then
			for i=1,2 do
				if armament_select==i then
					if miss_lunch[i][1]==1 then
						miss_lunch[i][3]=1
					else
						miss_lunch[i]={1,n,0}
						armament_select=selecter(armament_select+1,armament_num)
						break
					end
				end
			end
		end
	end
end
