import 'dart:convert';
import 'dart:io';
import 'package:Easy_shopping_admin/AllOrderList/AllOrderList.dart';
import 'package:Easy_shopping_admin/AllProducts/AllProducts.dart';
import 'package:Easy_shopping_admin/Category/CategoryList.dart';
import 'package:Easy_shopping_admin/ErrorLogIn/ErrorLogIn.dart';
import 'package:Easy_shopping_admin/Login/Login.dart';
import 'package:Easy_shopping_admin/Logout/Logout.dart';
import 'package:Easy_shopping_admin/Menu.dart';
import 'package:Easy_shopping_admin/NavigationAnimation/routeTransition/routeAnimation.dart';
import 'package:Easy_shopping_admin/NotificationsScreen/NotificationsScreen.dart';
import 'package:Easy_shopping_admin/OrderType/OrderType.dart';
import 'package:Easy_shopping_admin/ProductsType/ProductsType.dart';
import 'package:Easy_shopping_admin/api/api.dart';
import 'package:Easy_shopping_admin/main.dart';
import 'package:Easy_shopping_admin/redux/action.dart';
import 'package:Easy_shopping_admin/redux/state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var body;
  List productsData = [
"4","5"
  ];
  List orderData = ["2"];
  var unseenNotific=0;
  bool _isLoading = true;
  TextEditingController taxController = new TextEditingController();
  bool _fromTop = true;
  var appToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    /// add firebase notification/////

