import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
Future<dynamic> getAccessToken() async{

  var url = Uri.http("localhost:8080",'/oauth2/authorization/google');
  var res = await http.get(url);
  print(res);
  if(res.statusCode == 200){
    var jsonResponse =
        convert.jsonDecode(res.body) as Map<String,dynamic>;
    var accessToken = jsonResponse['accessToken'];
    print(accessToken);
    return accessToken;
  }else{
    return "request fail";
  }
}