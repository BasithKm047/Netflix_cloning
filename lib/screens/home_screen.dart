import 'package:flutter/material.dart';
import 'package:netflix/models/tv_series_model.dart';
import 'package:netflix/models/upcoming_movie_model.dart';
import 'package:netflix/screens/search_screen.dart';
import 'package:netflix/services/api_services.dart';
import 'package:netflix/widgets/costum_crousel.dart';
import 'package:netflix/widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Upcomingmoviemodel> upcomingFuture;
  late Future<Upcomingmoviemodel> nowPlayngFuture;
  late Future<TvSeriesModel> toprated_series;

  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    upcomingFuture = apiServices.getUpcomingMovie();
    nowPlayngFuture = apiServices.getNowPlayingMovies();
    toprated_series = apiServices.getTopratedSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDefaultIconDarkColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Image.asset(
            'assets/netflix-logo-png.png',
            height: 50.0,
            width: 120.0,
            // color: kbackgroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchScreen(),));
              },
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.blue,
              height: 27,
              width: 27.0,
            ),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            FutureBuilder<TvSeriesModel>(
              future: toprated_series,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  return CostumCrousel(data: snapshot.data!);
                }

                return const Center(
                  child: Text('No Data Available'),
                );
              },
            ),
            SizedBox(
                height: 300,
                child: MovieCard(
                    future: upcomingFuture, headLineText: 'Upcoming Movies')),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
                height: 300,
                child: MovieCard(
                    future: nowPlayngFuture,
                    headLineText: 'Now Playing Movies'))
          ],
        ),
      ),
    );
  }
}
