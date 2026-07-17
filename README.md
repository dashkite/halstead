# Halstead

*Transparent LocalStorage persistence for observables*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Halstead is a Belmont provider that enables reactive `LocalStorage` persistence. It allows developers to store and retrieve resources directly from the browser's local storage utilizing a uniform, event-driven interface, deeply integrated with the Reactive Resource Model.

## Features

- **Reactive Persistence:** Integrates with observables to provide real-time updates when data changes in `LocalStorage`.
- **Belmont Integration:** Operates as a concrete resource provider for Belmont, abstracting `LocalStorage` behind standard resource operations.
- **Event-Driven:** Emits lifecycle events such as `value`, `not-found`, `created`, and `deleted` for precise state management.
- **Uniform Interface:** Normalizes local storage access through consistent `get`, `put`, and `delete` operations.

## Installation

```bash
pnpm install @dashkite/halstead
```

## Usage

Register Halstead as a custom Belmont provider to manage local settings.

```coffeescript
import Providers from "@dashkite/belmont/providers"
import Halstead from "@dashkite/halstead"
import Resource from "@dashkite/belmont"

# Register Halstead for the 'local' protocol
Providers.add "local", Halstead

# Resolve a local resource
resource = await Resource.resolve
  template: "local://settings"

resource.subscribe ({ name, value }) ->
  if name == "value"
    console.log "Settings loaded:", value

# Retrieve from LocalStorage
resource.get()

# Save a new value to LocalStorage
resource.put theme: "dark"
```

## Other Resources

- [Reference](docs/reference.md)
- [Recipes](docs/recipes.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)
