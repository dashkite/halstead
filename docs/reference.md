# Reference

## Halstead

The Halstead provider manages persistence in `LocalStorage`. It extends `@dashkite/belmont/provider`.

### get
$get: \to \emptyset$

Retrieves the value from `LocalStorage` using the resource URL as the key.
- If found, publishes `{ name: "value", value }`.
- If not found, publishes `{ name: "not found", url }`.

### put
$put: value \to \emptyset$

Stores the given value in `LocalStorage` and publishes `{ name: "value", value }`.

### delete
$delete: \to \emptyset$

Removes the value from `LocalStorage` and publishes `{ name: "delete" }`.

### post
$post: value \to \emptyset$

Not supported. Publishes `{ name: "unsupported method", url, method: "post" }`.
