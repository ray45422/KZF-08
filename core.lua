function MainSystem()
	--モード制御
	if mode==0 and math.abs(_H())<1.5 and math.abs(_VZ())<1 then ammo=800 end
	if _KEY(9)>0 then
		if _KEYDOWN(5)>0 then
			modes=1-modes
			jetp=-4 jetabp=0
			speed=_VEL(CORE)*3.6-math.mod(_VEL(CORE)*3.6,5)
			hikeolib.pid_reset(2)
		end
		if _KEYDOWN(7)>0 then
			modeap=1-modeap
		end
		if _KEYDOWN(12)>0 then
			btlm=1-btlm
		end
		if _KEYDOWN(13)>0 then
			modeo=1-modeo
		end
		if _KEYDOWN(14)>0 then
			modek=modek+1
		end
		if _KEYDOWN(15)>0 then
			p_data_reset()
		end
		if _KEYDOWN(16)>0 then
			modem=1-modem
			setlim=0
		end
	else
		if _KEY(7)>0 then
			--arm()
		else
			GUN1=0 GUN2=0
		end
		if _KEYDOWN(12)>0 then 
			mode=1-mode
		end
		if _KEYDOWN(13)>0 then
			setlim=1-setlim
		end
		if _KEYDOWN(14)>0 and btlm==0 then
			modea=1-modea
		end
		if _KEY(16)>0 then
			ABRAKE=hikeolib.ang(ABRAKE,v*4,hikeolib.limit(v/10,1,5))
			BRAKE=BRAKE+20
		end
	end
	if _PLAYERS()>=0 and modek==4 or _PLAYERS()==0 and modek==2 then
		modek=0
	end
	if mode==1 then
		GANG1=GANG1+2
		BRAKE=BRAKE+200
		BRAKE2=BRAKE2+200
		SPR=1
	else
		GANG1=GANG1-2
		SPR=0.8
	end
	if _KEYDOWN(10)>0 then
		modev=1-modev
	end
	
	--JET制御
	if _KEY(5)>0 or _KEY(8)>0 then
		jetco=jetco+1
	else
		jetco=0
	end
	if _KEY(5)>0 and _KEY(8)>0 then
		jetco=0
	end
	if modes==0 then
		if _KEY(5)>0 then
			if jetp==0 or jetp+jetabp==100 then 
				if jetco==1 then
					if jetp==100 then
						jetabp=jetabp+2
					else
						jetp=jetp+2
					end
				end
			else
				if jetabp==0 then
					jetp=jetp+2
				else
					jetabp=jetabp+2
				end
			end
		end
		if _KEY(8)>0 then
			if jetp==0 then
				if jetco==1 then
					jetp=jetp-2
				end
			else
				if jetabp==0 then
					jetp=jetp-2
				end
			end
		end	
	else
		speed=speed or 0
		if _KEY(5)>0 then
			if speed==0 then
				if jetco==1 then
					speed=speed+5
				end
			else
				speed=speed+5
			end
		end
	end
	if _KEY(8)>0 then
		if speed==0 then
			if jetco==1 then
				speed=speed-5
			end
		else
			speed=speed-5
		end
	end
	if modes==0 then
		jetp=hikeolib.limit(jetp,-30,100)
		jetabp=hikeolib.limit(jetabp,0,40)
	end
	--ジェット噴出口制御
	if jetabp>0 then
		JANG3_2=0	
		AB=100000
	else
		JANG3_2=jetp/5
	end
	if math.abs(JANG3-JANG3_2)>4 then
		jangsp=4
	else
		jangsp=math.abs(JANG3_2-JANG3)
	end
	if JANG3>JANG3_2 then
		JANG3=JANG3-jangsp
	else
		JANG3=JANG3+jangsp
	end
	if modea==1 then
		if modek<=1 then
			ABalancer(modek)
		else
			local angle1_tmp,angle2_tmp,jang2_tmp,rtime,len,trigger
			if modek==2 then
				angle1_tmp,angle2_tmp,jang2_tmp,speed2,rtime,len,trigger=follow(0,n,{5,1,0.5},0,{name=formationName,n=formationNumber,y=5,z=-30})
			elseif modek==3 then
				angle1_tmp,angle2_tmp,jang2_tmp,speed2,rtime,len,trigger=follow(0,n,{5,1,0.5},0)
			end
			if len>30 then
				speed2=speed2*3.6+(len-30)*5
				if speed2+_VZ()*3.6<-50 then ABRAKE=ABRAKE+1 end
			else
				speed2=speed2*3.6
				if speed2+_VZ()*3.6<-20 then ABRAKE=ABRAKE+1 end
			end
			if spi then
				speed2=hikeolib.limit(speed2,-200,600)
			else
				speed2=hikeolib.limit(speed2,-200,500)
			end
			if modek==3 then
				speed2=math.max(speed2,100)
			end
			if modem==1 then
				jang2_tmp=hikeolib.limit(jang2_tmp,-1,1)
				angle1_tmp=hikeolib.limit(angle1_tmp,-v,v)
			end
			speed_lim(speed2)
			JANG2=hikeolib.ang(JANG2,jang2_tmp,4)
			ANGLE2=hikeolib.ang(ANGLE2,angle2_tmp,4)
			ANGLE3=ANGLE2
			ANGLE1=hikeolib.ang(ANGLE1,angle1_tmp,4)
			if trigger and modek==3 then
				arm() end
			if math.abs(angle1_tmp)>20 then
				jang1_tmp=120+(math.abs(angle1_tmp)-20)*angle1_tmp/math.abs(angle1_tmp)
				JANG1=jang1_tmp
				JANG1L=JANG1
			else
				JANG1=hikeolib.ang(JANG1,120,4)
				JANG1L=JANG1
			end
			if _H()==-100000 then
				mode=1
			else
				mode=0
			end
		end
	end
	if spi then
		if _Y()<5000 then
			speed=hikeolib.limit(speed,-200,1000)
		else
			speed=hikeolib.limit(speed,-200,1500)
		end
	else
		speed=hikeolib.limit(speed,-200,500)
	end
	--VALstepもどき
	if modev==0 then
		if modea==1 and modek<2 or modea==0 then
			if _KEY(0)==0 and _KEY(1)==0 then
				if modea==0 then
					ANGLE1=hikeolib.ang(ANGLE1,0,4)
				end
				if _KEY(2)==0 and _KEY(3)==0 then
					if math.abs(JANG1L)>0 then
						JANG1L=hikeolib.ang(JANG1L,120,4)
					end
					if math.abs(JANG1)>0 then
						JANG1=hikeolib.ang(JANG1,120,4)
					end
				end
			end
			if _KEY(0)==0 and _KEY(1)==0 and _KEY(4)==0 and _KEY(6)==0 then
				if math.abs(ANGLE4)>0 then
					ANGLE4=hikeolib.ang(ANGLE4,0,4)
				end
				if math.abs(ANGLE5)>0 then
					ANGLE5=hikeolib.ang(ANGLE5,0,4)
				end
			end
			if _KEY(4)==0 and _KEY(6)==0 then
				if modea==0 then
					JANG2=hikeolib.ang(JANG2,0,2)
				elseif modek~=1 then
					JANG2=hikeolib.ang(JANG2,0,2)
				end
			end
		end
	else
		ANGLE4=hikeolib.ang(ANGLE4,0,4)
		ANGLE5=hikeolib.ang(ANGLE5,0,4)
		ANGLE1=hikeolib.ang(ANGLE1,0,4)
		ANGLE1_2=hikeolib.ang(ANGLE1_2,ANGLE1,4)
		JANG1L=hikeolib.ang(JANG1L,120,4)
		JANG1=hikeolib.ang(JANG1,120,4)
		JANG2=hikeolib.ang(JANG2,0,2)
	end	
	if modea==0 then
		if _KEY(2)==0 and _KEY(3)==0 then
			ANGLE2=hikeolib.ang(ANGLE2,0,2)
			ANGLE3=hikeolib.ang(ANGLE3,0,2)
		end
	end
	local abstat=""
	if jetabp>0 then
		abstat="[A/B on]"
	end
	if modev==0 then
		JETV=0 JETVR=0 JETVL=0 JETVLR=0 JETVLR2=0
		Plane()
	else
		VTOL()
	end
	--表示
	out(0,string.format("FPS =%2.1f  %2.1fkm/h",_FPS(),-_VZ(core)*3.6))
	out(2,string.format("Power %d%% %s",jetp+jetabp,abstat))
	if modes==1 then
		if modea==0 or modek<=1 then
			out(3,string.format("Speed:%d",speed))
		else
			out(3,string.format("Speed:%d[auto] manual:%d",speed2,speed))
		end
	end
	if setlim==0 then
		if modem==1 then
			out(13,"V-Max Mode")
		else
			out(13,"All Limitter Release")
		end
	end
	
	if modeo==1 then
		Print()
	end
	if _PLAYERS()==0 then--ネットワーク関連表示
		out(1,"OFF LINE")
	else
		NetWork(1,HUD,15)
	end
	if hudlevel==2 then
		hud_all(0,HUD,0.03,n,{x=0,y=0.08,col="FF00",range=2000})
	end
	if hudlevel>=1 then
		basicmoniter3D(0,HUD,0.8,"FF00",0,0.08,{btlm,g=G,ammo=ammo,gear=mode})
	end
