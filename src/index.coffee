import { identity } from "@dashkite/joy/function"
import Registry from "@dashkite/helium"
import Storage from "@dashkite/addison"
import Observable from "@dashkite/observable"

Halstead =

  persist: ( key, { wrap, unwrap, empty }) ->

    wrap ?= identity
    unwrap ?= identity

    do ({ clone, _value, observable } = {}) ->

      clone = ( value ) -> wrap structuredClone unwrap value

      _value = if ( Storage.has key ) then ( Storage.get key ) else empty

      value = wrap _value

      observable = Observable.from value, { clone }
        
      observable.observe ( value ) -> Storage.set key, unwrap value
      
      Registry.set key, observable


export default Halstead
