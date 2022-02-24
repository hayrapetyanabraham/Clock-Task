import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlarmListPage extends StatelessWidget {
  final List<String> listAlarm;
  final Function onRemoveItem;

  const AlarmListPage({Key key, this.listAlarm, this.onRemoveItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (listAlarm.isEmpty)
        ? const Center(
            child: Text('The alarm list is empty'),
          )
        : ListView.builder(
            itemCount: listAlarm.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                      title: Text(listAlarm[index]),
                      leading: const Icon(Icons.alarm),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          onRemoveItem(listAlarm[index]);
                        },
                      )));
            });
  }
}