end

function VTOL()
	weight=_WEIGHT()
	ABRAKE=ABRAKE+5 BRAKE=BRAKE+20
	jetmax=weight*62
	if _H(GEAR2)<=0.32 and _H(GEAR)>=0 and _KEY(1)==0 then
		JETV=0 JETVR=0 JETVL=0
	else
		JETV=jetmax*0.43 JETVR=jetmax*0.285 JETVL=jetmax*0.285
	end
	local ax=_AX(BODY) az=_AZ(BODY)
	JETV=JETV-JETV*ax JETVR=JETVR+JETVR*ax JETVL=JETVL+JETVL*ax
	JETVR=JETVR-JETVR*az JETVL=JETVL+JETVL*az

	local vy=_VY(BODY)/4
	if _KEY(0)==0 and _KEY(1)==0 then
		JETV=JETV-JETV*vy JETVR=JETVR-JETVR*vy JETVL=JETVL-JETVL*vy
	end
	if _KEY(0)>0 then
		JETV=JETV-JETV*0.4 JETVR=JETVR-JETVR*0.4 JETVL=JETVL-JETVL*0.4
	end
	if _KEY(1)>0 then
		JETV=JETV+JETV*0.4 JETVR=JETVR+JETVR*0.8 JETVL=JETVL+JETVL*0.8
	end

	if _KEY(2)>0 then
		JETVLR=JETVLR+10000
		JETVLR2=JETVLR2+10000
	end		
	if _KEY(3)>0 then
		JETVLR=JETVLR-10000
		JETVLR2=JETVLR2-10000
	end
	if _KEY(4)>0 then
		JETVLR=JETVLR+10000
		JETVLR2=JETVLR2-5000
	end
	if _KEY(6)>0 then
		JETVLR=JETVLR-10000
		JETVLR2=JETVLR2+5000			
	end
	if _KEY(2)==0 and _KEY(3)==0 and _KEY(4)==0 and _KEY(6)==0 then
		if math.abs(_VX(C1))>0.5 then
			JETVLR=-10000*_VX(C1)
			JETVLR2=5000*_VX(C1)
		end
		if math.abs(_WY(BODY))>0.5 then
			JETVLR=10000*_WY(BODY)/2
			JETVLR2=5000*_WY(BODY)/2
		end
		if math.abs(_VX(C1))<0.5 and math.abs(_WY(BODY))<0.5 then
			JETVLR=0
			JETVLR2=0
		end
	end
	JETV=hikeolib.limit(JETV,-100000,jetmax*0.413*1.5)
	JETVL=hikeolib.limit(JETVL,-100000,jetmax*0.28*1.5)
	JETVR=hikeolib.limit(JETVR,-100000,jetmax*0.28*1.5)
