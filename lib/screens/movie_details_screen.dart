import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/movie_details_model.dart';
import 'package:netflix/models/recommendation_movie_model.dart';
import 'package:netflix/services/api_services.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailedModel> movieDetails;
  late Future<MovieRecommendationModel> movieRecommendation;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  fetchInitialData() {
    movieDetails = apiServices.getMovieDeatails(widget.movieId);
    movieRecommendation = apiServices.getMovieRecomendation(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<MovieDetailedModel>(
          future: movieDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error.toString()}'));
            } else if (snapshot.hasData) {
              final movie = snapshot.data!;
              String genreText =
                  movie.genres?.map((genre) => genre.name).join(', ') ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Image
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('$imageUrl${movie.posterPath}'),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_sharp,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Movie Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      movie.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Release Date and Genre
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          movie.releaseDate ?? 'No Date',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            genreText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Movie Overview
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      movie.overview ?? 'No Overview Available',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder(
                    future: movieRecommendation,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final movieRecommendation = snapshot.data;
                        return movieRecommendation!.results!.isEmpty
                            ? const SizedBox()
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('More Like this'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  GridView.builder(
                                    itemCount: movieRecommendation.results!.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 15,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 1.5 / 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movieRecommendation.results![index].id!),));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              ('$imageUrl${movieRecommendation.results?[index].posterPath}'),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              );
                      }
                      return const Text('something went wrong');
                    },
                  )
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
