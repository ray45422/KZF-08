function Plane()
	if mode==0 and _KEY(2)==0 and _KEY(3)==0 then
		if _H(core)<10 and _H(core)>=0 then
			hikeolib.pid_reset(2)
		end
	end
	if modem==0 then
		if _KEY(0)>0 then 
			ANGLE1=ANGLE1+2
			ANGLE4=ANGLE4+2
			ANGLE5=ANGLE5+2
			if _KEY(2)==0 and _KEY(3)==0 then
				JANG1=JANG1+2 JANG1L=JANG1L+2
			end
		end
		if _KEY(1)>0 then
			ANGLE1=ANGLE1-2
			ANGLE4=ANGLE4-2
			ANGLE5=ANGLE5-2
			if _KEY(2)==0 and _KEY(3)==0 then
				JANG1=JANG1-2 JANG1L=JANG1L-2
			end
		end
		if _KEY(2)>0 then
			ANGLE2=ANGLE2+2 ANGLE3=ANGLE3+2 JANG1=JANG1+2 JANG1L=JANG1L-2
		end
		if _KEY(3)>0 then
			ANGLE2=ANGLE2-2 ANGLE3=ANGLE3-2 JANG1=JANG1-2 JANG1L=JANG1L+2
		end
		if _KEY(4)>0 then
			if mode==1 then
				JANG2=JANG2-2
				ANGLE4=ANGLE4+2
				ANGLE5=ANGLE5-2
			else
				JANG2=-2
				--GANG5=GANG5-1
				GANG5=hikeolib.ang(GANG5,-v/10,math.min(v/100,1))
			end
		end
		if _KEY(6)>0 then
			if mode==1 then
				JANG2=JANG2+2
				ANGLE4=ANGLE4-2
				ANGLE5=ANGLE5+2
			else
				JANG2=2
				--GANG5=GANG5+1
				GANG5=hikeolib.ang(GANG5,v/10,math.min(v/100,1))
			end
		end
		if _KEY(1)>0 and _KEY(2)>0 and _KEY(3)>0 then 
			JANG1=JANG1-2 JANG1L=JANG1L-2 ANGLE2=ANGLE2-5 ANGLE3=ANGLE3+5
		else
			if math.abs(ANGLE4)<=12 then
				ANGLE4=hikeolib.limit(ANGLE4,-10,10)
			end
			if math.abs(ANGLE5)<=12 then
				ANGLE5=hikeolib.limit(ANGLE5,-10,10)
			end
			if math.abs(JANG1-120)<=12 then
				JANG1=hikeolib.limit(JANG1,110,130)
			end
			if math.abs(JANG1L-120)<=12 then
				JANG1L=hikeolib.limit(JANG1L,110,130)				
			end
		end
	else
		local v1
		if _H(core)<10 and _H(core)>=0 and mode==0 and _VZ()>-55 then
			v1=20
		else
			if _VZ()*-3.6<600 then
				v1=v*hikeolib.limit(math.abs(70/_VZ()),1,2)
			else
				v1=v/math.abs(_VZ()/200)
			end
		end
		local v2=v1
		local vstep=math.min(v1/10,2)
		if G<=-limG/3 or G>=limG then
			v2=hikeolib.ang(v2,0,1)
		end
		if _KEY(0)>0 then
			ANGLE1=hikeolib.ang(ANGLE1,v2,vstep)
			if v2>40 then
				JANG1=hikeolib.ang(JANG1,120+(v2-40),vstep)
				JANG1L=JANG1
			else
				JANG1=hikeolib.ang(JANG1,120,4)
				JANG1L=JANG1
			end
		end
		if _KEY(1)>0 then
			ANGLE1=hikeolib.ang(ANGLE1,-v2,vstep)
			if v2>40 then
				JANG1=hikeolib.ang(JANG1,120-(v2-40),vstep)
				JANG1L=JANG1
			else
				JANG1=hikeolib.ang(JANG1,120,4)
				JANG1L=JANG1
			end
		end
		if _KEY(2)>0 then
			ANGLE2=hikeolib.ang(ANGLE2,v1*3,vstep) ANGLE3=hikeolib.ang(ANGLE3,v1*3,vstep)
		end
		if _KEY(3)>0 then
			ANGLE2=hikeolib.ang(ANGLE2,-v1*3,vstep) ANGLE3=hikeolib.ang(ANGLE3,-v1*3,vstep)
		end
		if _KEY(4)>0 then
			if mode==1 then
				JANG2=hikeolib.ang(JANG2,-v1,vstep)
			else
				JANG2=-2
				--GANG5=GANG5-1
				GANG5=hikeolib.ang(GANG5,-v/10,math.min(v/100,1))
			end
		end
		if _KEY(6)>0 then
			if mode==1 then
				JANG2=hikeolib.ang(JANG2,v1,vstep)
			else
				JANG2=2
				--GANG5=GANG5+1
				GANG5=hikeolib.ang(GANG5,v/10,math.min(v/100,1))
			end
		end
	end
	angle1_tmp=0
	angle2_tmp=0
	angle3_tmp=0
	if _KEY(0)==0 and _KEY(1)==0 and _KEY(2)==0 and _KEY(3)==0 and modea==0 and modeap==1 then
		angle1_tmp=hikeolib.pid(3,core_m.wx,{1,0,0.1},{-10,10})
		angle2_tmp=hikeolib.pid(4,_WZ(WINGR1),{1,0,0.1},{-10,10})
		angle3_tmp=hikeolib.pid(5,_WZ(WINGL1),{1,0,0.1},{-10,10})
	end
	if _KEY(4)>0 or _KEY(6)>0 then
		keylong.y=keylong.y+1
	end
	if _KEY(4)==0 and _KEY(6)==0 and (modea==0 or modek==0) and modeap==1 then
		--jang2_tmp=hikeolib.pid(8,_WY(CORE),{1,0,1},{-10,10})
		if keylong.y==0 then
			jang2_tmp=hikeolib.pid(8,core_m.wy,{1,0.1,1},{-10,10})
		else
			jang2_tmp=hikeolib.pid(8,core_m.wy,{1,0,1},{-10,10})
		end
		keylong.y=math.max(keylong.y-1,0)
	else
		jang2_tmp=0
		hikeolib.pid_reset(8)
	end
	ANGLE1=ANGLE1+angle1_tmp
	ANGLE2=ANGLE2+angle2_tmp
	ANGLE3=ANGLE3+angle3_tmp
	JANG2=JANG2-jang2_tmp
	if mode==0 and _KEY(16)>0 and _H(0)<2 and _H(0)>=0 and -_VZ()<10 then
		ANGLE1_2=ANGLE1_2+5
	else
		ANGLE1_2=hikeolib.ang(ANGLE1_2,ANGLE1,5)
	end
end

function ABalancer(c)
	local tmp_a1, tmp_a2
	if _KEYDOWN(14)>0 or _KEY(0)>0 or _KEY(1)>0 then
		tmp_alt=_Y(CORE)
	end
	tmp_a1=_Y(CORE)-tmp_alt
	tmp_a2=hikeolib.pid(1,tmp_a1-5,{0.2,0,4},{-1,1})
	if c==1 then
		--JANG2=v/5
		ANGLE4=-v
		ANGLE5=v
	else
		--JANG2=0
		ANGLE4=0
		ANGLE5=0
	end
	ANGLE2=-_AZ(CORE)*5 ANGLE3=-_AZ(CORE)*5
	
	local v=math.abs((6+_VZ()/28))/2
	local ang=tmp_a2+_AX(CORE)*10
	if _VZ()*-3.6>500 then
		ang=tmp_a2+_AX(CORE)
		v=10
	end
	ANGLE1=hikeolib.ang(ANGLE1,ang,v/10)
	if math.abs(tmp_a1)>100 then
		modes=1
		speed=300
		modek=1
	end
	if _KEYDOWN(14)>0 then
		for i=1,8 do
			pid_reset(i)
		end
	end
end