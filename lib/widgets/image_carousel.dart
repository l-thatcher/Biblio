import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List? imageList;

  const ImageCarousel({Key? key, this.imageList}) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

//this shows the users the images from a post and allows them to swipe through them
class _ImageCarouselState extends State<ImageCarousel> {

  int _selectedPage = 0;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 1,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              spreadRadius: 0.05,
              blurRadius: 20,
            )
          ]
      ),
      child: Stack(
        children: [
          PageView(
            onPageChanged: (number) {
              setState(() {
                _selectedPage = number;
              });
            },
            children: [
              for(var i = 0; i < widget.imageList!.length; i++)
                Image.network(
                    "${widget.imageList![i]}"
                )
            ],
          ),
          //the small dots at the bottom of the carousel are controlled here
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(var i = 0; i < widget.imageList!.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    width: _selectedPage == i ? 30 : 10,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 2,
                            blurRadius: 10,
                          )
                        ]
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
