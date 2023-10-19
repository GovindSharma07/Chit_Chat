import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/utilits/SharedPrefs.dart';


class DrawerContent extends StatelessWidget {
  DrawerContent({super.key});

  final SharedPrefs _sharedPrefs = SharedPrefs();

  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder:(context, constraints) {

       return SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CachedNetworkImage(
              placeholder:(context , url) => const CircularProgressIndicator(),
              imageUrl: _sharedPrefs.getImgUrl(),
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: 200,
                  height: 200,

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(constraints.maxWidth/2),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill
                    )
                )
                );
              },
            ),
            const SizedBox(height: 20),
            Text("Name:- ${_sharedPrefs.getUserName()}")


          ],
      ),
       );
      }
      );
  }

}
