import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner is used to remove the debug label
      debugShowCheckedModeBanner: false,
      title: 'Display Image',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The widget tree is like 1 Row, inside that 2 Columns are used.
// One column is for asset image, one for network image
// Each column has a text, sized box and image.
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Display Image"),
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Network Image"),
                const SizedBox(
                  height: 20,
                ),
                // adding container because when the network image fails to load and shows an error widget, Icon(Icons.error),
                // the height of the Column shrinks, making the UI look unbalanced.
                // so whatever the image is it will always have a fixed height, width and padding
                Container(
                  padding: EdgeInsets.all(40),
                  width: 500,
                  height: 300,
                  alignment: Alignment.center,
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg',
                    width: 500,
                    height: 200,
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,
                    // loadingBuilder is inbuilt with network images, it takes application context, child widget, and a loading progress event

                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      // this will check of the loading state is still there or not, if loading is null then image is already loaded
                      // else it will show a circular progress indicator
                      if (loadingProgress == null) {
                        return child; // Image loaded
                      }
                      return Center(
                        //you always may not see the CircularProgressIndicator, as image gets loaded so fast.
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes!)
                              : null,
                        ),
                      );
                    },
                    // errorBuilder is for error handling
                    // this can also handle common error,CORS, which generally is seen when network image are called in flutter web env.
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error,
                          size: 100, color: Colors.red);
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Asset Image"),
                const SizedBox(
                  height: 20,
                ),
                // keeping image inside container for box shadow and border radius.
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange, // orange shadow color
                          spreadRadius: 8,
                          blurRadius: 15,
                          offset: Offset(0, 4),
                        )
                      ],
                      border: Border.all(
                        color: Colors.orangeAccent,
                        width: 10,
                      ),
                      borderRadius:
                          BorderRadius.circular(10)), // circular border
                  child: ClipRRect(
                    child: Image.asset(
                      "images/mountain.png",
                      height: 200,
                      width: 500,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topRight,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
