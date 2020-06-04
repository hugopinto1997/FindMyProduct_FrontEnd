
import 'package:action_cable_stream/action_cable_stream.dart';
import 'package:action_cable_stream/action_cable_stream_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListsActionCableProvider {
  ActionCable _cable2;
  final String _channel = "List";
  String actioncableurl = 'wss://findmyproduct-api.herokuapp.com/api/v1/cable';
  SharedPreferences prefs; 
  int userIdentifier;
  
  ListsActionCableProvider(int ui){
    userIdentifier = ui;
    initCable();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userIdentifier = prefs.getInt("id");
  }

  initCable(){
    initPrefs();
     _cable2 = ActionCable.Stream(actioncableurl);
    _cable2.stream.listen((value) {
        if (value is ActionCableConnected) {
          _cable2.subscribeToChannel(_channel, channelParams: {'room': "private"});
         print('ActionCableConnected');
        } else if (value is ActionCableSubscriptionConfirmed) {
          print('ActionCableSubscriptionConfirmed');
          _cable2.performAction(_channel, 'message',
              channelParams: {'room': "private"},actionParams: {'id': userIdentifier});
        } else if (value is ActionCableMessage) {
         // final msg = json.decode(jsonEncode(value.message));
         // List<dynamic> cosa = msg["message"];
         // print('ActionCableMessage ${cosa.first}');
        }
      });
  }

  disposeCable(){
    _cable2.disconnect();
  }

  ActionCable getCable() => this._cable2;

}