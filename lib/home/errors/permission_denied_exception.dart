/// An exception thrown when trying to access the device's location
/// information while access is denied.
class PermissionDeniedException implements Exception {
  /// Constructs the [PermissionDeniedException].
  const PermissionDeniedException({this.message});

  /// A [message] describing more details on the denied permission.
  final String? message;

  @override
  String toString() {
    const defaultMessage =
        'Access to the location of the device is denied by the user.';
    if (message == '') {
      return defaultMessage;
    }

    return message ?? defaultMessage;
  }
}
