import 'package:space_chat/bloc/models/user_model.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:js_interop';

bool isGmailEmail(String email) {
  final RegExp regex = RegExp(
    r'^[a-zA-Z0-9_.+-]+@gmail.com$',
    caseSensitive: false,
  );
  return regex.hasMatch(email);
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (!isGmailEmail(value)) {
    return 'Please enter a valid Gmail address';
  }
  // You can add more specific email validation logic here if needed
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  if (value.length < 6) {
    return 'Please enter min 6 char';
  }
  // You can add more specific password validation logic here if needed
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your username';
  }
  if (value.length < 6) {
    return 'Please enter word the contains min 6 char';
  }
  // You can add more specific password validation logic here if needed
  return null;
}

String? validateMessage(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your message';
  }

  // You can add more specific password validation logic here if needed
  return null;
}

// Это нам нужно чтоб он брал Message который мы отправляем из Input и
// нужно найти нам из всего обекта нужного для нас User и добавляем туда новый Message к старым Message
List<Map<String, dynamic>> copyMessage(

    // сдесь у нас храняться старые данные
    List<Map<String, dynamic>> preventMessage,
    User currentUser,
    Map<String, dynamic> updateMessage) {
  // Получаем нашего юзера в Json
  final Map<String, dynamic> userDecode = currentUser!.toJson();

  // Находим нужного нам юзера и его данные
  Map<String, dynamic>? messageData = preventMessage.firstWhereOrNull((user) {
    if (!currentUser.isNull) {
      String email = user['userData']['email'];
      return email == userDecode['email'];
    }
    return false;
  });

  // Если такого юзера нет, возвращаем предыдущие данные
  if (messageData.isNull) return preventMessage;

  // Создаем копию списка сообщений и добавляем новое сообщение
  List<dynamic> updateMessages = [...messageData!['messages'], updateMessage];

  // Создаем новую карту с обновленными данными пользователя и сообщениями
  Map<String, dynamic> updatedUserData = {
    ...messageData,
    'messages': updateMessages,
  };

  // Создаем новый список с обновленными данными пользователя и сообщениями
  List<Map<String, dynamic>> updatedPreventMessage = preventMessage
      .map((user) {
        String email = user['userData']['email'];
        if (email == userDecode['email']) {
          return updatedUserData;
        } else {
          return user;
        }
      })
      .toSet()
      .toList();

  return updatedPreventMessage;
}

List<Map<String, dynamic>> removeDuplicates(
    List<Map<String, dynamic>> inputList) {
  Map<String, Map<String, dynamic>> uniqueMap = {};

  // Создаем отображение, где ключом является значение поля "email", а значением - сам элемент
  for (var element in inputList) {
    String email = element['userData']['email'];
    uniqueMap[email] = element;
  }

  // Возвращаем только значения из отображения, чтобы получить список без дубликатов
  return uniqueMap.values.toList();
}

String getCurrentTime() {
  DateTime now = DateTime.now();
  String formattedTime = DateFormat('h:mm a').format(now);
  return formattedTime;
}
