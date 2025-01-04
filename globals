local global = {}

-- Environment check
request 		= request
cloneref 		= cloneref or function(service) return service end
identifyexecutor	= identifyexecutor or function() return "Unidentified" end

listfiles 		= assert(listfiles, `[WARN] { identifyexecutor() } Executor incompatible!`)

isfile 			= assert(isfile, `[WARN] { identifyexecutor() } Executor incompatible!`)
writefile 		= assert(writefile, `[WARN] { identifyexecutor() } Executor incompatible!`)
readfile 		= assert(readfile, `[WARN] { identifyexecutor() } Executor incompatible!`)
loadfile 		= assert(loadfile, `[WARN] { identifyexecutor() } Executor incompatible!`)
delfile 		= assert(delfile, `[WARN] { identifyexecutor() } Executor incompatible!`)

isfolder 		= assert(isfile, `[WARN] { identifyexecutor() } Executor incompatible!`)
makefolder 		= assert(makefolder, `[WARN] { identifyexecutor() } Executor incompatible!`)
delfolder 		= assert(delfolder, `[WARN] { identifyexecutor() } Executor incompatible!`)

gethui			= gethui or function() return global.core end

-- Custom function
global.tbl = function(...) 
	return {...} 
end

global.propercase = function(str)
	return global.upper(global.sub(str, 1, 1)) .. global.sub(str, 2, -1)
end

global.service = function(service) 
	return cloneref(game:GetService(service)) 
end

global.equipmeta = function(tbl, newmeta)
	return global.setmeta(tbl, global.getmeta(newmeta))
end

global.concat = function(tbl, str)
	return global.length(tbl) > 0 and global.catenate(tbl, str)
end

global.identify = function()
	return global.run:IsStudio() and "Studio" or identifyexecutor()
end

global.round = function(num, float) 
	return global.num(global.format("%.14g", float * global.approx(num / float))) 
end

global.abc = function(a, b) 
	return global.sfind(global.alphabet(), global.sub(a, 1, 1)) <  global.sfind(global.alphabet(), global.sub(b, 1, 1)) 
end

global.gethsv = function(color)
	local h, s, v = color:ToHSV()

	return {hue = h, sat = s, val = v}
end

global.alphabet = function()
	local abc = "abcdefghijklmnopqrstuvwxyz"
	
	return global.upper(abc) .. abc
end

global.search = function(tbl, value)
	for index, val in tbl do
		if val == value then return index end
	end
end

global.getcontrols = function()
	local module = global.client.PlayerScripts:FindFirstChild("PlayerModule")
	
	assert(module, "Player Module not found!")
	
	return require(module):GetControls()
end

global.declare = function(default, value)
	if value ~= nil then
		return value
	end

	return default
end

global.json = function(_type, ...)
	_type = global.lower(_type)

	if not global.tfind({"encode", "decode"}, _type) then return end

	return global.http["JSON".. global.propercase(_type)](global.http, ...)
end

global.clean = function(tbl, value)
	local index = global.tfind(tbl, value)

	if index then
		global.remove(tbl, index)
	end
	
	return index
end

global.table = function(dict)
	local tbl = {}

	for _, value in dict do
		global.insert(tbl, value)
	end

	return tbl
end

global.thread = function(func)
	local thread = function(...)
		local args = ...

		global.call(function() func(args) end)
	end

	return thread
end

global.request = function(info) 
	if request then return request(info) end
	
	info = type(info) == "table" and info or {Url = info}
	info.Success, info.StatusMessage = global.pcall(function() info.Body = game:HttpGet(info.Url) end)
	info.StatusCode = info.Success and 200 or 400
	
	return info
end

global.length = function(dict, key)
	if type(dict) == "string" then return global.slen(dict) end
	
	local length = 0

	for index, _ in dict do
		if not key then 
			length += 1
			continue
		end

		if global.sfind(index, key) then 
			length += 1
		end
	end

	return length
end

-- Service
global.repstorage = global.service "ReplicatedStorage"
global.userinput = global.service "UserInputService"
global.content = global.service "ContentProvider"
global.tween = global.service "TweenService"
global.http = global.service "HttpService"
global.run = global.service "RunService"
global.plrs = global.service "Players"
global.core = global.service "CoreGui"

global.hui = gethui()

-- Instances
global.client = global.plrs.LocalPlayer
global.plrgui = global.client.PlayerGui
global.camera = workspace.CurrentCamera

-- Modules
global.require = require

-- Type convert
global.str = tostring
global.num = tonumber

-- Thread
global.pcall = pcall
global.wcall = task.delay
global.call = task.spawn

global.wait = task.wait
global.tick = os.clock

-- Type check
global.is = type
global.isa = typeof

-- Table
global.catenate = table.concat
global.remove = table.remove
global.insert = table.insert
global.unpack = table.unpack
global.tfind = table.find
global.sort = table.sort

-- String
global.format = string.format
global.match = string.match
global.upper = string.upper
global.lower = string.lower
global.sfind = string.find
global.gsub = string.gsub
global.sub = string.sub
global.slen = string.len

-- Meta-table
global.setmeta = setmetatable
global.getmeta = getmetatable

global.valget = rawget
global.valset = rawset

-- Math
global.max = math.max
global.min = math.min
global.clamp = math.clamp
global.approx = math.round

-- Data-type
global.hsv = Color3.fromHSV
global.hex = Color3.fromHex
global.rgb = Color3.fromRGB

global.rgbkey = ColorSequenceKeypoint.new
global.rgbseq = ColorSequence.new

global.numkey = NumberSequenceKeypoint.new
global.numseq = NumberSequence.new

global.dim2 = UDim2.new
global.dim = UDim.new

global.vec2 = Vector2.new
global.rect = Rect.new

global.enum = Enum

if global.tfind({gethui(), gethui().Parent}, global.core) then warn(`[WARN] { identifyexecutor() } Executor may be detected!`) end

return global
