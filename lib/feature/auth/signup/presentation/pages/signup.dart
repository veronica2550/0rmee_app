import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/signup_form.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: SignupContent(),
    );
  }
}

class SignupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: OrmeeAppBar(
          isLecture: false,
          isImage: false,
          isDetail: false,
          isPosting: false,
          title: "회원가입",
        ),
        body: SingleChildScrollView(
          child: BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state.isSuccess) {
                context.pop();
              }

              if (state.errorMessage != null) {
                OrmeeToast.show(context, state.errorMessage!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SignupForm(),
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            return OrmeeBottomSheet(
              text: "회원가입 완료하기",
              isCheck: state.isValid && !state.isLoading,
              onTap: () {
                context.read<SignUpBloc>().add(const SubmitSignUp());
              },
            );
          },
        ),
      ),
    );
  }
}
