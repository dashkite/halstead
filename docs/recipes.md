# Recipes

## Persisting application settings

This guide demonstrates how to persist application settings directly to the browser's local storage.

Belmont maps abstract resource URLs to concrete providers. By registering Halstead for a specific protocol (like `local`), creators can treat `LocalStorage` entries as standard reactive resources. This eliminates the need to manually poll storage for changes or write imperative sync logic.

```coffeescript
import Providers from "@dashkite/belmont/providers"
import Halstead from "@dashkite/halstead"
import Resource from "@dashkite/belmont"

# 1. Register the provider
Providers.add "local", Halstead

# 2. Resolve the resource
settings = await Resource.resolve
  template: "local://settings"

# 3. Subscribe to updates
settings.subscribe ({ name, value }) ->
  if name == "value"
    # external logic to update the application state
    applySettings value
  else if name == "not-found"
    # external logic to handle missing settings
    applyDefaultSettings()

# 4. Fetch the initial value
settings.get()

# 5. Update the settings later
settings.put
  theme: "dark"
  notifications: true
```

The algorithm follows these steps:
1. Register the `Halstead` class as the provider for a custom protocol (e.g., `local`) within Belmont's `Providers` registry.
2. Resolve a resource instance by providing a template URL that uses the registered protocol.
3. Subscribe to the resource's event stream. Watch for `value` events to apply the loaded data, and `not-found` events to handle missing data.
4. Invoke the `get` method to retrieve the data from `LocalStorage`, triggering the appropriate event.
5. Invoke the `put` method whenever the application needs to save new data back to `LocalStorage`.

## Resetting cached preferences

This guide demonstrates how to clear a specific slice of local storage using the `delete` method.

Halstead's `delete` method removes the item from `LocalStorage` and broadcasts a `deleted` event. This mechanism allows reactive components to automatically reflect the cleared state across the application without needing manual refreshes.

```coffeescript
import Resource from "@dashkite/belmont"

# assume the 'local' protocol is already registered
preferences = await Resource.resolve
  template: "local://preferences"

preferences.subscribe ({ name }) ->
  if name == "deleted"
    # external logic to revert UI back to default state
    resetView()

# trigger the deletion
preferences.delete()
```

The algorithm follows these steps:
1. Resolve the resource representing the cached preferences.
2. Subscribe to the resource and watch for the `deleted` event to trigger any necessary UI resets or state cleanups.
3. Invoke the `delete` method to remove the data from `LocalStorage` and publish the event.

## Handling unsupported mutations

This guide explains how to handle attempts to append data to a resource using the `post` method.

Because local storage relies on a strict key-value paradigm via URLs, it does not support abstract append operations. Halstead intercepts these calls and broadcasts a `method-not-allowed` event. This gives developers a structured way to catch and log architectural mistakes without crashing the application.

```coffeescript
import Resource from "@dashkite/belmont"

resource = await Resource.resolve
  template: "local://app-state"

resource.subscribe ({ name, method, url }) ->
  if name == "method-not-allowed"
    # external logic to log the invalid attempt
    logError "Invalid #{method} attempt on #{url}"

# attempt an unsupported post operation
resource.post { data: "new data" }
```

The algorithm follows these steps:
1. Resolve the target resource.
2. Subscribe to the resource and listen for the `method-not-allowed` event.
3. Extract the `method` and `url` from the event payload to provide detailed debugging information.
4. Invoke the `post` method. The provider catches the unsupported action and triggers the error flow without mutating storage.
