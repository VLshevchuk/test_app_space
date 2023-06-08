import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MessageUI extends StatelessWidget {
  MessageUI(
      {this.username = "unknow",
      this.jobTitle = "unknow",
      required this.message,
      required this.isMe,
      required this.date});

  final String message;
  final String? jobTitle;
  final String date;
  final String? username;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final shape = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          )
        : const BorderRadius.only(
            topRight: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          );

    double width = message.length * (message.length > 10 ? 10 : 7);
    width = width > 300 ? 300 : width;

    final MainAxisAlignment mainAxis =
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start;

    const SizedBox margin = SizedBox(
      height: 5,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe
            ? const SizedBox()
            : GFAvatar(
                size: 20,
                backgroundImage:
                    Image.asset('assets/images/emptyPhoto.jpg').image),
        GFCard(
          shape: RoundedRectangleBorder(
            borderRadius: shape,
          ),
          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 5, left: 5),
          color: isMe ? const Color(0xFF007AFF) : const Color(0xFFF2F2F7),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isMe
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: mainAxis,
                      children: [
                        Text(
                          username!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xDB878789),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          jobTitle!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666668),
                          ),
                        ),
                      ],
                    ),
              margin,
              Container(
                constraints: const BoxConstraints(
                  minWidth: 50, // Максимальная ширина контейнера
                ),
                width: width,
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: isMe ? Colors.white : const Color(0xFF2C2C2E),
                  ),
                ),
              ),
              margin,
            ],
          ),
          buttonBar: GFButtonBar(
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: width,
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white : const Color(0xFF2C2C2E),
                ),
              ),
              margin
            ],
          ),
        ),
      ],
    );
  }
}
