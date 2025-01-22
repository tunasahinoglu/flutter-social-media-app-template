import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/scenes/home/home_page.dart';
import 'package:project_template/scenes/navigation/nav_bar.dart';
import 'package:project_template/scenes/navigation/nav_bloc/nav_bloc.dart';
import 'package:project_template/scenes/profile/profile_page.dart';
import 'package:project_template/core/user/user_repository.dart';
import 'package:project_template/scenes/theme/widgets/theme_switcher.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final PageController _pageController = PageController();
  final PageStorageBucket _bucket = PageStorageBucket();
  final ScrollController _homeScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UserRepository>();
    final currentUser = userRepository.currentUser;

    return BlocProvider(
      create: (_) => NavBloc(),
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          int selectedIndex = state is NavUpdated ? state.selectedIndex : 0;

          void onTabChange(int index) {
            context.read<NavBloc>().add(TabChangedEvent(index));
            _pageController.jumpToPage(index);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(tr('app.name'), style: AppTextStyles.headline),
              actions: [
                const ThemeSwitcher(),
                IconButton(
                    onPressed: () {
                      context.go('/settings');
                    },
                    icon: const Icon(Icons.settings))
              ],
            ),
            body: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) =>
                  context.read<NavBloc>().add(TabChangedEvent(index)),
              children: [
                PageStorage(
                  bucket: _bucket,
                  child: HomePage(scrollController: _homeScrollController),
                ),
                PageStorage(
                  bucket: _bucket,
                  child: ProfilePage(
                      userRepository: context.read<UserRepository>(), username: currentUser.username)
                      ,
                ),
              ],
            ),
            bottomNavigationBar: CustomNavBar(
              selectedIndex: selectedIndex,
              onTabChange: onTabChange,
              homeScrollController: _homeScrollController,
            ),
          );
        },
      ),
    );
  }
}
