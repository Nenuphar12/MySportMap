/// An exception thrown when trying to access the device's location
/// information while access is **permanently** denied.
class PermissionDeniedForeverException implements Exception {
  /// Constructs the [PermissionDeniedForeverException]
  const PermissionDeniedForeverException({this.message});

  /// A [message] describing more details on the denied permission.
  final String? message;

  @override
  String toString() {
    if (message == null || message == '') {
      return 'Access to the location of the device is permanently denied,'
          ' permissions cannot be requested.';
    }
    return message!;
  }
}
