abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
    Object? data,
  });
  Future<dynamic> post(
    String path, {
    Map<String, String>? queryParameters,
    Object? data,
    bool isFormData = false,
  });
  Future<dynamic> patch(
    String path, {
    Map<String, String>? queryParameters,
    Object? data,
    bool isFormData = false,
  });
  Future<dynamic> delete(
    String path, {
    Map<String, String>? queryParameters,
    Object? data,
    bool isFormData = false,
  });
}