_showInitData();

  /// add firebase notification/////

    // _firebaseMessaging.getToken().then((token) async {
    //   print("Notification app token");
    //   print(token);
    //   appToken = token;
    // });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
     
        _showNotificationPop(
            message['notification']['title'], message['notification']['body']);
       
      },
      onLaunch: (Map<String, dynamic> message) async {
        pageLaunch(message);
      },
      onResume: (Map<String, dynamic> message) async {
        pageDirect(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    /// end firebase notification/////
    /// end firebase notification/////
   // _allData();

    super.initState();
  }

    ///// handle looping onlaunch firebase //////
  void pageDirect(Map<String, dynamic> msg) {
    print("onResume: $msg");
    setState(() {
      index = 1;
    });
     Navigator.push( context, FadeRoute(page: AllOrderList()));
  }

  void pageLaunch(Map<String, dynamic> msg) {
    print("onLaunch: $msg");
    pageRedirect();
  }

  void pageRedirect() {
    if (index != 1 && index != 2) {
       Navigator.push( context, FadeRoute(page: AllOrderList()));
      setState(() {
        index = 2;
      });
    }
  }


  ///// end handle looping onlaunch firebase //////

  // void _sendApptoken() async {
  //   var data = {'app_token': appToken};

  //   print(data);
  //   var res = await CallApi().postData(data, '/app/storeApptoken');
  //   var body = json.decode(res.body);
  //   print(body);
  // }

  Future<void> _allData() async {
    _showInitData();
  }

 


  ///// end handle looping onlaunch firebase //////


  
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //   title: new Text('Are you sure?'),
            content: new Text('Do you want to exit this App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: appColor),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: appColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }


  void choiceAction(String choice) {
    if (choice == Menu.Logout) {

     _logoutDialog();
     
    }
   
    }
  

  Future<void> _showInitData() async {
    var res = await CallApi().getData('/api/totalData');

    if (res.statusCode == 200) {
      var body = json.decode(res.body);

      store.dispatch(TotalProduct(body['TotalProduct']));
      store.dispatch(TotalCategory(body['TotalCategory']));
      store.dispatch(TotalOrder(body['TotalOrder']));
    } else if (res.statusCode == 401) {
      Navigator.push(context, SlideLeftRoute(page: ErrorLogIn()));
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong!! Try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: appColor.withOpacity(0.9),
          textColor: Colors.white,
          fontSize: 13.0);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: StoreConnector<AppState, AppState>(
            ////// this is the connector which mainly changes state/ui
            converter: (store) => store.state,
            builder: (context, items) {
              return Scaffold(
          body:
          //  _isLoading
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : 
              SafeArea(
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              color: appColor,
                              //
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  // Container(
                                    
                                  //   child: Stack(
                                  //     children: <Widget>[
                                  //       Container(
                                  //          margin: EdgeInsets.only(top:10),
                                  //         child: GestureDetector(
                                  //           onTap: () {
                                  //              Navigator.push( context, FadeRoute(page: NotificationsScreen()));
                                  //           },
                                  //           child: Icon(
                                  //             Icons.notifications,
                                  //             //size: 32,
                                  //             color: Colors.white,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       // unseenNotific==0 || unseenNotific==null
                                  //       //     ? Container()
                                  //       //     :
                                  //       Container(
                                  //         margin: EdgeInsets.only(left:12, bottom:10),
                                  //         // alignment: Alignment.center,
                                  //         // height: 21,
                                  //         // width: 21,
                                  //         decoration: BoxDecoration(
                                  //             //border: Border.all(color: Colors.white),
                                  //             color: unseenNotific == 0 ||
                                  //                     unseenNotific == null
                                  //                 ? Colors.transparent
                                  //                 : Colors.red[900],
                                  //             shape: BoxShape.circle
                                  //             // borderRadius: BorderRadius.circular(10)
                                  //             // shape: BoxShape.circle
                                  //             ),
                                  //         child: Padding(
                                  //           padding: unseenNotific < 9
                                  //               ? EdgeInsets.all(6.0)
                                  //               : EdgeInsets.all(4.0),
                                  //           // padding:     EdgeInsets.all(6.0),
                                  //           // totalNotifi
                                  //           child: Text(
                                  //             //    unseenNotific==null?"":unseenNotific.toString(),
                                  //             unseenNotific == 0
                                  //                 ? ""
                                  //                 : unseenNotific > 9
                                  //                     ? "9+"
                                  //                     : '$unseenNotific',
                                  //             style: TextStyle(
                                  //                 fontSize: 10,
                                  //                 color: Colors.white,
                                  //                 fontWeight: FontWeight.bold),
                                  //           ),
                                  //         ),
                                  //         //count
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                    Container(
                                          margin: EdgeInsets.only(top:10),
               // alignment: Alignment.topRight,
                child: PopupMenuButton<String>(
                  onSelected: choiceAction,
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) {
                    return Menu.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ),
  //      
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 75, left: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    "Welcome !!",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        "Easy Shopping",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            child: Container(
                          margin: EdgeInsets.only(top: 200),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.topLeft,
                                stops: [
                                  0.1,
                                  0.4,
                                  0.6,
                                  0.9
                                ],
                                colors: [
                                  Colors.grey[200],
                                  Colors.grey[200],
                                  Colors.white,
                                  Colors.white,
                                ]),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: RefreshIndicator(
                              onRefresh: _allData,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[

                                    
                                      GestureDetector(
                                        onTap: () {
    //                                     Navigator.push(
    // context,
    // MaterialPageRoute(builder: (context) => ProductTypeView()));
 Navigator.push( context, FadeRoute(page: ProductsType()));
                                          // Navigator.push(context, SlideLeftRoute(page: TestFile()));
                                          // Navigator.push(context, SlideLeftRoute(page: MyAppVideo()));
                                        },
                                        child: cardDesign(
                                            "Products ",
                                             "(" +
                                                    store.state.totalProduct.toString() +
                                                    ")",
                                            "See all products details",
                                            'assets/images/products.png'),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                           Navigator.push( context, FadeRoute(page: OrderType()));
                                          // Navigator.push(context, SlideLeftRoute(page: VideoT()));
                                        },
                                        child: cardDesign(
                                            "Orders ","(" +
                                                    store.state.totalOrder.toString() +
                                                    ")",
                                            "See all order details ",
                                            'assets/images/order.png'),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                        
                                           Navigator.push(context, SlideLeftRoute(page: CategoryList()));
                                        },
                                        child: cardDesign(
                                            "Category ",
                                             "(" +
                                                    store.state.totalCategory.toString() +
                                                    ")",
                                            "See all categories details",
                                            'assets/images/coupon.png'),
                                      ),
                                     
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
        );
            }
      ),
    );
  }

  Container cardDesign(
      String title, String total, String subtitle, String img) {
    return Container(
      // height: 150,

      child: Card(
        elevation: 0,
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Colors.white,
            border: Border.all(width: 0.2, color: Colors.grey),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                blurRadius: 17,
                //offset: Offset(0.0,3.0)
              ),
            ],
          ),
          height: 150,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                //   width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  color: Colors.white,
                  // border: Border.all(width: 0.2, color: Colors.grey),
                ),
                child: Image.asset(
                  img,
                  //    height: 300,
                  //  width:  MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              child: Text(
                            title,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          )),
                          Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Text(
                                total,
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(color: Colors.black, fontSize: 13),
                              )),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            subtitle,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black54, fontSize: 15),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logOutDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        //   title: new Text('Are you sure?'),
        content: new Text('Do you want to logout'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(color: appColor),
            ),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout();
            },
            child: new Text(
              'Yes',
              style: TextStyle(color: appColor),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////  Log Out Start  //////////////////////
  void _logout() async {


   

    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Logout()));
  }
  ///////////////////////////  Log Out End /////////////////////////

  void _showNotificationPop(String title, String msg) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (BuildContext context, anim1, anim2) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            // Navigator.push(context, SlideLeftRoute(page: NotificationPage()));
          },
          child: Material(
            type: MaterialType.transparency,
            child: Align(
              alignment:
                  _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  bottomNavIndex = 4;
                   Navigator.push( context, FadeRoute(page: AllOrderList()));
                },
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    //  final item = items[index];

                    return Dismissible(
                      key: Key("item"),
                      onDismissed: (direction) {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 80,
                        child: SizedBox.expand(
                            child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ////////////   Address  start ///////////

                              ///////////// Address   ////////////

                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      left: 5, top: 2, bottom: 0),
                                  child: Text(title,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                              Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      left: 5, top: 2, bottom: 8),
                                  child: Text(msg,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: appColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal))),
                            ],
                          ),
                        )),
                        margin: EdgeInsets.only(
                            top: 50, left: 12, right: 12, bottom: 50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                  .animate(anim1),
          child: child,
        );
      },
    );
  }

    void _logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: EdgeInsets.all(5),
          title: Text(
            "Are you sure want to logout?",
            // textAlign: TextAlign.,
            style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: "grapheinpro-black",
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          content: Container(
              height: 70,
              width: 250,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(
                          top: 25,
                          bottom: 15,
                        ),
                        child: OutlineButton(
                          child: new Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide:
                              BorderSide(color: Colors.black, width: 0.5),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0)),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          color: appColor.withOpacity(0.9),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        width: 110,
                        height: 45,
                        margin: EdgeInsets.only(top: 25, bottom: 15),
                        child: OutlineButton(
                            // color: Colors.greenAccent[400],
                            child: new Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                                Navigator.of(context).pop();
                                _logout();
                            },
                            borderSide:
                                BorderSide(color: Colors.green, width: 0.5),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0))))
                  ])),
        );
        //return SearchAlert(duration);
      },
    );
  }
}
