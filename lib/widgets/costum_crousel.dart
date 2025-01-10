import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netflix/common/utils.dart';
import 'package:netflix/models/tv_series_model.dart';

class CostumCrousel extends StatelessWidget {
  final TvSeriesModel data;
  const CostumCrousel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      child: CarouselSlider.builder(
          itemCount: data.results?.length ?? 0,
          itemBuilder: (context, index, realIndex) {
            var url = data.results?[index].backdropPath.toString();
            return GestureDetector(
                child: Column(
                  children: [
                    CachedNetworkImage(
                                  imageUrl: url != null
                      ? '$imageUrl$url'
                      : 'https://via.placeholder.com/150',
                                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                                const SizedBox(height: 10.0,),
                                Text(data.results![index].name!)
                  ],
                ));
          },
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayInterval: const Duration(seconds: 3),
            height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
            aspectRatio: 16/9,
            autoPlayAnimationDuration: const Duration(microseconds: 800),
            reverse: false,
            scrollDirection: Axis.horizontal,
            initialPage: 0,

          ),
          
          ),
    );
  }
}
