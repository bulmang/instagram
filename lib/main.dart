import 'package:flutter/material.dart';
import './style.dart' as style; //다트파일 가져오기
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(
      MaterialApp(
          theme: style.theme,
          home: MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var tab = 0;
  var map = {'name':'하명관' , 'age': 24} ; // map 자료


  getData() async { // await 사용하려면 async 붙어야한다.
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    //MyApp widget 이 로드될때 실행됨. http.get이 오래걸리는 함수 (Future)
    var result2 = jsonDecode(result.body);
    print(result2);
    print(result2[0]['likes']);

    var id = (result2[0]['id']);
    var image = (result2[0]['image']);
    var likes = (result2[0]['likes']);
    var data = (result2[0]['date']);
    var content = (result2[0]['content']);
    var liked = (result2[0]['likded']);
    var user = (result2[0]['user']);

  }

  @override
  void initState()  {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Instargram'),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: (){},
              iconSize: 30,
            )
          ]
        ),
      body: [Home(),Text("shop")][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, // 라벨제거
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        }, // 누르면 실행됨. 파라미터 입력 필수
        items: [

          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'shop'),

        ],
      )

    );
  }
}
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: 3,itemBuilder: (c,i){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network('https://codingapple1.github.io/app/car0.png'), // 웹 이미지주소
          Text('좋아요 100'),
          Text('글쓴이'),
          Text('글내용'),
        ],
      );
    });
  }
}


