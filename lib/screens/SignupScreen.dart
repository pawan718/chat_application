import 'package:chat_application/bloc/authentication_bloc.dart';
import 'package:chat_application/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../CusomizedData.dart';

class SignupScreen extends StatelessWidget {
  String email = "";
  String password = "";
  String name = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is LoggedInState) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (state is ErrorState) {
            Fluttertoast.showToast(msg: state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomizedTextField(
                  hinttext: 'name',
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomizedTextField(
                  hinttext: 'Email',
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);
                    print(emailValid);
                    if (value == null || value.isEmpty) {
                      return "email should not be empty";
                    }
                    if (!emailValid) {
                      return "email not valid";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomizedTextField(
                  hinttext: 'Password',
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Value should not be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                LoginSIngupButton(
                  text: 'Signup',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<AuthenticationBloc>()
                          .add(SignUpEvent(email, password, name));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
