import 'package:flutter/material.dart';
import 'package:shipconvenient/Screens/Main/page/activity.dart';
import 'package:shipconvenient/Screens/Main/page/dashboard.dart';
import 'page/chat.dart';
import 'page/profile.dart';
import 'page/notify.dart';

class MainPage extends StatefulWidget {
  const MainPage(this.token, {Key? key}) : super(key: key);
  final String? token;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentTab = 0 ;
  final List<Widget> screens = [
    Dashboard(null),
    const Chat(),
    const Notify(),
    const Profile()
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {

    Widget currentScreen = Dashboard(widget.token);
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = Dashboard(widget.token);
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.dashboard,
                            color: currentTab == 0 ? Colors.blue : Colors.grey
                        ),
                        Text(
                          'Trang chủ',
                          style: TextStyle(
                              fontSize: 9,
                              color: currentTab == 0 ? Colors.blue : Colors.grey
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = const Activity();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.verified,
                            color: currentTab == 1 ? Colors.blue : Colors.grey
                        ),
                        Text(
                          'Hoạt động',
                          style: TextStyle(
                              fontSize: 9,
                              color: currentTab == 1 ? Colors.blue : Colors.grey
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = const Chat();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.chat,
                            color: currentTab == 2 ? Colors.blue : Colors.grey
                        ),
                        Text(
                          'Tin nhắn',
                          style: TextStyle(
                              fontSize: 9,
                              color: currentTab == 2 ? Colors.blue : Colors.grey
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = const Notify();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.notifications,
                            color: currentTab == 3 ? Colors.blue : Colors.grey
                        ),
                        Text(
                          'Thông báo',
                          style: TextStyle(
                              fontSize: 9,
                              color: currentTab == 3 ? Colors.blue : Colors.grey
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: (){
                      setState(() {
                        currentScreen = const Profile();
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.person,
                            color: currentTab == 4 ? Colors.blue : Colors.grey
                        ),
                        Text(
                          'Cá nhân',
                          style: TextStyle(
                              fontSize: 9,
                              color: currentTab == 4 ? Colors.blue : Colors.grey
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
