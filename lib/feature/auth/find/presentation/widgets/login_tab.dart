import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

Widget LoginTab(BuildContext context) {
  final TextEditingController _name_controller = TextEditingController();
  final FocusNode _name_focusNode = FocusNode();
  final TextEditingController _phone1_controller = TextEditingController();
  final FocusNode _phone1_focusNode = FocusNode();
  final TextEditingController _phone2_controller = TextEditingController();
  final FocusNode _phone2_focusNode = FocusNode();
  final TextEditingController _phone3_controller = TextEditingController();
  final FocusNode _phone3_focusNode = FocusNode();
  return Scaffold(
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 51),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Body2SemiBoldNormal14(text: '이름'),
          SizedBox(height: 4),
          OrmeeTextField(
            controller: _name_controller,
            focusNode: _name_focusNode,
            textInputAction: TextInputAction.next,
            onTextChanged: (text) {},
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_phone1_focusNode);
            },
          ),
          SizedBox(height: 12),
          Body2SemiBoldNormal14(text: '연락처'),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OrmeeTextField(
                  controller: _phone1_controller,
                  focusNode: _phone1_focusNode,
                  textInputAction: TextInputAction.next,
                  onTextChanged: (text) {},
                  onFieldSubmitted: (_) {},
                ),
              ),
              SizedBox(
                width: 13,
                child: Center(child: Label1Regular14(text: "-")),
              ),
              Expanded(
                flex: 3,
                child: OrmeeTextField(
                  controller: _phone2_controller,
                  focusNode: _phone2_focusNode,
                  textInputAction: TextInputAction.next,
                  onTextChanged: (text) {},
                  onFieldSubmitted: (_) {},
                ),
              ),
              SizedBox(
                width: 13,
                child: Center(child: Label1Regular14(text: "-")),
              ),
              Expanded(
                flex: 3,
                child: OrmeeTextField(
                  controller: _phone3_controller,
                  focusNode: _phone3_focusNode,
                  textInputAction: TextInputAction.done,
                  onTextChanged: (text) {},
                  onFieldSubmitted: (_) {},
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    bottomSheet: OrmeeBottomSheet(
      text: "아이디 찾기",
      isCheck: true,
      onTap: () {
        OrmeeToast.show(context, "입력하신 정보와 일치하는 아이디가 없어요.", true);
        context.push('/find/login');
      },
    ),
  );
}
