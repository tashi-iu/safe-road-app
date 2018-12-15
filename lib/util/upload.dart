import 'package:http/http.dart' as http;
import 'dart:convert';

postData(Map locData) async {
  String sourceURL = "https://bdstesting.datascientists.com/safe-route/web/rest/public/log/save";

  Map withDeviceId = {"ChipId":01};
  var addMap = {}..addAll(withDeviceId)..addAll(locData);
  Map<String, Map> logMap = {"log":addMap};
  http.Response response = await http.post(sourceURL,
      body: json.encode(logMap),
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json"
      });
  print("working");  
  if(response.body != null){
    print("Data sent ${response.body}");
  }else{
    print("no response");
  }
}

