// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'The best grocery list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UserCredential userCredential;

  bool _checkBoxOne = false;
  bool _checkBoxTwo = false;
  bool _checkBoxThree = false;
  bool _checkBoxFour = false;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // googleProvider.addScope(
    //     'https://www.googleapis.com/auth/contacts.readonly');
    // googleProvider
    //     .setCustomParameters({'login_hint': 'user@example.com'});
    print("sign in with google");
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  @override
  void initState() {
    super.initState();
    signInWithGoogle().then((UserCredential userCredential) {
      setState(() {
        this.userCredential = userCredential;
        print(this.userCredential.user!.displayName);
        print(this.userCredential.user!.email);
        // print(userCredential.user!.photoUrl);
        print(this.userCredential.user!.uid);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meal Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: <Widget>[
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              // CheckboxListTile(
              //   title: const Text('Checkbox One'),
              //   value: _checkBoxOne,
              //   onChanged: (bool value) {
              //     setState(() {
              //       _checkBoxOne = value!;
              //     });
              //   },
              // ),
              CheckboxListTile(
                title: const Text('Checkbox One'),
                value: _checkBoxOne,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBoxOne = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Checkbox Two'),
                value: _checkBoxTwo,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBoxTwo = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Checkbox Three'),
                value: _checkBoxThree,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBoxThree = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Checkbox Four'),
                value: _checkBoxFour,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBoxFour = value!;
                  });
                },
              ),
            ],
          ),
          TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2022, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
          const Text(
            'Index 2: School',
            style: optionStyle,
          ),
          Center(
              child: Row(
            children: const [
              // Show uer's name
              Text("Setting?")
            ],
          )
              // child: FloatingActionButton(
              //   child: const Text('Sign in'),
              //   onPressed: () {
              //     // Sign in with Google
              //     signInWithGoogle().then((uc) {
              //       userCredential = uc;
              //       print(userCredential.user!.displayName);
              //       print(userCredential.user!.email);
              //       // print(userCredential.user!.photoUrl);
              //       print(userCredential.user!.uid);
              //     });
              //   },
              // ),
              ),
        ].elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!

          // show the snackbar
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
