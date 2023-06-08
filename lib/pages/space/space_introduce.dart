import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:space_chat/bloc/models/user_model.dart';

class SpaceIntroduce extends StatelessWidget {
  const SpaceIntroduce({super.key, required this.currentUser});
  final User currentUser;
  @override
  Widget build(BuildContext context) {
    final id = currentUser.id;
    final username = currentUser.username ?? 'Anonimus';
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Chat App',
              style: TextStyle(
                color: Color(int.parse('000000', radix: 16)).withOpacity(1.0),
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Image.asset(
                  'assets/images/emptyPhoto.jpg',
                  width: 213,
                  height: 213,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'ID ${id.toString()}',
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              username,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 40,
            ),
            GFButton(
              onPressed: () {
                Navigator.pushNamed(context, '/space_chat',
                    arguments: {"user": currentUser});
              },
              textStyle: const TextStyle(color: Colors.white),
              child: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                width: 200,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Enter chat id'),
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
