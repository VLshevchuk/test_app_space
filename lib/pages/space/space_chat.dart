import 'dart:js_interop';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:space_chat/bloc/models/user_model.dart';
import 'package:space_chat/pages/auth/helpers.dart';
import 'package:space_chat/utils/firebase_model.dart';
import 'package:space_chat/widgets/messageUi/message_ui.dart';
import 'package:collection/collection.dart';

class SpaceChat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SpaceChatState();
  }
}

class SpaceChatState extends State<SpaceChat> {
  late User? currentUser;
  List<FirebaseModel> userMessage = [];
  final TextEditingController _sendMessage = TextEditingController();

  void _onTapMessage(dataBase) {
    //Берем текущее время
    String currentTime = getCurrentTime();
    //Получаем данные по нашему User
    final Map<String, dynamic> userDecode = currentUser!.toJson();
    late Map<String, dynamic>? messageData;

    //Получаем данные через нашу модель firebase чтоб данные были List<FirebaseModel>
    List<Map<String, dynamic>> firebaseUser = userMessage.map((firebase) {
      return firebase.toJson();
    }).toList();

    //Пытаемся найти нужного нам юзера и его данные чтоб перезаписать с новим message
    messageData = firebaseUser.firstWhereOrNull((user) {
      if (!userDecode.isNull) {
        return user['userData']['email'] == userDecode['email'];
      }
      return false;
    });

    //Если нашего user нет в firebase данных то мы просто создаем нового User firebase с его message
    if (messageData.isNull) {
      dataBase.set([
        ...firebaseUser,
        {
          "userData": {
            "id": userDecode['id'],
            "username": userDecode['username'] ?? 'unknow',
            "email": userDecode['email'],
            "photoUrl": userDecode['photoUrl'],
          },
          "messages": [
            {"message": _sendMessage.text, "date": currentTime}
          ]
        }
      ]);
      //Очищаем наш Input
      _sendMessage.clear();
      //Тут нужен return  потому что мы не хотим после
      //этой логики идити дальше мы просто выходим из функции (_onTapMessage)
      return;
    }

    //Тут удаляем дубликаты
    List<Map<String, dynamic>> uniqueList = removeDuplicates([
      ...firebaseUser,
      ...copyMessage(firebaseUser, currentUser!,
          {"message": _sendMessage.text, "date": currentTime})
    ]);

    //Записываем данные в database realtime
    dataBase.set(uniqueList);
    //Очищаем наш Input
    _sendMessage.clear();
  }

  @override
  void dispose() {
    _sendMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Получаем передаваемы через rout current user
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    currentUser = arguments?["user"];

    // Создаем database
    final DatabaseReference dataBase =
        FirebaseDatabase.instance.ref().child('spacechat');

    // Тут мы слушаем нашу database RealTime на изминения и закидываем их в наш state
    dataBase.onValue.listen((event) {
      if (!event.snapshot.value.isNull) {
        List eventsData = event.snapshot.value as List;
        List<FirebaseModel> firebaseData = eventsData.map((event) {
          List<Map<String, dynamic>> messages =
              (event['messages'] as List<dynamic>).map((message) {
            return message as Map<String, dynamic>;
          }).toList();
          return FirebaseModel(
              userData: event['userData'] as Map<String, dynamic>,
              messages: messages);
        }).toList();

        //Сравниваем данные чтоб он не дублировал и не перезаписывал миллион раз state
        // потому что event.snapshot.value мониториться постоянно
        bool isEqual =
            DeepCollectionEquality().equals(userMessage, firebaseData);

        // Проверяем если данные есть и они не повторяються то мы перезаписываем в наш state
        if (!event.snapshot.value.isUndefinedOrNull && !isEqual) {
          setState(() {
            userMessage = firebaseData;
          });
        }
      }
    });

    return !currentUser.isNull
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.blueAccent, // Устанавливаем цвет кнопки
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: TitleAppBar(
                  firebase: userMessage.map((fire) {
                return fire.toJson();
              }).toList()),
              backgroundColor: Colors.white,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  // Используем Expanded, чтобы ListView.builder занял доступное пространство
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: userMessage.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<Map<String, dynamic>> firebaseUser =
                          userMessage.map((firebase) {
                        return firebase.toJson();
                      }).toList();
                      return Column(
                        children: [
                          Column(
                            children: firebaseUser[index]['messages']
                                .map<Widget>((message) {
                              Map<String, dynamic> iterableUser =
                                  firebaseUser[index]['userData'];

                              Map<String, dynamic> convertUserData =
                                  currentUser!.toJson();

                              return MessageUI(
                                date: message['date'],
                                isMe: convertUserData['email'] ==
                                        iterableUser['email']
                                    ? true
                                    : false,
                                message: message['message'],
                                username: iterableUser['username'] ?? 'unknow',
                                jobTitle: 'unknow',
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top:
                          BorderSide(color: Color.fromRGBO(229, 229, 234, 1.0)),
                    ),
                  ),
                  height: 60,
                  child: TextField(
                    controller: _sendMessage,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Start typing...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(102, 102, 104, 1)),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (!currentUser.isNull) {
                            _onTapMessage(dataBase);
                          }
                          // Ваш обработчик нажатия
                        },
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: const Icon(
                          Icons.send,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: GFLoader(
                type: GFLoaderType.square,
                size: GFSize.LARGE,
              ),
            ),
          );
  }
}

class TitleAppBar extends StatelessWidget {
  TitleAppBar({required this.firebase});

  final List<Map<String, dynamic>> firebase;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        flex: 1,
        child: SizedBox(
          height: 60,
          child: Stack(
            children: [
              ...firebase.mapIndexed((index, user) {
                final String avatar = user['userData']['avatar'] ??
                    'assets/images/emptyPhoto.jpg';
                return Positioned(
                  top: 15,
                  left: index * 19,
                  child: GFAvatar(
                      size: 20,
                      //Тут нужно было проверить я почему то возвращаю с
                      //firebase null в String поэтому такая конструкция чтоб ошибка не падала
                      backgroundImage: Image.asset(avatar != "null"
                              ? avatar
                              : 'assets/images/emptyPhoto.jpg')
                          .image),
                );
              }),
            ],
          ),
        ),
      ),
      const Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            Text(
              'last seen 45 minutes ago',
              style: TextStyle(color: Color(0xFF666668), fontSize: 12),
            ),
          ],
        ),
      ),
    ]);
  }
}
