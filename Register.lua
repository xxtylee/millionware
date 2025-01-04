local Typeface = {  }

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
Typeface.Typefaces = {  }
Typeface.WeightNum = { 
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
function Typeface:RequestFile(URL)
	local Response = request{Url = URL, Method = "GET"}

	assert(Response.StatusCode == 200, `[ Typeface Registration ] Content Error! : { Response.StatusCode }`)

    return Response.Body
end

function Typeface:Writeface(Directory, File)
    File = Http:JSONEncode(File)


    writefile(Directory, File)
end

function Typeface:Register(Path, Asset)
	Asset = Asset or {}

    Asset.weight = Asset.weight or "Regular"
    Asset.style = Asset.style or "Normal"

    assert(Asset.link, `[ Typeface Registration ] "link" is required to Register a Typeface!`)
    assert(Asset.name, `[ Typeface Registration ] "name" is required to Register a Typeface!`)

	local Directory = `{ Path or "" }\\{ Asset.name }`

    local Weight = Typeface.WeightNum[Asset.weight] == 400 and "" or Asset.weight
    local Style = string.lower(Asset.style) == "normal" and "" or Asset.style
	local Name = `{ Asset.name }{ Weight }{ Style }`

    local Registered = false
    local JSONFile, Data

    if not isfolder(Directory) then
        makefolder(Directory)
    end

    if not isfile(`{ Directory }\\{ Name }.font`) then
        local Response = Typeface:RequestFile(Asset.link)
        
        if not Response then return end

        writefile(`{ Directory }\\{ Name }.font`, Response)
	end

    if isfile(`{ Directory }\\{ Asset.name }Families.json`) then 
        Data = { 
            name = `{ Asset.weight } { Asset.style }`,
            weight = Typeface.WeightNum[Asset.weight] or Typeface.WeightNum[string.gsub(Asset.weight, "%s+", "")],
            style = string.lower(Asset.style),
            assetId = getcustomasset(`{ Directory }\\{ Name }.font`)
		}

        JSONFile = Http:JSONDecode(readfile(`{ Directory }\\{ Asset.name }Families.json`))

        for _, face in JSONFile.faces do
            if face.name == Data.name then Registered = true break end
        end

        if not Registered then
            table.insert(JSONFile.faces, Data)

            Typeface:Writeface(`{ Directory }\\{ Asset.name }Families.json`, JSONFile)
            warn(`[ Typeface Registration ] Registering { Asset.weight } { Asset.style } Typeface to "{ Directory }"...`)
        end
	else
		Data = { 
			name = `{ Asset.weight } { Asset.style }`,
			weight = Typeface.WeightNum[Asset.weight] or Typeface.WeightNum[string.gsub(Asset.weight, "%s+", "")],
			style = string.lower(Asset.style),
			assetId = getcustomasset(`{ Directory }\\{ Name }.font`)
		}

		Typeface:Writeface(`{ Directory }\\{ Asset.name }Families.json`, { name = Name, faces = { Data } })
        warn(`[ Typeface Registration ] Registering { Asset.name } Typeface to "{ Path }"...`)
	end

	Typeface.Typefaces[Name] = Typeface.Typefaces[Name] or Font.new(getcustomasset(`{ Directory }\\{ Asset.name }Families.json`))
    return Typeface.Typefaces[Name]
end

return Typeface
