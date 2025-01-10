import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/recommendation_movie_model.dart';
import 'package:netflix/models/search_model.dart';
import 'package:netflix/screens/movie_details_screen.dart';
import 'package:netflix/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ApiServices apiServices = ApiServices();
  late Future<MovieRecommendationModel> popularMovie;

  SearchModel? searchModel;
  String? errorMessage;
  bool isLoading = false;

  void search(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await apiServices.getSearchMovie(query);
      setState(() {
        searchModel = result;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    popularMovie = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CupertinoSearchTextField(
                  controller: searchController,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  suffixIcon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  style: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        searchModel = null;
                        errorMessage = null;
                        isLoading = false;
                      });
                    } else {
                      search(value);
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (errorMessage != null)
                Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else if (searchModel == null)
                FutureBuilder<MovieRecommendationModel>(
                    future: popularMovie,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        var data = snapshot
                            .data!.results; // Assuming `results` is a list
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   // height: 30,
                            // ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Top searches',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection:
                                  Axis.vertical, // Horizontal scrolling
                              itemCount: data?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  MovieDetailsScreen(movieId:data[index].id!,),));
                                  },
                                  child: Container(
                                    height: 150,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(
                                            '$imageUrl${data?[index].posterPath}',
                                            // fit: BoxFit.cover,
                                            // width: 500.0, // Set a fixed width for the images
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Text(
                                            data![index].title!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    })
              else if (searchModel!.results == null ||
                  searchModel!.results!.isEmpty)
                const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchModel?.results?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1.2 / 2,
                  ),
                  itemBuilder: (context, index) {
                    final movie = searchModel!.results![index];
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieDetailsScreen(movieId: movie.id!),));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: '$imageUrl${movie.backdropPath}',
                            height: 170,
                            width: double.infinity,
                            // fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(height: 5),
                          Flexible(
                            child: Text(
                              movie.originalTitle ?? 'Unknown',
                              style: const TextStyle(
                                  fontSize: 13.0, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
