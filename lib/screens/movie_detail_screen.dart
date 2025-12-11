import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_model.dart';
import '../services/api_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<MovieDetail> _movieDetail;

  @override
  void initState() {
    super.initState();
    _movieDetail = _apiService.getMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetail>(
        future: _movieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _movieDetail = _apiService.getMovieDetail(widget.movieId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // App Bar dengan Backdrop
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    movie.title,
                    style: const TextStyle(
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 8,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.fullBackdropPath,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tagline
                      if (movie.tagline != null && movie.tagline!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            '"${movie.tagline}"',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                      // Rating, Year, Runtime
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 4),
                          Text(movie.releaseYear),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 4),
                          Text(movie.runtimeFormatted),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Overview
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Genres
                      if (movie.genres.isNotEmpty) ...[
                        const Text(
                          'Genres',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: movie.genres.map((genre) {
                            return Chip(
                              label: Text(genre.name),
                              backgroundColor: Colors.deepPurple.withOpacity(0.2),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Production Companies
                      if (movie.productionCompanies.isNotEmpty) ...[
                        const Text(
                          'Production Companies',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...movie.productionCompanies.map((company) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• ${company.name}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}