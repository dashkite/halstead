import Generic from "@dashkite/generic"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Halstead extends Provider

  get: ->
    self = @
    @publish
      method: "get"
      url: @url
      reactor: do -> 
        if ( value = Storage.get self.url )?
          yield { name: "value", value }
        else
          yield 
            name: "failure"
            error: new Error "halstead: [ #{ self.url } ] not found"

  put: ( value ) ->
    self  = @
    @publish
      method: "put"
      url: @url
      reactor: do ->
        Storage.set self.url, value
        yield { name: "value", value }

  delete: ->
    self = @
    @publish 
      method: "delete"
      url: @url
      reactor: do ->
        if ( Storage.get self.url )?
          Storage.remove self.url
          yield name: "deleted"
        else
          yield
            name: "failure"
            error: new Error "halstead: [ #{ self.url } ] not found"

  post: ->
    self = @
    @publish 
      method: "post"
      url: @url
      reactor: do ->
        yield
          name: "failure"
          error: new Error "halstead: [ #{ self.url } ] unsupported method"

export default Halstead