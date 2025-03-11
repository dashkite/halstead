import Generic from "@dashkite/generic"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Halstead extends Provider

  get: ->
    if ( value = Storage.get @url )?
      @publish { name: "value", value }
    else
      @publish 
        name: "failure"
        error: new Error "halstead: [ #{ @url } ] not found"
      @publish 
        name: "not found"
        url: @url

  put: ( value ) ->
    Storage.set @url, value
    @publish { name: "value", value }

  delete: ->
    if ( Storage.get @url )?
      Storage.remove @url
      @publish name: "deleted"
    else
      @publish 
        name: "failure"
        error: new Error "halstead: [ #{ @url } ] not found"
      @publish 
        name: "not found"
        url: @url

  post: ->
    @publish
      name: "failure"
      error: new Error "halstead: [ #{ @url } ] unsupported method"

export default Halstead