end

function speed_lim(sp)
	VEL=_VZ(CORE)*-3.6
	tmp_val=sp-VEL
	jetp=hikeolib.pid(2,tmp_val,{4,1,5},{-30,100})
	jetabp=hikeolib.limit(jetp-100,0,40)
	if setlim==1 then
		jetp=hikeolib.limit(jetp,-30,100)
	elseif modem==1 then
		jetp=hikeolib.limit(jetp,-100,400)
	end
	--out(3,string.format("Speed:%d",sp))
end

function jet_ctl()
	if modes==1 then
		if modek<2 or modea==0 then
			speed_lim(speed)
		end
	end
	JET=jetp*700+jetabp*700
end

function ejecter()
	out(0,"Ejecting")
	EJECT2=EJECT2+1
	if EJECT2>=20 then
		dummy=_BYE(BODY)
		dummy=_BYE(FRAME1)
		EJECT=EJECT-5
	end
	if EJECT2>=30 then
		bomax=53.6*_WEIGHT()
		BO=hikeolib.ang(BO,bomax,100)
	end
	if EJECT2==20 then
		EJECTJET=600000
	end
	if EJECT2==5 then
		dummy=_BYE(CANOPY)
	end
	CANGLE3=CANGLE3-20
	if _H(core)>0 and _H(core)<=0.2 and LEN(_VX(core),_VY(core),_VZ(core))<20 then
		dummy=_BYE(BOL)
	end
	if _KEYDOWN(11)>0 and EJECT2>=10 then
		dummy=_BYE(BOL)
	end
