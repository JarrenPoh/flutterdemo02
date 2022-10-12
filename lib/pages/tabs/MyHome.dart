// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:flutterdemo02/res/ColorSettings.dart';
// import 'package:flutterdemo02/res/listData.dart';
// import 'package:http/http.dart' as http;

// import '../../components3/components3_second/image_map.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   // Future getUserData()async{
//   //   var response = await http.get(Uri.https('https://hello-cycu-delivery-service.herokuapp.com', '/member/store'));
//   //   var jsonData = jsonDecode(response.body);

//   // }
//   late Map jsondata;

//    _getUserData()async{
//     var apiUri = Uri.parse('https://hello-cycu-delivery-service.herokuapp.com/member/store');
//     var response = await http.get(apiUri,headers: {'token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhbGdvcml0aG0iOiJIUzI1NiIsImV4cCI6MTY0ODAyNDcyOSwiZGF0YSI6IjYxYzAwYzVlOTMxOTQ3MzFiZGU4OWE2ZiIsImlhdCI6MTY0ODAyMjkyOX0.tTiupdYPkS-FbWkc8bn_OHWtfhLLsfJIPAz4vwvNUOo'
//     });
//      jsondata = json.decode(response.body);

//     debugPrint(jsondata.toString());

//   }
//    @override
//   void initState() {
//      _getUserData();

//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: FutureBuilder(
//         future: _getUserData(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//               return Text('input something');
//             case ConnectionState.waiting:
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             case ConnectionState.active:
//               return Text('');
//             case ConnectionState.done:
//               if (snapshot.hasError) {
//                 return Text(
//                   '${snapshot.error}',
//                   style: TextStyle(color: Colors.red),
//                 );
//               }else{
//                 return CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             // expandedHeight: 200,
//             // pinned: true,
//             // stretch: true,
//             // flexibleSpace: FlexibleSpaceBar(
//             //   name: Text(
//             //     'My App Bar',
//             //     style: TextStyle(color: Colors.amber),
//             //   ),
//             // ),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: Column(
//               children: [
//                 Center(
//                   child: Text(
//                     "中原大".toUpperCase(),
//                     style: Theme.of(context)
//                         .textTheme
//                         .caption!
//                         .copyWith(color: kActiveColor),
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     "foodone",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ],
//             ),
//             leading: Container(),
//             actions: [
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   'Filter',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               )
//             ],
//           ),
//           // SliverPadding(
//           //   padding: EdgeInsets.symmetric(
//           //     horizontal: defaultPadding,
//           //     vertical: 5,
//           //   ),
//           //   sliver: SliverToBoxAdapter(
//           //     child: ImageCarousel(),
//           //   ),
//           // ),
//           SliverToBoxAdapter(
//             child: ElevatedButton(
//               child: Text("dnsk"),
//               onPressed: (){

//               },
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(
//                   demoBigImages2.length,
//                   (index) => RestaurantInfoMediaCard(
//                     name: demoBigImages2[index]['name'],
//                     locationname: demoBigImages2[index]['locationname'],
//                     image:'images/pexels-photo-2182979.jpeg',
//                     press: () {},
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: EdgeInsets.symmetric(horizontal: defaultPadding),
//             sliver: SliverToBoxAdapter(
//               child: SectionTitle(
//                 title: "New Partners",
//                 press: () {

//                 },
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate([
//               SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(
//                   children: List.generate(
//                     jsondata.length,
//                     (index) => imageItems(
//                         name: jsondata['result'][index]['name'],
//                         location: jsondata['result'][index]['name'],
//                         image: 'images/pexels-photo-628776.jpeg',
//                         press: () {

//                           Navigator.pushNamed(context, '/form2',arguments: {
//                             'vaLue' : jsondata['result'][index]['id']
//                           });
//                         }),
//                   ),
//                 ),
//               )
//             ]),
//           ),
//         ],
//       );
//               }
//           }
//         },
//       ),
//     );
//   }
// }

// class User{
//   final String name,address;
//   User(this.name,this.address);
// }
