import 'dart:js_interop';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_chat/bloc/auth/auth_state.dart';
import 'package:space_chat/bloc/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:space_chat/bloc/auth/auth_events.dart';
import 'package:space_chat/utils/localstorage_istance.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _firebase = firebase_auth.FirebaseAuth.instance;
  final _storage = LocalstorageInstance();
  AuthBloc() : super(AuthInitialState()) {
    on<AuthCheckEvent>(_checkHandler);
    on<AuthCreateEvent>(_createHandler);
  }

  _checkHandler(AuthCheckEvent event, Emitter emitter) async {
    //сдесь мы получаем последнюю айди которая у нас есть в хранилище(storage) ->  , это поле обнуляеться через какое-то время
    final int currentId = _storage.getLastId();

//Пытаемся найти юзера в нашем хранилище (storage) ->
    final User? cacheUser = _storage.findUserInStorage(email: event.email);

//Проверяем если юзера в нашем хранилище (storage) -> если есть то он выходит с if и с функции _chechHandler
    if (!cacheUser.isNull) {
      emitter(AuthFirebaseState(user: cacheUser!));
      return;
    }

    //Если такого значения нет то делаем запрос на firebase.instanse;

    try {
      final user = await _firebase.signInWithEmailAndPassword(
          email: event.email, password: event.password);

      final userWritten = User(
          id: currentId,
          username: user.user?.displayName,
          email: user.user?.email,
          photoUrl: user.user?.photoURL);

      emitter(AuthFirebaseState(user: userWritten));

      //Записуем в массив юзеров которых мы входили возможно тут задатут вопрос зачем это нужно ты скажи чтоб если мы входили когда-то
      // с такого же юзера чтоб он не делал заново запрос в фаербейс а сразу брал с кешей!
      _storage.setUserToStrage(user: userWritten);

      // Сдесь мы устанавливаем текущего юзера
      _storage.setCurrentUser(user: userWritten);

      //увеличуем текущий id
      _storage.setLastId(currentId + 1);
    } catch (error) {
      if (error is firebase_auth.FirebaseAuthException) {
        emitter(AuthFirebaseFailure(error: error.message));
      }
    }

    // Добавляем в наш массив с юзерами в Cache;
  }

  _createHandler(AuthCreateEvent event, Emitter emitter) async {
    final int currentId = _storage.getLastId();
    // Все просто тут мы сразу пробуем зарегестрировать в firebase
    try {
      await _firebase.createUserWithEmailAndPassword(
          email: event.email, password: event.password);

      if (_firebase.currentUser.isDefinedAndNotNull) {
        await _firebase.currentUser!.updateDisplayName(event.username);

        final userRaw = _firebase.currentUser;
        if (userRaw.isDefinedAndNotNull) {
          final user = User(
              id: currentId,
              username: userRaw?.displayName,
              email: userRaw?.email,
              photoUrl: userRaw?.photoURL);

          if (user.isDefinedAndNotNull) {
            emitter(AuthFirebaseState(user: user));
            //устанавливаем и тут юзера карент чтоб иметь в дальнешем над ним котроль
            _storage.setCurrentUser(user: user);
          }
        }
      }
    } catch (error) {
      if (error is firebase_auth.FirebaseAuthException) {
        emitter(AuthFirebaseFailure(error: error.message));
      }
    }

    //Меняем значение локалсторадж
    _storage.setLastId(currentId + 1);
  }
}
