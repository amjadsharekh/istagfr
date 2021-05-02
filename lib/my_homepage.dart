import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:istagfr/app_localization.dart';
import 'package:istagfr/particle.dart';
import 'package:istagfr/power_mode.dart';
import 'package:istagfr/utils.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'dart:math';
import 'package:share/share.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum PopOutMenu {
  CONTAT,
  SHAREIT,
  OURAPP,
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {


  AnimationController _animationController;
  Animation _animation;
  final List<Color> colors = [
    Color(0xFF1B6948),
    Colors.teal,
    Color(0xFF80C038),
  ];
  final GlobalKey _boxKey = GlobalKey();
  final Random random = Random();
  final double gravity = 9.81,
      dragCof = 0.47,
      airDensity = 1.1644,
      fps = 1 / 24;
  Timer timer;
  Rect boxSize = Rect.zero;
  List<Particle> particles = [];

  @override
  void dispose() {
    // Cancel and Dispose off timer and Animation Controller
    timer.cancel();
    _animationController.removeListener(_animationListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // AnimationController for initial Burst Animation of Text
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _animation = Tween(begin: 1.0, end: 2.0).animate(_animationController);

    // Getting the Initial size of Container as soon as the First Frame Renders
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size size = _boxKey.currentContext.size;
      boxSize = Rect.fromLTRB(0, 0, size.width, size.height);
    });

    // Refreshing State at Rate of 24/Sec
    timer = Timer.periodic(
        Duration(milliseconds: (fps * 1000).floor()), frameBuilder);
    super.initState();
    Utils.getData();
  }

  _animationListener() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  frameBuilder(dynamic timestamp) {
    // Looping though particles to calculate their new position
    particles.forEach((pt) {
      //Calculating Drag Force (DRAG FORCE HAS TO BE NEGATIVE - MISSED THIS IN THE TUTORIAL)
      double dragForceX =
          -0.5 * airDensity * pow(pt.velocity.x, 2) * dragCof * pt.area;
      double dragForceY =
          -0.5 * airDensity * pow(pt.velocity.y, 2) * dragCof * pt.area;

      dragForceX = dragForceX.isInfinite ? 0.0 : dragForceX;
      dragForceY = dragForceY.isInfinite ? 0.0 : dragForceY;

      // Calculating Acceleration
      double accX = dragForceX / pt.mass;
      double accY = gravity + dragForceY / pt.mass;

      // Calculating Velocity Change
      pt.velocity.x += accX * fps;
      pt.velocity.y += accY * fps;

      // Calculating Position Change
      pt.position.x += pt.velocity.x * fps * 100;
      pt.position.y += pt.velocity.y * fps * 100;

      // Calculating Position and Velocity Changes after Wall Collision
      boxCollision(pt);
    });

    if (particles.isNotEmpty) {
      setState(() {});
    }
  }

  burstParticles() {
    // Removing Some Old particles each time FAB is Clicked (PERFORMANCE)
    if (particles.length > 200) {
      particles.removeRange(0, 75);
    }

    _animationController.forward();
    _animationController.addListener(_animationListener);

    double colorRandom = random.nextDouble();

    Color color = colors[(colorRandom * colors.length).floor()];
    String previousCount = "${Utils.counterText['count']}";
    Color prevColor = Utils.counterText['color'];
    Utils.counterText['count'] = Utils.counterText['count'] + 1;
    Utils.counterText['color'] = color;

    int count = random.nextInt(25).clamp(5, 25);

    for (int x = 0; x < count; x++) {
      double randomX = random.nextDouble() * 4.0;
      if (x % 2 == 0) {
        randomX = -randomX;
      }
      double randomY = random.nextDouble() * -7.0;
      Particle p = Particle();
      p.radius = (random.nextDouble() * 10.0).clamp(2.0, 10.0);
      p.color = prevColor;
      p.position = PVector(boxSize.center.dx, boxSize.center.dy);
      p.velocity = PVector(randomX, randomY);
      particles.add(p);
    }

    List<String> numbers = previousCount.split("");
    for (int x = 0; x < numbers.length; x++) {
      double randomX = random.nextDouble();
      if (x % 2 == 0) {
        randomX = -randomX;
      }
      double randomY = random.nextDouble() * -7.0;
      Particle p = Particle();
      p.type = ParticleType.TEXT;
      p.text = numbers[x];
      p.radius = 40;
      p.color = color;
      p.position = PVector(boxSize.center.dx, boxSize.center.dy);
      p.velocity = PVector(randomX * 4.0, randomY);
      particles.add(p);
    }
  }

  boxCollision(Particle pt) {
    // Collision with Right of the Box Wall
    if (pt.position.x > boxSize.width - pt.radius) {
      pt.velocity.x *= pt.jumpFactor;
      pt.position.x = boxSize.width - pt.radius;
    }
    // Collision with Bottom of the Box Wall
    if (pt.position.y > boxSize.height - pt.radius) {
      pt.velocity.y *= pt.jumpFactor;
      pt.position.y = boxSize.height - pt.radius;
    }
    // Collision with Left of the Box Wall
    if (pt.position.x < pt.radius) {
      pt.velocity.x *= pt.jumpFactor;
      pt.position.x = pt.radius;
    }
  }

  @override
  Widget build(BuildContext context) {
    Utils.getData();
    Utils.getDataa();
    Utils.getDataaa();
    Utils.getDataaaa();
    return Scaffold(
      appBar: AppBar(
        leading: _popOutMenu(context),
        backgroundColor: Utils.counterText['color'],
        centerTitle: false,
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.battery_alert_outlined),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PowerMode()));
                  }),
              // IconB
            ],
          )
        ],
      ),
      body: Container(
        key: _boxKey,
        child: _counterText(),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () {
          if (Utils.val) {
            Vibration.vibrate(duration: 100);
          }
          Utils.counterText['count'] = 0;
          Utils.saveData(Utils.counterText['count']);
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Transform.translate(
            offset: Offset(
                double.parse((AppLocalization.of(context).translate('num'))),
                -50),
            child: SizedBox(
              width: 130.0,
              height: 130.0,
              child: FloatingActionButton(
                onPressed: () {
                  if (Utils.val) {
                    Vibration.vibrate(duration: 30);
                  }
                  if (Utils.counterText['count'] == Utils.custm - 1 && Utils.val2 == true) {
                    Vibration.vibrate(duration: 500);
                  }
                  burstParticles();
                  Utils.saveData(Utils.counterText['count']);
                },
                backgroundColor: Utils.counterText['color'],
                child: Icon(
                  Icons.circle,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _counterText() {
    return Stack(
      children: [
        Center(
          child: Transform.translate(
            offset: Offset(0, -130),
            child: Text(
              "${Utils.counterText['count']}",
              textScaleFactor: _animation.value,
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Utils.counterText['color']),
            ),
          ),
        ),
        ...particles.map((pt) {
          if (pt.type == ParticleType.TEXT) {
            return Positioned(
                top: pt.position.y,
                left: pt.position.x,
                //للارقام
                child: Transform.translate(
                  offset: Offset(0, -130),
                  child: Container(
                    child: Text(
                      "${pt.text}",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: pt.color),
                    ),
                  ),
                ));
          } else {
            return Positioned(
                top: pt.position.y,
                left: pt.position.x,
                //لدوائر
                child: Transform.translate(
                  offset: Offset(0, -130),
                  child: Container(
                    width: pt.radius * 2,
                    height: pt.radius * 2,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: pt.color),
                  ),
                ));
          }
        }).toList()
      ],
    );
  }

  Widget _popOutMenu(BuildContext context) {
    return PopupMenuButton<PopOutMenu>(
      itemBuilder: (context) {
        return [
          PopupMenuItem<PopOutMenu>(
            value: PopOutMenu.CONTAT,
            child: Text(AppLocalization.of(context).translate('settings')),
          ),
          PopupMenuItem<PopOutMenu>(
            value: PopOutMenu.SHAREIT,
            child: Text(AppLocalization.of(context).translate('share_it')),
          ),
          PopupMenuItem<PopOutMenu>(
            value: PopOutMenu.OURAPP,
            child: Text(AppLocalization.of(context).translate('our_apps')),
          ),
        ];
      },
      onCanceled: () {},
      onSelected: (PopOutMenu menu) {
        switch (menu.index) {
          case 0:
            {
              showDialogFun();
            }
            break;

          case 1:
            {
              final RenderBox box = context.findRenderObject();
              Share.share('https://play.google.com/store/apps/developer?id=Instagram',
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            }
            break;

          default:
            {
              Utils.openLink(url: 'https://play.google.com/store/apps/developer?id=Instagram');
            }
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Image.asset(
          "assets/" + AppLocalization.of(context).translate('logo1') + ".png",
          color: Colors.white,
        ),
      ),
    );
  }

  showDialogFun() {
    TextEditingController _number = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * .5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      (AppLocalization.of(context).translate('setting')),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                      width: 150.0,
                      child: Divider(
                        color: Colors.teal,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (AppLocalization.of(context)
                              .translate('activate_vibration')),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Switch(
                            value: Utils.val,
                            onChanged: (newValue) {
                              setState(() {
                                Utils.val = newValue;
                                Utils.saveDataa(Utils.val);
                              });
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (AppLocalization.of(context)
                              .translate('vibration_number')),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Spacer(),
                        Switch(
                            value: Utils.val2,
                            onChanged: (newValue) {
                              setState(() {
                                Utils.                                val2 = newValue;
                                Utils.saveDataaaa(Utils.val2);
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 150,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _number,
                            decoration: InputDecoration(
                              hintText: Utils.custm.toString(),
                              labelText: (AppLocalization.of(context)
                                  .translate('number')),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 7,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            String x = _number.text;
                            Utils.saveDataaa(int.parse(x));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                (AppLocalization.of(context)
                                        .translate('message')) +
                                    x,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              backgroundColor: Colors.teal,
                            ));
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              (AppLocalization.of(context).translate('oky')),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.teal,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "JeruCloud",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      width: 150.0,
                      child: Divider(
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      (AppLocalization.of(context)
                          .translate('description_app')),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Utils.openEmail(
                          toEmail: 'jerucloud@gmail.com',
                          subject: '',
                          body: '',
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(2.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          title: Text('jerucloud@gmail.com'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));
        });
  }
}
