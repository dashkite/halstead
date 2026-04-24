import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"
import Storage from "@dashkite/storage"
import Resource from "@dashkite/belmont"
import conformance from "@dashkite/belmont/test/conformance"

# Add Halstead as a provider for local schemes
import Halstead from "../src"
import Providers from "@dashkite/belmont/providers"
Providers.add "local", Halstead

generateAddress = -> Math.random().toString(36)[ 2.. ]

factory =
  existing: ->
    url = "local://existing-#{ generateAddress() }"
    Storage.set url, { title: "Existing", body: "I'm a teapot" }
    resource = await Resource.resolve template: url
    { resource }

  missing: ->
    url = "local://missing-#{ generateAddress() }"
    Storage.remove url
    resource = await Resource.resolve template: url
    { resource }

  unsupported: ->
    resource = await Resource.resolve template: "local://anything"
    { resource, method: "post" }

do ->

  print await test "Halstead", [
    conformance factory
  ]

  process.exit if success then 0 else 1
