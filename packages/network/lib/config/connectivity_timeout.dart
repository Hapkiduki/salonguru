/// {@template connectivity_timeout}
/// Represents the network connectivity timeouts.
///
/// Includes timeouts for connection, read operations, and overall call.
/// Each timeout is represented by a `Duration` object.
/// {@endtemplate}
class ConnectivityTimeout {
  /// {@macro connectivity_timeout}
  const ConnectivityTimeout({
    required this.connect,
    required this.receive,
    required this.send,
  });

  /// Timeout for establishing a connection in seconds.
  final int connect;

  /// Timeout for reading data in seconds.
  final int receive;

  /// Timeout for the overall network call in seconds.
  final int send;

  /// Converts the connection timeout to a [Duration].
  Duration get connectDuration => Duration(seconds: connect);

  /// Converts the read timeout to a [Duration].
  Duration get receiveDuration => Duration(seconds: receive);

  /// Converts the overall network call timeout to a [Duration].
  Duration get sendDuration => Duration(seconds: send);
}
