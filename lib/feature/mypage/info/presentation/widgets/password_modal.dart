import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

class PasswordModal extends StatefulWidget {
  final String titleText;
  final String? icon;
  final void Function(String password) onConfirm;

  const PasswordModal({
    super.key,
    required this.titleText,
    required this.onConfirm,
    this.icon,
  });

  @override
  State<PasswordModal> createState() => _PasswordModalState();
}

class _PasswordModalState extends State<PasswordModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("비밀번호를 입력하세요.")),
      );
      return;
    }
    widget.onConfirm(_controller.text);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: OrmeeColor.white,
      surfaceTintColor: Colors.transparent,
      title: Center(
        child: Heading2SemiBold20(
          text: widget.titleText,
          color: OrmeeColor.gray[90],
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OrmeeTextField(
              hintText: '비밀번호 입력',
              controller: _controller,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleConfirm(),
              focusNode: _focusNode,
              isPassword: true,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OrmeeButton(
                    text: '취소',
                    isTrue: false,
                    falseAction: () => context.pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OrmeeButton(
                    text: '확인',
                    isTrue: true,
                    trueAction: _handleConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}