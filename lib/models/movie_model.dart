// To parse this JSON data, do
//
//     final movieApp = movieAppFromJson(jsonString);

import 'dart:convert';

MovieApp movieAppFromJson(String str) => MovieApp.fromJson(json.decode(str));

String movieAppToJson(MovieApp data) => json.encode(data.toJson());

class MovieApp {
    int page;
    List<Result> results;
    int totalPages;
    int totalResults;

    MovieApp({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory MovieApp.fromJson(Map<String, dynamic> json) => MovieApp(
        page: json["page"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class Result {
    bool adult;
    String? backdropPath;
    List<int> genreIds;
    int id;
    String originalLanguage;
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    String? releaseDate;
    String title;
    bool video;
    double voteAverage;
    int voteCount;

    Result({
        required this.adult,
        this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        genreIds: json["genre_ids"] != null 
            ? List<int>.from(json["genre_ids"].map((x) => x))
            : [],
        id: json["id"],
        originalLanguage: json["original_language"] ?? "",
        originalTitle: json["original_title"] ?? "",
        overview: json["overview"] ?? "",
        popularity: (json["popularity"] ?? 0).toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"] ?? "",
        video: json["video"] ?? false,
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
        voteCount: json["vote_count"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };

    // Helper methods untuk MovieCard
    String get fullPosterPath {
        if (posterPath == null || posterPath!.isEmpty) {
            return 'https://via.placeholder.com/500x750?text=No+Image';
        }
        return 'https://image.tmdb.org/t/p/w500$posterPath';
    }

    String get fullBackdropPath {
        if (backdropPath == null || backdropPath!.isEmpty) {
            return 'https://via.placeholder.com/500x750?text=No+Image';
        }
        return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }

    String get releaseYear {
        if (releaseDate == null || releaseDate!.isEmpty) {
            return 'N/A';
        }
        try {
            return releaseDate!.substring(0, 4);
        } catch (e) {
            return 'N/A';
        }
    }
}

// Model untuk Movie Detail
class MovieDetail {
    bool adult;
    String? backdropPath;
    int budget;
    List<Genre> genres;
    String? homepage;
    int id;
    String? imdbId;
    List<String> originCountry;
    String originalLanguage;
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    List<ProductionCompany> productionCompanies;
    List<ProductionCountry> productionCountries;
    String releaseDate;
    int revenue;
    int? runtime;
    List<SpokenLanguage> spokenLanguages;
    String status;
    String? tagline;
    String title;
    bool video;
    double voteAverage;
    int voteCount;

    MovieDetail({
        required this.adult,
        this.backdropPath,
        required this.budget,
        required this.genres,
        this.homepage,
        required this.id,
        this.imdbId,
        required this.originCountry,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        required this.productionCompanies,
        required this.productionCountries,
        required this.releaseDate,
        required this.revenue,
        this.runtime,
        required this.spokenLanguages,
        required this.status,
        this.tagline,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    factory MovieDetail.fromJson(Map<String, dynamic> json) => MovieDetail(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        budget: json["budget"] ?? 0,
        genres: json["genres"] != null
            ? List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x)))
            : [],
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originCountry: json["origin_country"] != null
            ? List<String>.from(json["origin_country"].map((x) => x))
            : [],
        originalLanguage: json["original_language"] ?? "",
        originalTitle: json["original_title"] ?? "",
        overview: json["overview"] ?? "",
        popularity: (json["popularity"] ?? 0).toDouble(),
        posterPath: json["poster_path"],
        productionCompanies: json["production_companies"] != null
            ? List<ProductionCompany>.from(
                json["production_companies"].map((x) => ProductionCompany.fromJson(x)))
            : [],
        productionCountries: json["production_countries"] != null
            ? List<ProductionCountry>.from(
                json["production_countries"].map((x) => ProductionCountry.fromJson(x)))
            : [],
        releaseDate: json["release_date"] ?? "",
        revenue: json["revenue"] ?? 0,
        runtime: json["runtime"],
        spokenLanguages: json["spoken_languages"] != null
            ? List<SpokenLanguage>.from(
                json["spoken_languages"].map((x) => SpokenLanguage.fromJson(x)))
            : [],
        status: json["status"] ?? "",
        tagline: json["tagline"],
        title: json["title"] ?? "",
        video: json["video"] ?? false,
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
        voteCount: json["vote_count"] ?? 0,
    );

    // Helper methods
    String get fullPosterPath {
        if (posterPath == null || posterPath!.isEmpty) {
            return 'https://via.placeholder.com/500x750?text=No+Image';
        }
        return 'https://image.tmdb.org/t/p/w500$posterPath';
    }

    String get fullBackdropPath {
        if (backdropPath == null || backdropPath!.isEmpty) {
            return 'https://via.placeholder.com/500x750?text=No+Image';
        }
        return 'https://image.tmdb.org/t/p/w500$backdropPath';
    }

    String get releaseYear {
        if (releaseDate.isEmpty) {
            return 'N/A';
        }
        try {
            return releaseDate.substring(0, 4);
        } catch (e) {
            return 'N/A';
        }
    }

    String get runtimeFormatted {
        if (runtime == null) {
            return 'N/A';
        }
        final hours = runtime! ~/ 60;
        final minutes = runtime! % 60;
        return '${hours}h ${minutes}m';
    }
}

class Genre {
    int id;
    String name;

    Genre({
        required this.id,
        required this.name,
    });

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class ProductionCompany {
    int id;
    String? logoPath;
    String name;
    String originCountry;

    ProductionCompany({
        required this.id,
        this.logoPath,
        required this.name,
        required this.originCountry,
    });

    factory ProductionCompany.fromJson(Map<String, dynamic> json) => ProductionCompany(
        id: json["id"],
        logoPath: json["logo_path"],
        name: json["name"],
        originCountry: json["origin_country"],
    );
}

class ProductionCountry {
    String iso31661;
    String name;

    ProductionCountry({
        required this.iso31661,
        required this.name,
    });

    factory ProductionCountry.fromJson(Map<String, dynamic> json) => ProductionCountry(
        iso31661: json["iso_3166_1"],
        name: json["name"],
    );
}

class SpokenLanguage {
    String englishName;
    String iso6391;
    String name;

    SpokenLanguage({
        required this.englishName,
        required this.iso6391,
        required this.name,
    });

    factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        englishName: json["english_name"],
        iso6391: json["iso_639_1"],
        name: json["name"],
    );
}