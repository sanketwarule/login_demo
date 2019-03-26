import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './blocs/authentication_bloc.dart';
import './blocs/events/navigation_events.dart';
import './blocs/navigation_bloc.dart';
import './blocs/states/navigation_state.dart';
import './blocs/form_bloc.dart';
import './routes/application.dart';
import './routes/routes.dart';
import '../src/utils/app_assets.dart';

class App extends StatefulWidget {
  final Widget child;

  App({Key key, this.child}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  NavigationBloc routeBloc;
  FormBloc formBloc;
  AuthenticationBloc authBloc;
  _AppState() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }
  void initState() {
    routeBloc = NavigationBloc();
    formBloc = FormBloc();
    authBloc=AuthenticationBloc();
    routeBloc.dispatch(GoHomeEvent());
    super.initState();
  }

  @override
  void dispose() {
    routeBloc.dispose();
    formBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = BlocProviderTree(
      blocProviders: [
        BlocProvider<NavigationBloc>(bloc: routeBloc),
        BlocProvider<FormBloc>(bloc: formBloc),
        BlocProvider<AuthenticationBloc>(bloc:authBloc)
      ],
      child: BlocBuilder(
        bloc: routeBloc,
        builder: (_, NavigationState state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primarySwatch: Colors.blue),
              title: 'Nsia Vie Assurances',
              color: NsiaAssets.bleu,
              //home: RootDrawer(),
              onGenerateRoute: Application.router.generator);
        },
      ),
    );

    return app;
  }
}
