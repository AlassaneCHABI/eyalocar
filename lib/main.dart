import 'dart:io';
import 'package:eyav2/data/data.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/new/found_cars_list.dart';
import 'package:eyav2/new/sign-in.dart';
import 'package:eyav2/new/splash_screen.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/sign_in/sign_in_screen.dart';
import 'package:eyav2/sign_up/sign_up_screen.dart';
import 'package:eyav2/widgets/homePage/Response_requeste/All_response.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email= prefs.getString("email");
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received message: $message");
    // Traitez la notification ici (par exemple, affichez une notification locale).
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Message clicked!");
    print("Le contenu du message");
    print(message.notification?.title);
    print("Le body");
    print(message.notification?.body);
    runApp(Application(email:email));
   // _handleNotificationClick(message);
  });

    //MyFirebaseMessaging();
  //MyFirebaseMessaging(navigatorKey.currentState!.context).initialize();
  /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification title: ${message.notification?.title}');
      print('Message also contained a notification body: ${message.notification?.body}');
    }
  });*/
  runApp(MyApp(email:email));
}


class MyFirebaseMessaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void initialize() {
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: $message");
      // Traitez la notification ici (par exemple, affichez une notification locale).
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
      _handleNotificationClick(message);
    });
  }

  void _handleNotificationClick(RemoteMessage message) {
    // Gérez la redirection vers la page spécifique ici en fonction des données de la notification.
    print("Le contenu du message");
    print(message.notification?.title);
    print("Le body");
    print(message.notification?.body);
    /*List<String> parts = (message.notification?.title)!.split("_");

// La partie après le symbole "_"
    String afterSymbol = parts.length > 1 ? parts[1] : "";
    print("L'id");
    print(afterSymbol);
    Navigator.push(context, MaterialPageRoute(builder: (context) => CarsResponseListingWidget(request_id: 25)));*/
  }
}

class Application extends StatefulWidget {
  final String? email;
  Application({ Key? key, this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("Le message est cliqé et on va dirigé la personne ");
    if(widget.email==null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => FoundCarsListScreen(request_id: 54)));
    }

    /*if (message.data['type'] == 'chat') {
      Navigator.pushNamed(context, '/chat',
        arguments: ChatArguments(message),
      );
    }*/
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:widget.email==null? LoginScreen():FoundCarsListScreen(request_id: 54),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyApp extends StatelessWidget {
  final String? email;
  MyApp({ Key? key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(email: email),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home_page extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home_page> {

  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  late PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
              )
            ],
          ),
        ),
        bottomSheet: slideIndex != 2 ? Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: (){
               //   controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));

                },
                //splashColor: Colors.blue[50],
                child: Text(
                  "Connexion",
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    for (int i = 0; i < 3 ; i++) i == slideIndex ? _buildPageIndicator(true): _buildPageIndicator(false),
                  ],),
              ),
              TextButton(
                onPressed: (){
                  print("this is slideIndex: $slideIndex");
                  controller.animateToPage(slideIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                },
                //   splashColor: Colors.blue[50],
                child: Text(
                  "Suivant",
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ): InkWell(
          onTap: (){
            //print("Get Started Now");
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Container(
            height: Platform.isIOS ? 70 : 60,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "Commencez-maintenant",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
          SizedBox(
            height: 40,
          ),
          Text(title, textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20
          ),),
          SizedBox(
            height: 20,
          ),
          Text(desc, textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14))
        ],
      ),
    );
  }
}

