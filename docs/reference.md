# Reference

## Reactive Events

Halstead operates as a Belmont provider within the RMVC+R architecture. Instead of returning values directly, the methods interact with the native `LocalStorage` API and publish scoped events to the resource's stream. 

Consumers subscribe to these streams to react to state changes. The primary event scopes you will encounter are:
- `resource`: Indicates a successful state change or retrieval (e.g., `value`, `created`, `deleted`).
- `response`: Indicates a failure to retrieve an expected state (e.g., `not-found`).
- `request`: Indicates an invalid attempt to mutate the state (e.g., `method-not-allowed`).

## Halstead

The `Halstead` class extends the `@dashkite/belmont/provider` base class to manage persistence within the browser's `LocalStorage`. It normalizes synchronous storage access into the asynchronous, event-driven interface expected by Belmont.

### get

$get: \to \emptyset$

The `get` method retrieves the current value from `LocalStorage` using the resolved resource URL as the underlying storage key. It does not return the value directly; instead, it pushes the result into the reactive event stream.

If the storage contains a value for the URL, it publishes a `value` event scoped to the `resource`. If the storage is empty for that URL, it publishes a `not-found` event scoped to the `response`. This allows the application to handle missing data gracefully.

<example>
```coffeescript
resource.subscribe (event) ->
  assert.equal event.name, "value"

resource.get()
```
</example>

### put

$put: value \to \emptyset$

The `put` method serializes and stores the provided `value` in `LocalStorage` under the resource's URL. It delegates the physical serialization to the `@dashkite/storage` library.

If the URL already had an associated value, the method publishes a `value` event scoped to the `resource`. If this is the first time data is being written to this URL, it publishes a `created` event, also scoped to the `resource`. This distinction allows upstream models to differentiate between initializations and subsequent updates.

<example>
```coffeescript
resource.subscribe (event) ->
  assert.equal event.value.theme, "dark"

resource.put theme: "dark"
```
</example>

### delete

$delete: \to \emptyset$

The `delete` method completely removes the value associated with the resource's URL from `LocalStorage`. After successfully clearing the storage entry, it publishes a `deleted` event scoped to the `resource`. 

This signals to any connected reactive controllers that the state has been purged, prompting them to clean up or reset their corresponding views.

<example>
```coffeescript
resource.subscribe (event) ->
  assert.equal event.name, "deleted"

resource.delete()
```
</example>

### post

$post: value \to \emptyset$

The `post` method is intentionally not supported by the Halstead provider. In the context of `LocalStorage`, appending data without a known deterministic key contradicts the URL-based taxonomy that Belmont enforces. 

Calling this method will not alter the storage state. Instead, it immediately publishes a `method-not-allowed` event scoped to the `request`, embedding the attempted method and URL in the payload for debugging purposes.

<example>
```coffeescript
resource.subscribe (event) ->
  assert.equal event.name, "method-not-allowed"
  assert.equal event.method, "post"

resource.post theme: "light"
```
</example>
