import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _enableNotifications = true;
  double _notificationVolume = 0.5;
  bool _vibrateOnNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('Enable Notifications'),
                trailing: Switch(
                  value: _enableNotifications,
                  onChanged: (value) {
                    setState(() {
                      _enableNotifications = value;
                    });
                  },
                ),
              ),
              Divider(),
              ListTile(
                dense: true,
                title: Text('Notification Volume'),
                trailing: SizedBox(
                  width: 200,
                  child: Slider(
                    value: _notificationVolume,
                    onChanged: (value) {
                      setState(() {
                        _notificationVolume = value;
                      });
                    },
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: _notificationVolume.toStringAsFixed(1),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Vibrate on Notification'),
                trailing: Switch(
                  value: _vibrateOnNotification,
                  onChanged: (value) {
                    setState(() {
                      _vibrateOnNotification = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
