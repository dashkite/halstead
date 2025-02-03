import Generic from "@dashkite/generic"
import Addison from "@dashkite/addison"
import EventReactor from "@dashkite/reactive/event-reactor"
import Provider from "@dashkite/belmont/provider"

class Errors

  @make: ( name ) ->
    new Error "Halstead: #{ name }"

# Chicago protocol requires methods return reactors (not iterators)
# so the reactor functions start with `await true`

class Halstead extends Provider

  get: ->
    self = @
    EventReactor.from do ->
      await true
      if ( value = Addison.get self.url )?
        yield name: "value", value: Addison.get self.url
        yield name: "succss"
      else
        yield name: "failure", error: Errors.make "not found"

  put: do ->
 
    ( Generic.make "Halstead.put" )

      .define [( -> true )], ( value ) ->
        self = @
        EventReactor.from do ->
          await true
          Addison.set self.url, value
          self.dispatch { name: "update", value  }
          yield name: "success"
          yield { name: "value", value }

      .define [ Function ], ( mutator ) ->
        self = @
        EventReactor.from do ->
          yield from await self.put ( await mutator Addison.get self.url )

export default Halstead