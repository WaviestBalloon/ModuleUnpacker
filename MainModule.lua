-- Waviest's Unpacker © 2022 by WaviestBalloon is licensed under CC BY-SA 4.0

local print = function(_) print("[Module Unpacker] ".. tostring(_)) end
local error = function(_, level) if level == nil then level = 0 end error("[Unpacker] ".. tostring(_), level) end
local warn = function(_) warn("[Module Unpacker] ".. tostring(_)) end

local module = {}

function module.unpack(player)
	print("Starting (Version 2)")
	local unpackcompleted = false
	print("Vaildating player")
	if player == nil or player == "" then
		return error("Failed to unpack! No player was specified, you need to enter your real username, not your displayname\nExample: require(<ID>).unpack(<YOUR USERNAME>)")
	else
		if game.Players:FindFirstChild(player) == nil then
			return error("Failed to unpack! No player was found (NOT SPECIFIED), you need to enter your real username, not your displayname\nExample: require(<ID>).unpack(<YOUR USERNAME>)")
		end
	end
	print("Checking if all Scripts are disabled")
	for _, v in pairs(script:GetDescendants()) do
		if v:IsA("Script") or v:IsA("LocalScript") and v.Disabled == false then
			print("The script '".. v.Name .."' is enabled, it has been disabled for now, it will be re-enabled after unpack completes to avoid Scripts from erroring")
			v.Disabled = true
			spawn(function()
				repeat wait() until unpackcompleted == true
				print("Re-enabling Script: '".. v.Name .. "'")
				v.Disabled = false
			end)
		end
	end
	print("Getting ready to move ".. #script:GetDescendants() .." objects")
	print("Unpacking...")

	for _, v in	pairs(script:GetChildren()) do
		local location = v.Name
		for _, v in pairs(v:GetChildren()) do
			if location == "PlayerTool" then
				print("Cloning tool to specified player backpack: ".. v.Name)
				local clone = v:Clone()
				clone.Parent = game.Players:FindFirstChild(player).Backpack
			else
				print("Moving ".. v.Name .." -> game.".. location)
				local completed, err = pcall(function()
					--local clone = v:Clone()
					--clone.Parent = game[location]
					if game[location]:FindFirstChild(v.Name) then
						warn("Conflict! Unable to unpack '".. v.Name .."' because it already exists, this object has been skipped")
					else
						v.Parent = game[location]
					end
				end)
				if not completed then
					warn("Unable to clone ".. v.Name .." into game.".. location .."\nDid you spell the folder incorrectly?\nDetails: ".. err)
				end
			end
		end
	end

	unpackcompleted = true
	print("Finished! Thank you for using my unpacker\nGitHub: https://github.com/WaviestBalloon/ModuleUnpacker")
end

return module
