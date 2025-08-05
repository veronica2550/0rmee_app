import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/feature/auth/signup/bloc/signup_bloc.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';

class TermsBottomModal extends StatelessWidget {
  final SignUpBloc signUpBloc;
  final VoidCallback? onAccepted;

  const TermsBottomModal({
    super.key,
    required this.signUpBloc,
    this.onAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: signUpBloc,
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          final bloc = context.read<SignUpBloc>();

          return Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: OrmeeColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 30),
                      Heading2SemiBold20(text: '오르미 서비스 약관에 동의해 주세요.'),
                      SizedBox(height: 20),

                      // 전체 동의
                      GestureDetector(
                        onTap: () => bloc.add(
                          AllTermsToggled(value: !state.isAllTermsChecked),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              state.isAllTermsChecked
                                  ? 'assets/icons/box=true.svg'
                                  : 'assets/icons/box=false.svg',
                            ),
                            SizedBox(width: 10),
                            Headline2SemiBold16(text: '약관 전체 동의'),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      _TermsTile(
                        value: state.terms1,
                        required: true,
                        content: '이용약관 동의',
                        onTap: () => bloc.add(
                          TermsToggled(index: 1, value: !state.terms1),
                        ),
                      ),
                      _TermsTile(
                        value: state.terms2,
                        required: true,
                        content: '개인정보 수집 및 이용 동의',
                        onTap: () => bloc.add(
                          TermsToggled(index: 2, value: !state.terms2),
                        ),
                      ),
                      _TermsTile(
                        value: state.terms3,
                        required: false,
                        content: '이벤트, 마케팅 및 혜택 알림 동의',
                        onTap: () => bloc.add(
                          TermsToggled(index: 3, value: !state.terms3),
                        ),
                      ),
                      SizedBox(height: 36),
                    ],
                  ),
                ),

                OrmeeBottomSheet(
                  text: "다음",
                  isCheck: state.isRequiredTermsChecked,
                  onTap: () {
                    if (state.isRequiredTermsChecked) {
                      Navigator.pop(context);
                      if (onAccepted != null) {
                        onAccepted!();
                      } else {
                        bloc.add(const SubmitSignUp());
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TermsTile extends StatelessWidget {
  final bool value;
  final bool required;
  final String content;
  final VoidCallback onTap;

  const _TermsTile({
    required this.value,
    required this.required,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/check_24.svg',
              color: value ? OrmeeColor.purple[50] : OrmeeColor.gray[60],
            ),
            SizedBox(width: 20),
            Body2RegularNormal14(
              text: required ? '(필수)' : '(선택)',
              color: OrmeeColor.gray[60],
            ),
            SizedBox(width: 6),
            Body2SemiBoldNormal14(text: content, color: OrmeeColor.gray[60]),
            Spacer(),
            SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              color: OrmeeColor.gray[30],
            ),
          ],
        ),
      ),
    );
  }
}
