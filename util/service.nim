import std/jsonutils
import std/[strtabs,json]
import std/syncio
from std/strutils import parseInt
import entity

var jsonObj: JsonNode
var jsonArray: seq[JsonNode]
var obj: Entity
var list: seq[JsonNode]

proc objToJson*(obj: var Entity): string = 
	jsonObj = obj.toJson

proc parse*(json: string): JsonNode = 
	jsonObj = parseJson(json)

proc datalist*(json: string): seq[JsonNode] = 
	jsonArray = getElems(parseJson(json))

proc unmarshall*(parseJson: JsonNode, e: var Entity): Entity = 
	to(parseJson, Entity)

proc create*(e: var Entity, filename: string) =
    let json = readFile(filename)
    list = datalist(json)
    list.add(user)
    writeFile(filename, $(list))

proc edit*(edited: var Entity, filename: string) =
    let json = readFile(filename)
    list = datalist(json)
	var newList: seq[JsonNode] = @[]
    for node in list:
		obj = unmarshall(node, Entity)
        if obj.id == edited.id:
            newList.add(edited.toJson)
		else:
			newList.add(node)
    writeFile(filename, $(newList))

proc get*(filename: string): seq[JsonNode] =
    let json = readFile(filename)

    list = datalist(json)

proc getById*(need: var Entity, filename: string): JsonNode =
    let json = readFile(filename)

    list = datalist(json)

    for node in list:
        obj = unmarshall(node, Entity)

        if obj.username != "" and obj.username == need.username:
            jsonObj = obj

        if obj.id == parseInt(need.id):
            jsonObj = obj

proc delete*(need: var Entity, filename: string) =
    let json = readFile(filename)
    list = datalist(json)
    let newList: seq[JsonNode] = @[]
    for node in list:
		obj = unmarshall(node, Entity)
        if obj.id != need.id:
            newList.add(node)

    writeFile(filename, $(newList))