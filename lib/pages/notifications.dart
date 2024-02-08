import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sparks/pages/dashboard.dart';
import 'package:sparks/widgets/pagesbg.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Notification> _notifications = [
    Notification(
      title: 'Parking Lot Full',
      message: 'The parking lot at Pay-to-Park is currently full.',
      type: NotificationType.alert,
      date: DateTime.now(),
      time: TimeOfDay.now(),
    ),
    Notification(
      title: 'Check your car!',
      message: 'Your car has been reported.',
      type: NotificationType.personal,
      date: DateTime.now(),
      time: TimeOfDay.now(),
    ),
    Notification(
      title: 'Parking Lot Close!',
      message: 'Pay to Park will closed in 25 minutes',
      type: NotificationType.alert,
      date: DateTime.now(),
      time: TimeOfDay.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PagesBackground(),
        Scaffold(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(130),
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notification = _notifications[index];
              return Card(
                margin: EdgeInsets.all(5),
                shadowColor: Color.fromARGB(255, 93, 95, 92),
                elevation: 6,
                child: ListTile(
                  tileColor: Colors.white,
                  contentPadding: EdgeInsets.all(20),
                  leading: Icon(
                    notification.type == NotificationType.alert
                        ? Icons.warning
                        : Icons.notifications,
                    color: notification.type == NotificationType.alert
                        ? Colors.red
                        : Colors.blue,
                  ),
                  title: Text(notification.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message),
                      SizedBox(height: 8),
                      Text(
                          '${DateFormat('MM/dd/yyyy').format(notification.date)} at ${notification.time.format(context)}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

enum NotificationType { alert, personal }

class Notification {
  Notification({
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    required this.time,
  });

  final String title;
  final String message;
  final NotificationType type;
  final DateTime date;
  final TimeOfDay time;
}
