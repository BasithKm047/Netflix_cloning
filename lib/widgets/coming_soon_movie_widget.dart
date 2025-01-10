import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComingSoonMovieWidget extends StatelessWidget {
  final String imageUrl;
  final String overview;
  final String month;
  final String logoUrl;
  final String day;

  const ComingSoonMovieWidget(
      {super.key,
      required this.imageUrl,
      required this.overview,
      required this.month,
      required this.logoUrl,
      required this.day});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  month,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 40,
                    letterSpacing: 5,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(imageUrl: imageUrl),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      height: size.height * 0.2,
                      child: CachedNetworkImage(
                        imageUrl: logoUrl,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const Spacer(),
                    const Column(
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                        Text(
                          'Remind me',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Column(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                        Text(
                          'Info',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coming on $month $day',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(overview,


                    maxLines: 4,
                  style: const TextStyle(fontSize: 12,
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis),)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
