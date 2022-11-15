
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:download_manager/config/storage.dart';

import 'package:equatable/equatable.dart';
import 'package:download_manager/domain/entities/user_info_entity.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(Uninitialized());
  Future appStarted() async {
    var userInfo = await getToken();
    if(userInfo.token!=""){
      emit(Authenticated());
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
      return UserInfoEntity(token: '',selectedTheme: '',selectedLanguage: '',role: '',firstName: '',lastName: '');
    }
  }
}