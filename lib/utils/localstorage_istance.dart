import 'dart:convert';
import 'dart:js_interop';
import 'package:collection/collection.dart';

import 'package:localstorage/localstorage.dart';
import 'package:space_chat/constant/key_shared.dart' as constant;
import 'package:space_chat/bloc/models/user_model.dart';

class LocalstorageInstance {
  LocalstorageInstance() : super() {
    //Вот тут он инициализируеться в конструкторе
    _init();
  }

  late LocalStorage storage;

  // Этот метод выполняеться всегда при инициализации этого класса он нам нужен чтоб инициализировать LocalStorage
  void _init() {
    storage = LocalStorage('localstorage.json');
  }

  // Нужен этот метод чтоб проверить работает ли у нас Localstorage нужен в отдельном случае чтоб брать оттуда user
  Future<bool> checkReadyStorage() {
    storage = LocalStorage('localstorage.json');
    return storage.ready;
  }

  // ГЕТТЕР (Getter-> нужен для того чтоб брать поля(переменые) нашего класса)

  //В этом геттере мы берем проинициалированый storage в котором есть его
  //стандартные методы, нужен нам чтоб получать нужные методы из вне класса

  LocalStorage get getStorageInstance {
    return storage;
  }

// Получаем последнее ID которое есть в нашем store(хранилище)
  int getLastId() {
    int? id = storage.getItem(constant.idKey);
    return id ?? 0;
  }

// Устанавливаем последнее ID в нашем store(хранилище)
  void setLastId(int id) {
    storage.setItem(constant.idKey, id);
  }

  // Очищаем нужное для нас поле , потому что мы не можем стандартно очищать конкретное поле (stora)

  // Мы сделали надстройкой которое получает очищаемое поле
  // мы берем все поля и чистим все и перезаписываем в чистый (store) поля которые нам нужны

  void clearFieldStorage(String nameField) {
    //Берем все поля которые есть в эти переменые что б они у нас хранились тут и не удалились со всем
    int? idData = storage.getItem(constant.idKey);
    List<String> userData = getUserStorage();
    //Чистим весь (store) - потому что мы можем почистить все только
    storage.clear();
    //Записываем нужные нам поля в (store) заново
    nameField == constant.idKey
        ? storage.setItem(constant.userStore, userData)
        : storage.setItem(constant.idKey, idData ?? 0);
  }

  //Очищаем все
  void clearAll() {
    storage.clear();
  }

  //Берем все user которые у нас храняться в (store) - Нужно для того чтоб не делать новые запросы в firebase
  //а брать нужного user в нашем (store)
  List<String> getUserStorage() {
    final List<String>? storageUser =
        storage.getItem(constant.userStore)?.cast<String>();
    return storageUser ?? [];
  }

  //Записываем user в (store)-> чтоб у нас они сохранялись
  void setUserToStrage({required User user}) {
    //Тут берем всех наших юзеров которые уже есть
    var existingStorage = getUserStorage();
    //Приводим в нужный формат user которого нам передали
    var userJson = jsonEncode(user.toJson());
    //Создаем List  вкотором будут все user  и тот которого нам передали и те которые уже были
    var combinedList = [...existingStorage, userJson];
    storage.setItem(constant.userStore, combinedList);
  }

  //Механизм поиска в сторе user
  User? findUserInStorage({required email}) {
    //Берем все user из нашего (store)
    List<String> userData = getUserStorage();
    // проверяем есть ли у нас он
    if (userData.isNotEmpty) {
      // Проходимся по всем юзерам которые есть у нас в (store)
      List<User?> user = userData
          .map((user) {
            // Возвращаем отсюда user в нужном для нас формате чтоб они были не в User model а в Json
            return User.fromJson(jsonDecode(user));
          })
          .toSet()
          .toList();
      // Пытаемся найти юзера в нашем переработаном List
      //сравневая email который нам передали с каждым user.email которые храняться у нас в (store)
      User? userFound = user.firstWhereOrNull((user) {
        return user?.email == email;
      });
      return userFound;
    }
    return null;
  }

  // сдесь мы добавляем текущего юзера чтоб он был у нас всегда до тех пор если мы не сделаем логоут
  void setCurrentUser({required User user}) {
    storage.setItem(constant.currentUser, jsonEncode(user.toJson()));
  }

// через этот метод мы получаем текущего юзера !
  User? getCurrentUser() {
    String? storageUser = storage.getItem(constant.currentUser);

    if (storageUser.isNull) {
      return null;
    }
    return User.fromJson(jsonDecode(storageUser!));
  }
}
