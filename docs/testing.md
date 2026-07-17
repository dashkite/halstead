# Testing

## General Approach

The halstead repository utilizes the standard DashKite testing infrastructure. The testing suite focuses on verifying the event-driven behavior of the Halstead provider, ensuring that the correct events with the appropriate payloads and scopes are emitted during `get`, `put`, `delete`, and `post` operations. 

We test against an environment that provides a functional storage interface to validate the persistence logic.

## Running Tests

To run the test suite, execute the following command:

```bash
npx genie test
```

If the Genie environment is unavailable, you may fall back to:

```bash
./scripts/test
```
