<div align="center" style="display:grid;place-items:center;">

<h1>Bangala</h1>

</div>

## About

Bangala is a small library to create a small web application with nim using MVC

### How to use it ?

- Create model

```bash
import ../bangala/util/entity
type User* = object of Entity
    username*: string
    password*: string
```

- Create a controller specification methods
```bash
import ../bangala/http/handler
proc index*(req: Request): handler.HttpHandler =
 echo "Index page"
```

- Configure the router
```bash
import ../bangala/route/router
import ../bangala/route/routeconfig
proc routeBuilder*(conf: var routeconfig.RouteConfig): seq[router.Route] =
 var routes: seq[router.Route] = @[]
 routes.add(router.Route(path: "/", handler: user.index(conf.req)))

 for r in routes:
  conf.routeList.add(r)
```

- Compile template and render
```bash
import ../bangala/client/template
import ../bangala/client/view
include "testhtml.nimf"
proc index*(req: Request): handler.HttpHandler =
 echo "Index page"
 compileTpl(tpl)
 tpl = getTestPage()
 view.render(req, tpl)

#to getTestPage() check nim documentation at source code filter
```

Get the source code
```bash
git clone https://github.com/bangala
```

