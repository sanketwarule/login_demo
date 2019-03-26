import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/events/form_events.dart';
import '../blocs/events/navigation_events.dart';
import '../blocs/events/authentication_events.dart';
import '../blocs/form_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../blocs/states/form_state.dart';
import '../resources/repository.dart';
import '../routes/routes.dart';
import '../utils/app_assets.dart';
import '../widgets/blinking_text.dart';

class LoginScreen extends StatefulWidget {
  final Widget child;

  LoginScreen({Key key, this.child}) : super(key: key);

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  Animation<Offset> slideIn;
  AnimationController controller; //textAController;
  NavigationBloc routeBloc;
  FormBloc formBloc;
  AuthenticationBloc authBloc;
  TextEditingController _loginController, _passwordController;
  Map<String, bool> formValid =
      {}; //cache pourchecker si tous leschamps sont valides
  String blinkingText;
  Color blinkingTextColor;
  FocusNode _loginFocus, _passwordFocus;
  //Animation<double> textup;
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _loginFocus = FocusNode();
    _passwordFocus = FocusNode();
    controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    /*textAController=AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this
    );
    textup=Tween<double>(begin: 0.0,end:)*/
    slideIn = Tween<Offset>(
            begin: Offset.fromDirection(0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    controller.forward();
    _loginController.addListener(onChangeLogin);
    _passwordController.addListener(onChangePassword);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _loginFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void onChangeLogin() {
    String value = _loginController.text;
    bool hasFocus = _loginFocus.hasFocus;
    String fieldType = "login";
    if (hasFocus && value.length > 0) {
      formBloc.dispatch(OnChangeFieldEvent(
          field: "login", fieldtype: fieldType, value: value));
    }
  }

  void onChangePassword() {
    String value = _passwordController.text;
    bool hasFocus = _passwordFocus.hasFocus;
    String fieldType = "password";
    if (hasFocus && value.length > 0) {
      formBloc.dispatch(OnChangeFieldEvent(
          field: "password", fieldtype: fieldType, value: value));
    }
  }

  Widget _buildSmartBlinkingText() {
    return BlocBuilder(
        bloc: formBloc,
        builder: (context, state) {
          debugPrint(
              'loginvalid=${formValid['login']},passwordvalid=${formValid['password']}');
          if (state is EmptyFieldsState) {
            blinkingText =
                "Accédez à votre portefeuille d'assurance en entrant vos identifiants ci-dessous";
            blinkingTextColor = NsiaAssets.bleu;
            formValid = {};
          } else if (state is ValidFieldState) {
            if (formValid.containsKey(state.field) &&
                formValid['${state.field}'] != true) {
              formValid['${state.field}'] = true;
              if (state.field == "login") {
                blinkingText = "Veuillez maintenant entrer votre mot de passe";
                blinkingTextColor = NsiaAssets.bleu;
              } else if (state.field == "password") {
                blinkingText =
                    "Vous avez préféré entrer votre mot de passe d'abords.\nEntrez maintenant votre login";
                blinkingTextColor = NsiaAssets.bleu;
              }
            } else if (!formValid.containsKey(state.field)) {
              formValid['${state.field}'] = true;
              if (state.field == "login" && formValid['password'] != true) {
                blinkingText = "Veuillez maintenant entrer votre mot de passe";
                blinkingTextColor = NsiaAssets.bleu;
              } else if (state.field == "password" &&
                  formValid['login'] != true) {
                blinkingText =
                    "Vous avez préféré entrer votre mot de passe d'abords.\nEntrew maintenant votre login";
                blinkingTextColor = NsiaAssets.bleu;
              }
            }
            if (formValid['login'] == true && formValid['password'] == true) {
              blinkingText = "Connectez vous !";
              blinkingTextColor = Colors.green;
            }
          } else if (state is InvalidFieldState) {
            formValid['${state.field}'] = false;
            blinkingText = state.error;
            blinkingTextColor = Colors.red;
          } else if (state is SubmitEmptyState) {
            blinkingText = "Veuillez d'abords entrer vos identifiants";
            blinkingTextColor = NsiaAssets.jaune;
            formValid = {};
          }
          return BlinkingText(
            text: blinkingText,
            textColor: blinkingTextColor,
            alignment: TextAlign.center,
            fontSize: 15.0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    routeBloc = BlocProvider.of<NavigationBloc>(context);
    formBloc = BlocProvider.of<FormBloc>(context);
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    
    double bar = AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(),
      body: SlideTransition(
        position: slideIn,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: bar,
                      ),
                      Container(
                        width: 300.0,
                        child: NsiaAssets.logoChapChapW,
                      ),
                      SizedBox(height: 30.0),
                      _buildSmartBlinkingText(),
                      SizedBox(height: 30.0),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _loginController,
                                focusNode: _loginFocus,
                                autocorrect: false,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFFC99705),
                                    ),
                                    labelText: "Login",
                                    labelStyle: TextStyle(
                                      color: Color(0xFFC99705),
                                      fontSize: 15.0,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFC99705)),
                                    )),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                obscureText: true,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.https,
                                      color: Color(0xFFC99705),
                                    ),
                                    suffixStyle: TextStyle(
                                      color: Color(0xFFC99705),
                                    ),
                                    labelText: "Mot de passe",
                                    labelStyle: TextStyle(
                                      color: Color(0xFFC99705),
                                      fontSize: 15.0,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFC99705)),
                                    )),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: NsiaAssets.bleu,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (formValid['login'] == true &&
                                          formValid['password'] == true) {
                                        //normalement je dois faire ca au niveau du bloc mais il veut pas on va faire comment
                                        //var rep=Repository();
                                        //rep.fetchUser(_loginController.text,_passwordController.text);
                                        authBloc.dispatch(LoginAttemptEvent(
                                            login: _loginController.text,
                                            password:
                                                _passwordController.text));
                                      } else {
                                        formBloc.dispatch(SubmitEmptyEvent(
                                            formName: "login chap chap"));
                                      }
                                    },
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    child: Container(
                                      width: 220.0,
                                      height: 50.0,
                                      alignment: FractionalOffset.center,
                                      child: Text(
                                        "Connexion",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 25,
                child: Center(
                  child: Text(
                    "Tel: 22 41 98 00 | ecoute.ci@groupensia.com",
                    style: TextStyle(color: Color(0xFF001093)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
