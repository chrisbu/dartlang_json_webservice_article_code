import 'dart:html';
import 'package:json_object/json_object.dart';
import 'dart:json' as JSON;

import 'dart:core' as core;


var host = "127.0.0.1:8080";

void main() {
  query("#load").onClick.listen(loadData);
  query("#loadStructured").onClick.listen(loadStructuredData);
  query("#save").onClick.listen(saveData);
}

void loadData(_) {
  print("Loading data");
  var url = "http://$host/programming-languages";

  // call the web server asynchronously
  var request = HttpRequest.getString(url).then(onDataLoaded);
}

onDataLoaded(responseText) {
  print(" Data Loaded");
  var jsonString = responseText;
  query("#json_content").text = jsonString;   
}


// Load data an interperet using json object
void loadStructuredData(_) {
  print("Loading structured data");
  var url = "http://$host/programming-languages";

  
  
  // call the web server asynchronously
  var request = HttpRequest.getString(url).then(onStructuredDataLoaded);
}

void onStructuredDataLoaded(responseText) {
  print(" Structured data loaded");
  var jsonString = responseText;
  query("#json_content").text = jsonString;
  
  print(" Converting to JsonObject");
  Language jsonObject = new LanguageImpl.fromJsonString(jsonString);
  query("#json_content").text = jsonString;
  
  print("  jsonObject.language = ${jsonObject.language}");
  
  for (var count = 0; count < jsonObject.targets.length; count++) {
    print("  jsonObject.targets[$count] = ${jsonObject.targets[count]}");
  }
  
  jsonObject.website.forEach((key,value) {
    print("  jsonObject.website['$key'] = $value");
  });
}


void saveData(_) {
  print("Saving structured data");
  
  // Setup the request
  var request = new HttpRequest();
  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE &&
        (request.status == 200 || request.status == 0)) {
      // data saved OK.
      print(" Data saved successfully");
      
      // update the UI
      var jsonString = request.responseText;
      query("#json_content").text = jsonString;
    }
  });
  
  // Get some data to save
  var jsonString = query("#json_content").text;
  Language jsonObject = new LanguageImpl.fromJsonString(jsonString);
  jsonObject.language = jsonObject.language.toUpperCase();
  jsonObject.targets.add("Android?");
  
  // POST the data to the server
  var url = "http://$host/programming-languages";
  request.open("POST", url, false);
  request.send(JSON.stringify(jsonObject));
}


/**
 * Override print() to have   
 */
void print(message) {
  core.print(message);
  query("#log").innerHtml = query("#log").innerHtml.concat("\n$message");
}


// Class definitions to use Json Object

abstract class Language {
  String language;
  List targets;
  Map website;
}

class LanguageImpl extends JsonObject implements Language {
  LanguageImpl(); 
  
  factory LanguageImpl.fromJsonString(string) {
    return new JsonObject.fromJsonString(string, new LanguageImpl());
  }
  
}