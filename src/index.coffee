import Generic from "@dashkite/generic"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Halstead extends Provider

  get: ->
    if ( value = Storage.get @url )?
      @publish { name: "value", value }
    else
      @publish { name: "not found", @url }

  put: ( value ) ->
    Storage.set @url, value
    @publish { name: "value", value }

  delete: ->
    Storage.remove @url
    @publish { name: "delete" }

  post: ( value ) ->
    @publish 
      name: "unsupported method"
      url: @url
      method: "post"

export default Halstead