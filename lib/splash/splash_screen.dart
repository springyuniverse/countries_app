import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../shared/ui/helpers/text_styles.dart';
import '../shared/utils/images.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundImage: AssetImage(
                    Images.countriesImage,
                  ),
                  radius: 150),
              Text(
                'My Countries',
                style: TextStyles.header,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Discover world countries, favourite'
                    ' them \n and mark the visited ones ✈️',
                style: TextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.home);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 50,
                  child: Text(
                    "Discover️",
                    style: TextStyles.baseText,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
        ),
      );
}
