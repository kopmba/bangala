import std/asynchttpserver
import std/asyncdispatch
import ../server/handler

proc render*(req: Request, html: string){.async.} =
 handler(req, html)

proc json*(req: Request, items: JsonNode){.async.} =
    handler(req, items)