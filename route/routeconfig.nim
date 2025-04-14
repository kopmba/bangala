from std/strutils import split, join
import router
import std/asynchttpserver
import std/registry
type
   RouteConfig* = object
      routeList* : seq[router.Route]
      req*: Request

var param*: string
var sessionUser*: string
var params*: seq[string]
var session*: string
var reqRoute: router.Route

proc routes*(self: var RouteConfig): seq[router.Route] =
  routeList = self.routeList

proc get*(url: string, domain: string, req: Request, self: var RouteConfig): router.Route =
 if self.routeList.len > 0:
  for r in self.routeList:
   var arrayPath: seq[string] = r.path.split('/')
   let arrayUrl = url.split('/')
   let count = arrayPath.len
   var npath: seq[string] = @[]
   var newPath = ""
   if count > 0:
    let i = count - 1
    npath.add(arrayPath[0..i-1])
    npath.add(arrayUrl[arrayUrl.len-1])
    echo npath
    newPath.add(domain)
    #echo npath.join('/')
    let opath = npath.join("/")
    newPath.add(opath)
    echo newPath
    if url == newPath:
     reqRoute = r

proc getParam*(url: string) =
  let arrayUrl = url.split('/')
  param = arrayUrl[arrayUrl.len-1]

proc getSessionParam*(url: string) =
  let arrayUrl = url.split("=")
  session = arrayUrl[1]

proc newSession(username: string) = setUnicodeValue("Environment", "user_key", username, registry.HKEY_CURRENT_USER)

proc getSession(): string = getUnicodeValue("Environment", "user_key", registry.HKEY_CURRENT_USER)

