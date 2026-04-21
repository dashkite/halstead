# Halstead

*Transparent LocalStorage persistence for observables*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Purpose

Halstead is a Belmont provider for reactive `LocalStorage` persistence. It allows resources to be stored and retrieved from the browser's local storage using a uniform, event-driven interface.

## Installation

Use your favorite package manager to install `@dashkite/halstead`.

## Usage

```coffee
import Providers from "@dashkite/belmont/providers"
import Halstead from "@dashkite/halstead"
import Resource from "@dashkite/belmont"

# Register Halstead for a custom protocol, e.g., 'local'
Providers.add "local", Halstead

# Resolve a local resource
# The URL will be something like 'local://settings'
resource = await Resource.resolve
  template: "local://settings"

resource.subscribe ({ name, value }) ->
  if name == "value"
    console.log "Settings:", value

# Retrieve from LocalStorage
resource.get()

# Save to LocalStorage
resource.put { theme: "dark" }
```

## Other Resources

- [Reference](docs/reference.md)

## Status

Not suitable for production use. Please report bugs and feature requests via the issue tracker.
