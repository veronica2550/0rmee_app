import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';

class MypageVersion extends StatelessWidget {
  const MypageVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrmeeAppBar(
        title: '버전',
        isLecture: false,
        isImage: false,
        isDetail: false,
        isPosting: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/warning.svg'),
            SizedBox(width: 6),
            Headline2SemiBold16(text: 'v.3.61.0'),
            Spacer(),
            Body2RegularNormal14(text: '최신 버전이에요', color: OrmeeColor.gray[50]),
            Body2RegularNormal14(
              text: '업데이트가 필요해요',
              color: OrmeeColor.purple[50],
            ),
          ],
        ),
      ),
    );
  }
}
