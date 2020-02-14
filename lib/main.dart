import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import "package:http/http.dart" as http;
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:add_2_calendar/add_2_calendar.dart' as add_2_calendar;


void main() => runApp(MaterialApp(
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();


  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  "private_key_id": "571679f87446fc5d36adcc5190d6341a4a9a3008",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC0NxeK51NK3dn1\nPmuWf1u3fy0hEP+z8H8DUg+lmz/R0q8exvQrXPnUwACHwtAdGvfiTYa74focHU5S\nPmCqOsvL5PseH36nv/Of1Q1eJ8A7+cnbiPsGrOK+4Oke5UJktZtgvYyrb3Q5UbJ8\nJe9b4nrgG83+8egCvnonTwBrJ58U9LQ9OGn2m0eL33vD7HRB/qrjGcJrQxsDYqE6\nlHbhO6u3XqmMNb2NuD+kov2zqTPbetzDh2acLBsuNKVtV46mSLM9HGLMtnpOT3Lz\nxFVsQTBMqV3CvtfsdGXqfZmLOvCC3JOzxrV5a+jO9IagjakhFRYw8GgEkkr0Eb7L\nwBR1V+QNAgMBAAECggEAAeWKiTjobk3yW0qHr5uHQ3K5/8wGIsaJUc3kwd0IBS7E\nMMnMUFO36JgY+mXdjC68nFRxnRlkrWdWWr9/ts8yiVokyNXXfJoTonJUgdHW4Uq1\n+QPH6ia8t2B+3CDH9W8c7lEuP0nHiErmny+ZsBjw5qbohyrDQryqdcg/eDaRVnEa\n/BkrK9ylgNDBf/NVVsfbgianIwLpryUsqZPOyN2JzZf3RLRyICEEJ8/8oexfWRHQ\nw8jHH/8Er3AdtqkTbn65U0SFt9JKNUqkvKqOcWwtHVM3P+9DQ2yNbo9uXMvK2BDq\n8TTqRNM7AdNc86czecJiTTaZ/GuFxBE8uMmqWILp6QKBgQDq0EnfxuWoYr24Gprm\nPJ+va0BJ+JLAHTclR/OH0Jg8BCVt7a6L7vtMHL7+AH5XYj4tZUeF+p85LMQPbcdY\n1mPG3K5c4zuBXjiuJcBKgAMDmiuhPBByL407SKOoo2k6wy0HpOsDSKAcp0UJiys9\nJGM2FN8LotPVp6tHIE9tQVWN3wKBgQDEebEy2pvTqzzqP0EKyWSqQXO9m6V1Ac/O\nKi1k5JLOypGLo66TJR5vfKdPaJAWL3blA0/4S7wjW6fIYrDv2OSLbu/PWRJ+Kmpx\nITgv2TUqmxv7l4PKCsQbxNDW1xWXnSH8AKifFfYr95gwMsXefdxDiA+ttPd/fyYW\nhBofsIwzkwKBgHFPS6bBqwcjhtt1czQRIxmaTq6jVeWA86B45Qqv3RZxBcLTRDxg\neUGUSZH2mQD/9nMfgXEkrHsBoCa12dGDuyg2S6mlOYzG8+ENdIo+1bWCSvWGL4V6\nbtOhzN/O4zOpBWy/52xxOlo5WXYugxIBIiLx1WQfEcvzGhK7g7h8I5XPAoGAVRNE\nsXqLoxow5FXDekI+fqKc1WuCN6ozK1iEE34OO9DnOQoFW93k0e2uHOpwCcs/tma6\nyA8zRjQ38MMbTqAiRmYhHS26njsLoDT8OWvaY7qKYWT4QhJrXILa00yLIv19a7t1\nSH2f/OXXVneFypPBPtS5xUPpL6IFAhbtoO83plUCgYAyfS0S++YGWfSqZUwwtbmk\n+zgrs6GdN+xIfO044ZUGdS2SSduw9rCrDZ35oNEXMsbaYpbx75r7skuvtlKq4o/I\n4NX3rID721lgfDN+yIxobaLCVLMqkZnPCI6pStJApXIoKgu3b3XNRVt2yLp9tu0o\nxRgQAPYPxEynsq7n+pVfeg==\n-----END PRIVATE KEY-----\n",
  "client_email": "prabhu@calendar-test-268208.iam.gserviceaccount.com",
  "client_id": "102162463335288288296",
  "type": "service_account"
}
''');

//    const _SCOPES = const [StorageApi.DevstorageReadOnlyScope];
    var scopes = [CalendarApi.CalendarEventsScope,CalendarApi.CalendarScope];


    clientViaServiceAccount(_credentials, scopes).then((http_client) {

        print('client check $http_client');


        var calendarApi = new CalendarApi(http_client);
        /*storage.buckets.list('dart-on-cloud').then((buckets) {
          print("Received ${buckets.items.length} bucket names:");
          for (var file in buckets.items) {
            print(file.name);
          }
        });*/
        getEvents(calendarApi);


      });



  }
  @override
  Widget build(BuildContext context) {

     add_2_calendar.Event event = add_2_calendar.Event(
      title: 'Test event',
      description: 'example',
      location: 'Flutter app',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 1)),
      allDay: false,

    );
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: const Text('Add event to calendar example'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Add test event to device calendar'),
              onPressed: () {
                 Add2Calendar.addEvent2Cal(event).then((success)
                  {
                    scaffoldState.currentState.showSnackBar(
                        SnackBar(content: Text(success ? 'Success' : 'Error')));
                  });
              },
            ),
            RaisedButton(
              child: Text('Add test event from device calendar'),
              onPressed: () {



              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> getEvents(var calendarApi) {


//    var a = calendarApi.events.insert('primary',
//    );

    return calendarApi.events.list("primary",
    )
        .then((Events events){
          print('events check ${events.items}');

      return events.items;
    }).catchError((e){
      print("error encountered");
      print("${e.toString()}");
    });
  }



}
