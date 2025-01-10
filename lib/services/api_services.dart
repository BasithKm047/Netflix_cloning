import 'dart:developer';

import 'package:netflix/common/utils.dart';
import 'package:netflix/models/movie_details_model.dart';
import 'package:netflix/models/recommendation_movie_model.dart';
import 'package:netflix/models/search_model.dart';
import 'package:netflix/models/tv_series_model.dart';
import 'package:netflix/models/upcoming_movie_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseurl = 'http://api.themoviedb.org/3';
var key = '?api_key=$apiKey';
late String endpoint;

class ApiServices {
  Future<Upcomingmoviemodel> getUpcomingMovie() async {
    endpoint = 'movie/upcoming';
    final url = '$baseurl/$endpoint$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('success ');
      // print('success');
      return Upcomingmoviemodel.fromJson(jsonDecode(response.body));
    }

    throw Exception('failed to load upcoming movies');
  }

  Future<Upcomingmoviemodel> getNowPlayingMovies() async {
    endpoint = 'movie/now_playing';
    final url = '$baseurl/$endpoint$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('Success ');
      // print('success');
      return Upcomingmoviemodel.fromJson(jsonDecode(response.body));
    }

    throw Exception('failed to load now playing movies');
  }

  Future<TvSeriesModel> getTopratedSeries() async {
    endpoint = 'tv/top_rated';
    final url = '$baseurl/$endpoint$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('Success ');
      // print('success');
      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('failed to load top rated tvseries');
  }
  
  Future<SearchModel> getSearchMovie(String searchText) async {
    endpoint = 'search/movie';
    final url = '$baseurl/$endpoint$key&query=$searchText';
     print('search url=$url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('Success ');
      // print('success');
      return SearchModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('failed to load Searched movies');
  }

Future<MovieRecommendationModel> getPopularMovies() async {
    endpoint = 'movie/popular';
    final url = '$baseurl/$endpoint$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('Success ');
      // print('success');
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('failed to load Popular Movies');
  }


  
Future<MovieDetailedModel> getMovieDeatails(int movieId) async {
    endpoint = 'movie/$movieId';
    final url = '$baseurl/$endpoint$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('Success ');
      // print('success');
      return MovieDetailedModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('failed to load Movie Details');
  }

  Future<MovieRecommendationModel> getMovieRecomendation(int movieId) async {
    endpoint = 'movie/$movieId/recommendations';
    final url = '$baseurl/$endpoint$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('Success ');
      // print('success');
      return MovieRecommendationModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('failed to load Movie Recomandation');
  }


}
