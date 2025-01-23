# Network

This library is designed to be agnostic to the application that uses it, providing a versatile solution for managing network communications. It leverages the `dio` package to handle HTTP requests, allowing flexible configuration of connection timeouts, global headers, authentication, and certificates.

## Module Purpose

The main goal of this library is to offer an adaptable and reusable network infrastructure that can be easily integrated into any Flutter application, regardless of its domain or specific context. It provides essential tools to ensure consistency in HTTP requests.

### Important
Do not add application-specific code.

## Class Descriptions

### `config` Package

- **ConnectivityTimeout**
  Enables configuring connection timeouts for connection (`connect`), receiving (`receive`), and sending (`send`) processes.

- **RequestData**
  An interface that provides a mechanism to define global headers to be applied to all network requests. This ensures centralized and consistent header management.

### `interceptors` Package

- **HeadersInterceptor**
  Responsible for adding the headers defined in `RequestData` to each request. This ensures all outgoing requests include the necessary headers for authentication and other configurations.

### Main Class

- **DioBuilder**
  Implements the Builder pattern to simplify the configuration of the `dio` HTTP client. It requires a `String baseUrl` and a `RequestData` instance to initialize. It offers methods to configure connection timeouts, certificate providers, logging interceptors, custom interceptors, and transformers. Finally, it allows building a fully configured `Dio` instance using the `build()` method.

  Key methods:
  - `DioBuilder setTimeouts(ConnectivityTimeout timeouts)`
  - `DioBuilder addLogInterceptor()`
  - `DioBuilder addInterceptor(Interceptor interceptor)`
  - `DioBuilder addTransformer(Transformer transformer)`
  - `Dio build()`

## How to Use

1. **Configure Connection Timeouts** (optional)  
   Create a `ConnectivityTimeout` instance to define the timeouts for connecting, sending, and receiving data.

2. **Define Global Headers** (required)  
   Implement the `RequestData` interface to define the headers that will be applied to all requests.

3. **Build the HTTP Client**  
   Use `DioBuilder` to configure and build a `Dio` instance.
   
   Basic initialization:
   ```dart
   Dio dio = DioBuilder(baseUrl, requestData)
       .build();
   ```

   Custom initialization:
   ```dart
   Dio dio = DioBuilder(baseUrl, requestData)
      .setTimeouts(connectivityTimeout)
      .addLogInterceptor()
      .addInterceptor(customInterceptor)
      .build();
   ```