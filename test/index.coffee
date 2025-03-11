import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import * as Val from "@dashkite/joy/value"

import Halstead from "../src"

import expected from "./expected"

import Resource from "@dashkite/belmont"
import Providers from "@dashkite/belmont/providers"

Providers.add "local", Halstead
  
do ->

  print await test "Halstead", [

    test "integration test", ->

      resource = await Resource.resolve template: "local:/components/add-site"

      actual = []

      do ->
        for await event from resource.subscribe()
          switch event.name
            when "value" then actual.push event.value

      await resource.put "hello, world"

      await resource.get()

      await resource.put "goodbye!"

      await assert.expect -> Val.equal expected, actual

      assert ( globalThis.localStorage.key 0 )?
      

  ]

  process.exit if success then 0 else 1
