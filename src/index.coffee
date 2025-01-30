import Generic from "@dashkite/generic"
import Addison from "@dashkite/addison"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Errors

  @make: ( name ) ->
    new Error "Halstead: #{ name }"

class Halstead extends Provider

  get: ->
    self = @
    EventReactor.from do ->
      if ( value = Addison.get self.url )?
        yield name: "value", value: Addison.get self.url
      else
        yield name: "failure", error: Errors.make "not found"

  put: do ->
 
    ( Generic.make "Halstead.put" )

      .define [( -> true )], ( value ) ->
        self = @
        EventReactor.from do ->
          Addison.set self.url, value
          self.dispatch { name: "update", value  }
          yield name: "success"

      .define [ Function ], ( mutator ) ->
        self = @
        EventReactor.from do ->
          yield from await self.put ( await mutator Addison.get self.url )

export default Halstead