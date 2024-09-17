import { identity } from "@dashkite/joy/function"
import Registry from "@dashkite/helium"
import Storage from "@dashkite/addison"
import Observable from "@dashkite/observable"

class WrappedObservable
  
  @make: ( target, { wrap, unwrap }) ->
    Object.assign ( new @ ), { target, wrap, unwrap }

  get: -> @wrap @target.get()

  set: ( value ) -> @target.set @unwrap value

  plan: ( mutator, priority ) ->
    _mutator = ( data ) => mutator @wrap data
    @target.plan _mutator, priority

  abort: -> @target.abort()
  
  commit: -> @target.commit()

  update: ( mutator ) -> @target.update mutator
      
  observe: ( handler ) -> 
    _handler = ( data ) => handler @wrap data
    @target.observe _handler

  cancel: ( handler ) -> @target.cancel handler

  push: -> @target.push handler

  pop: -> @wrap @target.pop()

Halstead =

  persist: ( key, { wrap, unwrap, empty }) ->

    wrap ?= identity
    unwrap ?= identity

    value = if ( Storage.has key ) then ( Storage.get key ) else empty

    observable = Observable.from value
      
    observable.observe ( value ) -> Storage.set key, value

    wrapper = WrappedObservable.make observable, { wrap, unwrap }
    
    Registry.set key, wrapper


export default Halstead
