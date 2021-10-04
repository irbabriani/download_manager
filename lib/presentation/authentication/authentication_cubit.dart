
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:my_flutter_structure/config/storage.dart';

import 'package:equatable/equatable.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(Uninitialized());
  Future appStarted() async {
    var userInfo = await getToken();
    if(userInfo.userId!=null){
      if (userInfo.emailConfirmed == true) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    }else{
      emit(Unauthenticated());
    }
  }

  Future<void> loggedIn(String userInfo) async {
    Storage().userInfo = userInfo;
    await _saveToken(userInfo);
    emit(Authenticated());
  }

  Future<UserInfoEntity> getToken() async {
    var userInfo = await _getToken();
    return userInfo;
  }

  Future<void> loggedOut() async {
    // Storage().token = '';
    await _deleteToken();
    emit(Unauthenticated());
  }

  /// delete from keystore/keychain
  Future<void> _deleteToken() async {
    await Storage().secureStorage.delete(key: 'UserInfo');
  }

  /// write to keystore/keychain
  Future<void> _saveToken(String userInfo) async {
    await Storage()
        .secureStorage
        .write(key: 'UserInfo', value: userInfo);
  }

  /// read to keystore/keychain
  Future<UserInfoEntity> _getToken() async {
    var userInfoStr = await Storage().secureStorage.read(key: 'UserInfo') ?? '';
    if(userInfoStr.isNotEmpty){
      var userInfo =UserInfoEntity.fromJson(json.decode(userInfoStr));
      return userInfo;
    }else{
      return UserInfoEntity();
    }
  }
}