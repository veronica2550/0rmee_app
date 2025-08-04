import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/feature/mypage/version/bloc/version_bloc.dart';
import 'package:ormee_app/feature/mypage/version/bloc/version_event.dart';
import 'package:ormee_app/feature/mypage/version/bloc/version_state.dart';
import 'package:ormee_app/feature/mypage/version/data/remote_datasource.dart';
import 'package:ormee_app/feature/mypage/version/data/repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';

class MypageVersion extends StatelessWidget {
  const MypageVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VersionBloc(VersionRepository(VersionRemoteDataSource()))
            ..add(LoadVersionInfo()),
      child: const MypageVersionView(),
    );
  }
}

class MypageVersionView extends StatelessWidget {
  const MypageVersionView({super.key});

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
      body: BlocBuilder<VersionBloc, VersionState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/warning.svg'),
                const SizedBox(width: 6),
                _buildVersionText(state),
                const Spacer(),
                _buildStatusText(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVersionText(VersionState state) {
    if (state is VersionLoaded) {
      return Headline2SemiBold16(text: 'v.${state.versionInfo.latestVersion}');
    } else if (state is VersionLoading) {
      return const Headline2SemiBold16(text: '로딩 중...');
    } else if (state is VersionError) {
      return const Headline2SemiBold16(text: '버전 정보 없음');
    }
    return const Headline2SemiBold16(text: 'v.1.0.0');
  }

  Widget _buildStatusText(VersionState state) {
    if (state is VersionLoaded) {
      if (state.versionInfo.isLatest) {
        return Body2RegularNormal14(
          text: '최신 버전이에요',
          color: OrmeeColor.gray[50],
        );
      } else {
        return Body2RegularNormal14(
          text: '업데이트가 필요해요',
          color: OrmeeColor.purple[50],
        );
      }
    } else if (state is VersionLoading) {
      return Body2RegularNormal14(text: '확인 중...', color: OrmeeColor.gray[50]);
    } else if (state is VersionError) {
      return Body2RegularNormal14(text: '확인 실패', color: OrmeeColor.gray[50]);
    }
    return Body2RegularNormal14(text: '최신 버전이에요', color: OrmeeColor.gray[50]);
  }
}
