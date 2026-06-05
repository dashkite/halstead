import Generic from "@dashkite/generic"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Halstead extends Provider

  get: ->
    if ( value = Storage.get @url )?
      @publish name: "value", scope: "resource", value: value
    else
      @publish name: "not-found", scope: "response", url: @url

  put: ( value ) ->
    exists = ( Storage.get @url )?
    Storage.set @url, value
    if exists
      @publish name: "value", scope: "resource", value: value
    else
      @publish name: "created", scope: "resource", value: value

  delete: ->
    Storage.remove @url
    @publish name: "deleted", scope: "resource"

  post: ( value ) ->
    @publish
      name: "method-not-allowed"
      scope: "request"
      url: @url
      method: "post"

export default Halstead
