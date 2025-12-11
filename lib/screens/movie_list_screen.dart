import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/movie_model.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final ApiService _apiService = ApiService();

  // penting: kasih generic <int, Result>
  final PagingController<int, Result> _pagingController =
      PagingController(firstPageKey: 1);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      late Map<String, dynamic> response;

      if (_searchQuery.trim().isEmpty) {
        response = await _apiService.getPopularMovies(pageKey);
      } else {
        response = await _apiService.searchMovies(_searchQuery, pageKey);
      }

      final List<dynamic> rawResults =
          (response['results'] is List) ? response['results'] : [];
      final List<Result> movies =
          rawResults.map((json) => Result.fromJson(json)).toList();

      final int totalPages =
          response['total_pages'] is int ? response['total_pages'] : 1;
      final bool isLastPage = pageKey >= totalPages;

      if (isLastPage) {
        _pagingController.appendLastPage(movies);
      } else {
        _pagingController.appendPage(movies, pageKey + 1);
      }
    } catch (e) {
      _pagingController.error = e.toString();
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
        _pagingController.refresh();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Movie App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged("");
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: PagedGridView<int, Result>(
                pagingController: _pagingController,
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                builderDelegate: PagedChildBuilderDelegate<Result>(
                  itemBuilder: (context, movie, index) {
                    return MovieCard(
                      movie: movie,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MovieDetailScreen(movieId: movie.id),
                          ),
                        );
                      },
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) =>
                      const Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (context) =>
                      const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${_pagingController.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _pagingController.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) =>
                      const Center(child: Text('No movies found')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
