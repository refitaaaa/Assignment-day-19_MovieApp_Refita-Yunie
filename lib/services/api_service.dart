import 'package:dio/dio.dart';
import '../models/movie_model.dart';
import '../utils/constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Interceptor untuk auto tambah API key
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = AppConstants.apiKey;
          print('REQUEST: ${options.uri}');
          return handler.next(options);
        },
        onError: (error, handler) {
          print('ERROR: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // Get Popular Movies
  Future<Map<String, dynamic>> getPopularMovies(int page) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get Movie Detail
  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final response = await _dio.get('/movie/$movieId');
      return MovieDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Search Movies (BONUS FEATURE)
  Future<Map<String, dynamic>> searchMovies(String query, int page) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
          'page': page,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error Handler
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout!';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout!';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      default:
        return 'Connection error!';
    }
  }
}