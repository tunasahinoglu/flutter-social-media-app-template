import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/scenes/auth/auth_bloc/auth_bloc.dart';
import 'package:project_template/scenes/profile/profile_page.dart';
import 'package:project_template/core/user/user_repository.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;

  const HomePage({super.key, required this.scrollController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  bool _isDataFetched = false;

  @override
  bool get wantKeepAlive => true; 

  Future<void> _refreshData(BuildContext context) async {
    context.read<AuthBloc>().add(FetchUsersEvent());
  }

  @override
  void initState() {
    super.initState();
    if (!_isDataFetched) {
      context.read<AuthBloc>().add(FetchUsersEvent());
      _isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);  
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoadedState) {
            return RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: ListView.builder(
                controller: widget.scrollController,
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    title: Text(user.username, style: AppTextStyles.body),
                    subtitle: Text(user.email, style: AppTextStyles.body),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            userRepository: context.read<UserRepository>(),
                            username: user.username,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          } else if (state is AuthErrorState) {
            return Center(child: Text(state.errorText, style: AppTextStyles.body));
          } else {
            return  Center(child: Text(tr("no_data"), style: AppTextStyles.body));
          }
        },
      ),
    );
  }
}