end

function Print()
	out(4,string.format("Remaining fuel%2.1f%%",_FUEL(core)/_FUELMAX(core)*100))
	if mode==0 then out(5,"Gear: UP [DOWN]") else out(5,"Gear:[UP] DOWN") end
	if modev==0 then out(6,"VTOL Mode: ON [OFF]") else out(6,"VTOL Mode:[ON] OFF") end
	if modea==0 then out(7,"Auto pilot: ON [OFF]") else out(7,"Auto pilot [ON] OFF") end
	if modek==0 then
		out(8,"[Straight] Circle  Follow  DogFight")
	elseif modek==1 then
		out(8," Straight [Circle] Follow  DogFight")
	elseif modek==2 then
		out(8," Straight  Circle [Follow] DogFight")
	else
		out(8," Straight  Circle  Follow [DogFight]")
	end
	out(9,string.format("X=%2.1f Y=%2.1f Z=%2.1f",_X(CORE),_Y(CORE),_Z(CORE)))
	out(10,string.format("Seting altitude:%2.2f",tmp_alt))
	out(11,string.format("Flight distance%.2fkm",length/1000))
	out(9,string.format("%2.1fG",G))
	out(12,string.format("X=%.2f Y=%.2f Z=%.2f",_X(),_Y(),_Z()))
end

function secret()
	out(0,"FPS=",_FPS())
	out(11,"press D")
	local l=5
	if _KEYDOWN(0)>0 then
		setting[1]=selecter(setting[1]-1,l-1)
	end
	if _KEYDOWN(1)>0 then
		setting[1]=selecter(setting[1]+1,l-1)
	end
	if _KEYDOWN(9)>0 then
		modeset=0
	end
	local str={" "," "}
	if setting[1]==0 then
		if _KEYDOWN(3)>0 then
			limitG=limitG+1
		end
		if _KEYDOWN(2)>0 then
			limitG=limitG-1
		end
		limitG=hikeolib.limit(limitG,0,100)
		str={"<",">"}
	end
	out(1,str[1].."limitG="..limitG..str[2])
	str={" "," "}
	if setting[1]==1 then
		if _KEYDOWN(3)>0 then
			setting[2]=setting[2]+1
		end
		if _KEYDOWN(2)>0 then
			setting[2]=setting[2]-1
		end
		setting[2]=hikeolib.limit(setting[2],0,7)
		formationName=formation.name[setting[2]]
		str={"<",">"}
	end
	out(2,str[1].."formation:"..formation.name[setting[2]]..str[2])
	str={" "," "}
	if setting[1]==2 then
		if _KEYDOWN(3)>0 then
			formationNumber=formationNumber+1
		end
		if _KEYDOWN(2)>0 then
			formationNumber=formationNumber-1
		end
		formationNumber=hikeolib.limit(formationNumber,2,5)
		str={"<",">"}
	end
	out(3,str[1].."formationNo:"..formationNumber..str[2])
	str={" "," "}
	if setting[1]==3 then
		if _KEYDOWN(12)>0  then
			sminov=1-sminov
			if sminov==1 then
				sminov_init()
			else
				dWindow:Destroy()
				Rader:Destroy()
			end
		end
		str={"<",">"}
	end
	local str2={"OFF","ON"}
	out(4,str[1].."Sminov:"..str2[sminov+1]..str[2])
	
	str={" "," "}
	if setting[1]==4 then
		if _KEYDOWN(3)>0 then
			hudlevel=hudlevel+1
		end
		if _KEYDOWN(2)>0 then
			hudlevel=hudlevel-1
		end
		hudlevel=hikeolib.limit(hudlevel,0,2)
		str={"<",">"}
	end
	local str2={"OFF","ON"}
	out(5,str[1].."HUD_Level:"..hudlevel..str[2])
end
