import ../server/handler
type
    Route* = object of RootObj
      path*: string
      handler*: handler.HttpHandler