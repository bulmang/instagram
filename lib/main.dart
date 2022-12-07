import 'package:flutter/material.dart';
import './style.dart' as style; //다트파일 가져오기
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; // 스크롤 관련 유용한 함수들이 들어와 있음.
import 'package:image_picker/image_picker.dart'; // imagepicker
import 'dart:io'; 

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
  var data = [];
  var userImage;
  var userContent;

  addMyData(){
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0,myData); // 리스트 맨압에 추가할수 있음
    });
  }

  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }

  addData(a){
    setState(() {
      data.add(a);
    });
  } // state 수정

  getData() async { // await 사용하려면 async 붙어야한다.
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    //MyApp widget 이 로드될때 실행됨. http.get이 오래걸리는 함수 (Future : 오래걸리는 것)
    if (result.statusCode == 200) { //get요청이 성공하면 200이남음 , 실패하면 400,500
      //성공하면 요청
    } else {

    } // 실패하면 요청
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });

  }


  @override
  void initState()  {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) { // context : materiaapp 정보를가지고잇음
    return Scaffold(
        appBar: AppBar(
          title: Text('Instargram'),
          actions: [
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () async {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 가져오기
                if (image != null){
                  setState((){
                    userImage = File(image.path); // path는 이미지 경로
                  });
                }


                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => Upload(
                        userImage : userImage, setUserContent : setUserContent,
                        addMyData : addMyData,
                    ) )
                );// navigator 페이지 이동가능
              },
              iconSize: 30,
            )
          ]
        ),
      body: [Home(data : data, addData : addData),Text("shop")][tab],
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
class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController(); // 스크롤 정보들을 가져옴

  getMore() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() { // addListener : 왼쪽 변수가 변할때마다 실행 해줌
      if (scroll.position.pixels == scroll.position.maxScrollExtent){ // 맨 밑까지 스크롤 했을 때 
         getMore();// 게시물 더가져오기
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty){ // 데이터 로딩이 되면 보여줌
      return ListView.builder(itemCount: 3,controller: scroll,itemBuilder: (c,i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data[i]['image'].runtimeType == String
                ? Image.network(widget.data[i]['image'])
                : Image.file(widget.data[i]['image']),
             // 웹 이미지주소
            Text('좋아요 ${widget.data[i]['likes']}'),
            Text('글쓴이 :${widget.data[i]['user']}'),
            Text('날짜 : ${widget.data[i]['date']}'),
            Text(widget.data[i]['content']),
          ],
        );
      });
    }else{
      return Text('로딩중'); // 데이터가 들어오기전 에 보여줌
    }
  }
}
class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( actions: [
        IconButton(onPressed: (){
          addMyData();
        }, icon: Icon(Icons.send))
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('image upload'),
          TextField(onChanged: (text){
            setUserContent(text);
          },), // 텍스트 값이 변할때 마다 실행됨.
          IconButton(onPressed: (){
            Navigator.pop(context);
          },
              icon: Icon(Icons.close)
          )
        ],
      ),
    );
  }
}


