import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:download_manager/presentation/screens/sing_in/cubit/sign_in_cubit.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit,SignInState>(
      listener: (context,state){},
      builder: (context,state){
        return Text("");
      },
    );
  }
}
