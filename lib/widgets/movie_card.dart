import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/upcoming_movie_model.dart';
import 'package:netflix/screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final Future<Upcomingmoviemodel> future;
  final String headLineText;

  const MovieCard({
    super.key,
    required this.future,
    required this.headLineText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Upcomingmoviemodel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var data = snapshot.data!.results; // Assuming `results` is a list
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  headLineText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: data?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder:(context) => MovieDetailsScreen(movieId: data![index].id!),));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            '$imageUrl${data?[index].posterPath}',
                            fit: BoxFit.cover,
                            // width: 500.0, // Set a fixed width for the images
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      }
   
    );
  }
}
