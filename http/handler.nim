import std/jsonutils
import std/[strtabs,json]
import std/asynchttpserver
import std/asyncdispatch
import ../util/entity
import ../util/service
type
   HttpHandler* = object

var reqBody: JsonNode

proc htmlHandler*(req: Request, html: string) {.async.} =
 let headers = {"Content-type": "text/html; charset=utf-8"}
 await req.respond(Http200, html, headers.newHttpHeaders())
	
proc jsonHandler*(req: Request, items: JsonNode) {.async.} =
 let headers = newHttpHeaders([("Content-Type","application/json")])
 await req.respond(Http200, $(items), headers)
 
proc bodyMapper*(req: Request, body: string): JsonNode =
 var namesValues: seq[string] = body.split('&')
 var mapper = newStringTable()
 for kv in namesValues:
  let namesValuesArray: seq[string] = kv.split('=')
  echo namesValuesArray
  mapper[$namesValuesArray[0]] = $namesValuesArray[1]
 reqBody = parseJson($mapper)

proc redirectTo*(url:string) =
 try:
  client.request(url, httpMethod = HttpGet, body = "")
 finally:
  client.close()

template get*(filename: untyped, find: untyped) =
 var filename: string
 proc find(): seq[JsonNode] =
  #call the entity
  service.get()

template getById*(filename: untyped, findById: untyped) =
 var filename: string
 proc findById(obj: var Entity): JsonNode =
  service.getById(filename, obj)

template edit*(filename: untyped, update: untyped) =
 var filename: string
 proc update(obj: var Entity) =
  util.edit(filename, obj)

template create*(filename: untyped, save: untyped) =
 var filename: string
 proc save(obj: var Entity) =
  service.edit(filename, obj)

template delete*(filename: untyped, remove: untyped) =
 var filename: string
 proc remove(obj: var Entity) =
  service.edit(filename, obj)

#cast[proc () {.nimcall.}](find) 