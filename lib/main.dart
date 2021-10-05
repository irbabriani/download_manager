import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_flutter_structure/config/app_routes.dart';
import 'package:my_flutter_structure/config/app_theme.dart';
import 'package:my_flutter_structure/presentation/authentication/authentication_cubit.dart';
import 'package:my_flutter_structure/presentation/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:my_flutter_structure/presentation/screens/dashboard/dashboard.dart';
import 'package:my_flutter_structure/presentation/screens/sign_up/cubit/sign_up_cubit.dart';
import 'package:my_flutter_structure/presentation/screens/sign_up/sign_up.dart';
import 'package:my_flutter_structure/presentation/screens/sing_in/cubit/sign_in_cubit.dart';
import 'package:my_flutter_structure/presentation/screens/sing_in/sign_in.dart';
import 'package:my_flutter_structure/presentation/screens/splash/splash.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}

void main() async {
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['en_US', 'fa'],
  );
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  runApp(BlocProvider<AuthenticationCubit>(
    create: (context) => AuthenticationCubit()..appStarted(),
    child:  LocalizedApp(
      delegate,
      MyFlutterStructure(),
    ),
  ));
}

class MyFlutterStructure extends StatefulWidget {
  @override
  _MyFlutterStructureState createState() => _MyFlutterStructureState();
}

class _MyFlutterStructureState extends State<MyFlutterStructure> {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate,
        ],
        onGenerateRoute: _registerRoutesWithParameters,
        supportedLocales: localizationDelegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: localizationDelegate.currentLocale,
        title: translate('app_bar.main.title'),
        theme: AppTheme.of(context),
        routes: _registerRoutes(),
      ),
    );
  }
  Route _registerRoutesWithParameters(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return Text("");
          },
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return Text("");
          },
        );

    }
  }
  Map<String, WidgetBuilder> _registerRoutes() {
    return <String, WidgetBuilder>{
      AppRoutes.splash: (context) => SplashScreen(),
      AppRoutes.signIn: (context) => _buildSignInBloc(),
      AppRoutes.signUp: (context) => _buildSignUpBloc(),
      AppRoutes.authPath: (context) =>
          BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return _buildDashboardCubit();
                } else {
                  return _buildSignInBloc();
                }
              }),
    };
  }
  BlocProvider<SignInCubit> _buildSignInBloc() {
    return BlocProvider<SignInCubit>(
      create: (context) => SignInCubit(
        authenticationCubit: BlocProvider.of<AuthenticationCubit>(context),
      ),
      child: SignInScreen(),
    );
  }
  BlocProvider<DashboardCubit> _buildDashboardCubit() {
    return BlocProvider<DashboardCubit>(
      create: (context) => DashboardCubit(),
      child: DashboardScreen(),
    );
  }
  BlocProvider<SignUpCubit> _buildSignUpBloc() {
    return BlocProvider<SignUpCubit>(
      create: (context) => SignUpCubit(),
      child: SignUpScreen(),
    );
  }
}
