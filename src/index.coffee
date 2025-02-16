import Generic from "@dashkite/generic"
import Storage from "@dashkite/storage"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Halstead extends Provider

  get: ->
    self = @
    EventReactor.from do ->
      if ( value = Storage.get self.url )?
        yield name: "success"
        yield { name: "value", value }
      else
        yield 
          name: "failure"
          error: new Error "halstead: [ #{ self.url } ] not found"

  put: do ->
 
    ( Generic.make "Halstead.put" )

      .define [( -> true )], ( value ) ->
        self = @
        EventReactor.from do ->
          Storage.set self.url, value
          yield name: "success"
          yield { name: "value", value }
          self.dispatch { name: "update", value  }

      .define [ Function ], ( mutator ) ->
        self = @
        EventReactor.from do ->
          yield from await self.put ( await mutator Storage.get self.url )

export default Halstead