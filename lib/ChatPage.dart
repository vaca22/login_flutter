import 'dart:async';
import 'dart:convert' as convert;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_flutter/common/Global.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'User.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.title, required this.orderNo})
      : super(key: key);
  final String orderNo;

  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}



class _ChatPageState extends State<ChatPage> {
  late TextEditingController textEditingController;
  ScrollController _scrollController = ScrollController();
  late double contentMaxWidth;
  late String userId;
  late String employeeNo;
  late String userName;
  final url=Uri.parse('ws://139.9.206.3:13209/ws?uid=456&fa=234');
  IOWebSocketChannel? channel ;

  wserror(err) async {
    print(DateTime.now().toString() + " Connection error: $err");
    await reconnect();
  }
  reconnect() async {
    if (channel != null) {
      // add in a reconnect delay
      await Future.delayed(Duration(seconds: 4));
    }
    setState(() {
      print(DateTime.now().toString() + " Starting connection attempt...");
      channel = IOWebSocketChannel.connect(url);
      print(DateTime.now().toString() + " Connection attempt completed.");
    });
    channel?.stream.listen((data) => addMessage2(data), onDone: reconnect, onError: wserror, cancelOnError: true);
  }


  @override
  void initState() {
    super.initState();
    reconnect();
    textEditingController = TextEditingController();
    initData();
  }

  initData() async {
    employeeNo = "50";
    userId = "54";
    userName = "我";
    String url = 'eReplyList';

    setState(() {
      // list = (res.data as List).reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    contentMaxWidth = MediaQuery.of(context).size.width - 90;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('哈哈'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFF1F5FB),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                //列表内容少的时候靠上
                alignment: Alignment.topCenter,
                child: _renderList(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                      constraints: BoxConstraints(
                        maxHeight: 100.0,
                        minHeight: 50.0,
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFFF5F6FF),
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      child: TextField(
                        controller: textEditingController,
                        cursorColor: Color(0xFF464EB5),
                        maxLines: null,
                        maxLength: 200,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
                          hintText: "回复",
                          hintStyle:
                              TextStyle(color: Color(0xFFADB3BA), fontSize: 15),
                        ),
                        style:
                            TextStyle(color: Color(0xFF03073C), fontSize: 15),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      alignment: Alignment.center,
                      height: 70,
                      child: Text(
                        '发送',
                        style: TextStyle(
                          color: Color(0xFF464EB5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onTap: () {
                      sendTxt();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List list = []; //列表要展示的数据

  _renderList() {
    return GestureDetector(
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 27),
        itemBuilder: (context, index) {
          var item = list[index];
          return GestureDetector(
            child: item['employeeNo'] == employeeNo
                ? _renderRowSendByMe(context, item)
                : _renderRowSendByOthers(context, item),
            onTap: () {},
          );
        },
        itemCount: list.length,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget _renderRowSendByOthers(BuildContext context, item) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: <Widget>[
          Padding(
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA1A6BB),
                fontSize: 14,
              ),
            ),
            padding: EdgeInsets.only(bottom: 20),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 45),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xFF464EB5),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    child: Text(
                      item['name'].toString().substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    padding: EdgeInsets.only(bottom: 2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text(
                          item['name'],
                          softWrap: true,
                          style: TextStyle(
                            color: Color(0xFF677092),
                            fontSize: 14,
                          ),
                        ),
                        padding: EdgeInsets.only(left: 20, right: 30),
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            // child: Image(
                            //     width: 11,
                            //     height: 20,
                            //     image: AssetImage(
                            //         "assets/images/a940.png")),
                            margin: EdgeInsets.fromLTRB(2, 16, 0, 0),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(4.0, 7.0),
                                    color: Color(0x04000000),
                                    blurRadius: 10,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(top: 8, left: 10),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              item['reply'],
                              style: TextStyle(
                                color: Color(0xFF03073C),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderRowSendByMe(BuildContext context, item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: <Widget>[
          const Padding(
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFA1A6BB),
                fontSize: 14,
              ),
            ),
            padding: EdgeInsets.only(bottom: 20),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: Color(0xFF464EB5),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  child: Text(
                    item['name'].toString().substring(0, 1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  padding: EdgeInsets.only(bottom: 2),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    child: Container(),
                    padding: EdgeInsets.only(right: 20),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        child: const Image(
                            width: 11,
                            height: 20,
                            image: AssetImage("assets/images/a940.png")),
                        margin: EdgeInsets.fromLTRB(0, 16, 2, 0),
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          ConstrainedBox(
                            child: Container(
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(4.0, 7.0),
                                      color: Color(0x04000000),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  color: Color(0xFF838CFF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                item['reply'],
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: contentMaxWidth,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
                              child: Container()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  final int maxValue = 1 << 32;

  sendTxt() async {
    int tag = random.nextInt(maxValue);

    String message = textEditingController.value.text;
    addMessage(message, tag);
    String fuck =
        convert.jsonEncode(User(Global.phone, 'toid', message).toJson());
    channel?.sink.add(fuck);
    textEditingController.text = '';
  }

  final random = Random();

  addMessage(content, tag) {
    int time = new DateTime.now().millisecondsSinceEpoch;
    setState(() {
      list.insert(0, {
        "createdAt": time,
        "cusUid": userId,
        "employeeNo": employeeNo,
        "name": userName,
        "orderNo": widget.orderNo,
        "reply": content,
        "updatedAt": time,
        'status': SENDING_TYPE,
        'tag': '${tag}',
      });
    });
    Timer(Duration(milliseconds: 100), () => _scrollController.jumpTo(0));
  }

  addMessage2(content) {
    var nn1=convert.jsonDecode(content);
    String nn2=nn1["id"];
    String nn3=nn1["params"];
    int tag = random.nextInt(maxValue);

    int time = new DateTime.now().millisecondsSinceEpoch;
    setState(() {
      list.insert(0, {
        "createdAt": time,
        "cusUid": userId,
        "employeeNo": "0",
        "name": nn2,
        "orderNo": widget.orderNo,
        "reply": nn3,
        "updatedAt": time,
        'status': SENDING_TYPE,
        'tag': '${tag}',
      });
    });
    Timer(Duration(milliseconds: 100), () => _scrollController.jumpTo(0));
  }

  static int SENDING_TYPE = 0;
  static int FAILED_TYPE = 1;
  static int SUCCESSED_TYPE = 2;
}
