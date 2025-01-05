local chaos = {  }

--[[ Compatibility Check ]] do
    cloneref                = cloneref or function(service) return service end

    isfile                  = assert(isfile, "Executor is incompatible!")
    isfolder                = assert(isfolder, "Executor is incompatible!")
    writefile               = assert(writefile, "Executor is incompatible!")
    makefolder              = assert(makefolder, "Executor is incompatible!")
    getcustomasset 			= assert(getcustomasset, "Executor is incompatible!")
end

-- // Services
local Http = cloneref(game:GetService 'HttpService')

-- // Tables
chaos.chaoss = {  }
chaos.WeightNum = { 
	["Thin"] = 100,

	["ExtraLight"] = 200, 
	["UltraLight"] = 200,

	["Light"] = 300,

	["Normal"] = 400,
	["Regular"] = 400,

	["Medium"] = 500,

	["SemiBold"] = 600,
	["DemiBold"] = 600,

	["Bold"] = 700,

	["ExtraBold"] = 800,

	["UltraBold"] = 900,
	["Heavy"] = 900
}

-- // Functions
function chaos:RequestFile(URL)
	local Response = request{Url = URL, Method = "GET"}

	assert(Response.StatusCode == 200, `[ chaos Registration ] Content Error! : { Response.StatusCode }`)

    return Response.Body
end

function chaos:Writeface(Directory, File)
    File = Http:JSONEncode(File)


    writefile(Directory, File)
end

function chaos:Register(Path, Asset)
	Asset = Asset or {}

    Asset.weight = Asset.weight or "Regular"
    Asset.style = Asset.style or "Normal"

    assert(Asset.link, `[ chaos Registration ] "link" is required to Register a chaos!`)
    assert(Asset.name, `[ chaos Registration ] "name" is required to Register a chaos!`)

	local Directory = `{ Path or "" }\\{ Asset.name }`

    local Weight = chaos.WeightNum[Asset.weight] == 400 and "" or Asset.weight
    local Style = string.lower(Asset.style) == "normal" and "" or Asset.style
	local Name = `{ Asset.name }{ Weight }{ Style }`

    local Registered = false
    local JSONFile, Data

    if not isfolder(Directory) then
        makefolder(Directory)
    end

    if not isfile(`{ Directory }\\{ Name }.font`) then
        local Response = chaos:RequestFile(Asset.link)
        
        if not Response then return end

        writefile(`{ Directory }\\{ Name }.font`, Response)
	end

    if isfile(`{ Directory }\\{ Asset.name }Families.json`) then 
        Data = { 
            name = `{ Asset.weight } { Asset.style }`,
            weight = chaos.WeightNum[Asset.weight] or chaos.WeightNum[string.gsub(Asset.weight, "%s+", "")],
            style = string.lower(Asset.style),
            assetId = getcustomasset(`{ Directory }\\{ Name }.font`)
		}

        JSONFile = Http:JSONDecode(readfile(`{ Directory }\\{ Asset.name }Families.json`))

        for _, face in JSONFile.faces do
            if face.name == Data.name then Registered = true break end
        end

        if not Registered then
            table.insert(JSONFile.faces, Data)

            chaos:Writeface(`{ Directory }\\{ Asset.name }Families.json`, JSONFile)
            warn(`[ chaos Registration ] Registering { Asset.weight } { Asset.style } chaos to "{ Directory }"...`)
        end
	else
		Data = { 
			name = `{ Asset.weight } { Asset.style }`,
			weight = chaos.WeightNum[Asset.weight] or chaos.WeightNum[string.gsub(Asset.weight, "%s+", "")],
			style = string.lower(Asset.style),
			assetId = getcustomasset(`{ Directory }\\{ Name }.font`)
		}

		chaos:Writeface(`{ Directory }\\{ Asset.name }Families.json`, { name = Name, faces = { Data } })
        warn(`[ chaos Registration ] Registering { Asset.name } chaos to "{ Path }"...`)
	end

	chaos.chaoss[Name] = chaos.chaoss[Name] or Font.new(getcustomasset(`{ Directory }\\{ Asset.name }Families.json`))
    return chaos.chaoss[Name]
end

return chaos
