-- cheat-works by variable
-- includes:
-- chams, aim-assist, esp, full brightness, snapline/wiring

local plr = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- toggling bools

local botting = false
local esp = false
local chamstog = false
local brightness = false
local wire = false

-- util

function findTorso(position)
	local torso
	local dist = 999999999
	for _,v in pairs (game.Players:GetChildren()) do
		if v.TeamColor ~= plr.TeamColor then
			if v.Character then
				local t = v.Character:FindFirstChild('Head')
				if t then
					if (t.Position - position).magnitude < dist then
						if v.Character.Humanoid.Health > 0 then
							torso = t
							dist = (t.Position - position).magnitude
						end
					end
				end
			end
		end
	end
	return torso
end

function chams(part, color, trans, name)
	local box = Instance.new("BoxHandleAdornment", camera)
	box.Adornee = part
	box.Size = part.Size
	box.Color3 = color
	box.Transparency = trans
	box.ZIndex = 1
	box.Name = name
	box.AlwaysOnTop = true
end

function generateBox(Target,Color) -- thx KrystalTeam
	local Ae,Be,Ce,De,Ee,Fe,Ge 
	Ae=Instance.new("BillboardGui",camera) 
	Ae.Name = "EspBox" 
	Ae.Size = UDim2.new(4.5,0,6,0) 
	Ae.Adornee = Target 
	Ae.AlwaysOnTop = true 
	Ae.SizeOffset = Vector2.new(0, -0.100000001) 
	Be=Instance.new("Frame",Ae) 
	Be.Transparency = 1 Be.Size = UDim2.new(1,0,1,0) 
	Ce=Instance.new("Frame",Ae) 
	Ce.Transparency = 0.5 
	Ce.Size = UDim2.new(1,0,0.05, 0) 
	Ce.BorderSizePixel = 0 
	Ce.BackgroundColor3 = Color 
	De=Ce:clone() 
	De.Size = UDim2.new(0.05,0,1, 0) 
	De.Parent = Ae 
	Ee=De:clone() 
	Ee.Position = UDim2.new(1-0.05,0,0, 0) 
	Ee.Parent = Ae 
	Fe=Ce:clone() 
	Fe.Position = UDim2.new(0,0,1-0.05, 0) 
	Fe.Parent = Ae 
end

function wirePlr(to, color)
	local wire = Instance.new('FloorWire', camera)
	wire.Color3 = color
	wire.From = plr.Character.Torso
	wire.To = to
end

-- main shtuff

function chamsAll() 
	for _,v in pairs (game.Players:GetChildren()) do
		if v.Name ~= plr.Name then
			if v.TeamColor ~= plr.TeamColor then
				if v.Character then
					for _,obj in pairs (v.Character:GetChildren()) do
						if obj:IsA('Part') then
							chams(obj, Color3.new(1,0,0), 0.3, v.Name.."'s "..obj.Name)
						end
					end
				end
			else
				if v.Character then
					for _,obj in pairs (v.Character:GetChildren()) do
						if obj:IsA('Part') then
							chams(obj, Color3.new(0,1,0), 0.3, v.Name.."'s "..obj.Name)
						end
					end
				end
			end
		end
	end
end

function espAll()
	for _,v in pairs (game.Players:GetChildren()) do
		if v.Name ~= plr.Name then
			if v.TeamColor == plr.TeamColor then
				if v.Character then
					generateBox(v.Character.Torso, Color3.new(0,1,0))
				end
			else
				if v.Character then
					generateBox(v.Character.Torso, Color3.new(1,0,0))
				end
			end
		end
	end
end

function wireAll()
	for _,v in pairs (game.Players:GetChildren())do
		if v.Name ~= plr.Name then
			if v.TeamColor ~= plr.TeamColor then
				if v.Character then
					wirePlr(v.Character.Torso, Color3.new(1,0,0))
				end
			else
				if v.Character then
					wirePlr(v.Character.Torso, Color3.new(0,1,0))
				end
			end
		end
	end
end

function removeChams()
	for _,v in pairs (camera:GetChildren()) do
		if v:IsA('BoxHandleAdornment') then
			v:Destroy()
		end
	end
end

function removeEsp()
	for _,v in pairs (camera:GetChildren()) do
		if v:IsA('BillboardGui') then
			v:Destroy()
		end
	end
end

function removeWire()
	for _,v in pairs (camera:GetChildren()) do
		if v:IsA('FloorWire') then
			v:Destroy()
		end
	end
end

function startAiming()
	spawn(function()
		while wait(0) do
			if botting then
				while wait(0.2) do
					if botting then
						local torso = findTorso(plr.Character.Torso.Position)
						if torso then
							plr.Character.Torso.CFrame = CFrame.new(plr.Character.Torso.Position, torso.Position)
   							camera.CFrame = CFrame.new(plr.Character.Torso.Position, torso.Position)
						end
					elseif not botting then
						return
					end
				end
			end
		end
	end)
end

-- toggle handling functions

function wireToggle(aname, ainputstate)
	if ainputstate == Enum.UserInputState.Begin then
		if not wire then
			print'[wire]: true'
			wireAll()
			wire = true
		else
			removeWire()
			wire = false
			print'[wire]: false'
		end
	end
end

function brightToggle(aname, ainputstate)
	if ainputstate == Enum.UserInputState.Begin then
		if not brightness then
			print'[full bright]: true'
			game.Lighting.Brightness = 50
			brightness = true
		else
			game.Lighting.Brightness = 1
			brightness = false
			print'[full bright]: false'
		end
	end
end

function espToggle(aname, ainputstate)
	if ainputstate == Enum.UserInputState.Begin then
		if not esp then
			print'[esp]: true'
			espAll()
			esp = true
		else
			removeEsp()
			esp = false
			print'[esp]: false'
		end
	end
end

function chamsToggle(aname, ainputstate)
	if ainputstate == Enum.UserInputState.Begin then
		if not chamstog then
			chamsAll()
			chamstog = true
			print'[chams]: true'
		else
			removeChams()
			chamstog = false
			print'[chams]: false'
		end
	end
end

function aimToggle(aname, ainputstate)
	if ainputstate == Enum.UserInputState.Begin then
		if not botting then
			botting = true
			print'[aim-assist]: true'
			startAiming()
		else
			botting = false
			print'[aim-assist]: false'
		end
	end
end

spawn(function()
game:service'ContextActionService':BindAction("wire_toggling", wireToggle, false, Enum.KeyCode.F6)
game:service'ContextActionService':BindAction("brightness_toggling", brightToggle, false, Enum.KeyCode.F5)
game:service'ContextActionService':BindAction("chams_toggling", chamsToggle, false, Enum.KeyCode.F4)
game:service'ContextActionService':BindAction("esp_toggling", espToggle, false, Enum.KeyCode.F3)
game:service'ContextActionService':BindAction("aim_toggling", aimToggle, false, Enum.KeyCode.F2) end)
