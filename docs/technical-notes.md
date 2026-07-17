# Technical Notes

### RMVC+R Architecture

DashKite applications are often built using the RMVC+R (Reactive Model-View-Controller + Resources) architecture. This approach builds upon the traditional [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) pattern by integrating [reactive programming principles](https://en.wikipedia.org/wiki/Reactive_programming), treating an entire application as a set of interacting event streams and logical resources.

Halstead is a foundational component of this effort. It implements the Reactive Resource Model for client-side persistence. Rather than treating local storage as a static database, Halstead exposes it as an event-driven resource stream, ensuring that state changes instantly propagate to upstream reactive models and controllers.

### Belmont Ecosystem Integration

Halstead functions specifically as a provider for Belmont, the reactive resource manager in the DashKite ecosystem. Belmont provides an abstraction layer that maps logical resource locators (URLs) to concrete, event-driven providers based on the protocol.

By registering Halstead dynamically via `@dashkite/belmont/providers`, developers can assign arbitrary protocols (like `local://` or `app-settings://`) to handle persistence. Belmont manages a registry of these instantiated providers, delegating all operations for the specified protocol to Halstead. This decoupled approach allows developers to swap out the underlying storage mechanism without rewriting the application's resource logic.

### LocalStorage API

Halstead normalizes the native [Window.localStorage API](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) into a reactive interface. The native `localStorage` provides a synchronous key-value store constrained to strings. Halstead elevates this by:

1. Translating synchronous, imperative calls into an asynchronous, event-driven interface using methods like `get`, `put`, and `delete`.
2. Categorizing state changes with scoped events (`scope: "resource"`, `scope: "response"`, `scope: "request"`), which allows upstream consumers to differentiate between a successful retrieval (`value`), a missing resource (`not-found`), or an unsupported operation (`method-not-allowed`).

Halstead delegates the physical read and write operations to the `@dashkite/storage` library. This ensures consistent behavior and handles serialization, allowing complex data structures to be safely persisted and retrieved from the browser's string-only local storage while maintaining the reactive data flow.
