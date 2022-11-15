import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:download_manager/presentation/screens/sign_up/cubit/sign_up_cubit.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit,SignUpState>(
      listener: (context,state){},
      builder: (context,state){
        return Text("");
      },
    );
  }
}
