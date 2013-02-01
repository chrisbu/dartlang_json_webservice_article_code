import 'dart:html';
import 'package:json_object/json_object.dart';
import 'dart:json' as JSON;

import 'dart:core' as core;



void main() {
  query("#load").onClick.listen(loadData);
  query("#loadStructured").onClick.listen(loadStructuredData);
  query("#save").onClick.listen(saveData);
}

void loadData(_) {
  print("Loading data");
  var url = "http://localhost:8080/programming-languages";

  var onDataLoaded = (req) {
    print(" Data Loaded");
    var jsonString = req.responseText;
    query("#json_content").text = jsonString;   
  };
  
  // call the web server asynchronously
  var request = new HttpRequest.get(url, onDataLoaded);
}

void loadStructuredData(_) {
  print("Loading structured data");
  var url = "http://localhost:8080/programming-languages";

  var onDataLoaded = (req) {
    print(" Structured data loaded");
    var jsonString = req.responseText;
    query("#json_content").text = jsonString;
    
    print(" Converting to JsonObject");
    var jsonObject = new JsonObject.fromJsonString(jsonString);
    query("#json_content").text = jsonString;
    
    print("  jsonObject.language = ${jsonObject.language}");
    print("  jsonObject.targets[0] = ${jsonObject.targets[0]}");
    print("  jsonObject.targets[1] = ${jsonObject.targets[1]}");
    print("  jsonObject.website.homepage = ${jsonObject.website.homepage}");
    print("  jsonObject.website.api = ${jsonObject.website.homepage}");
  };
  
  // call the web server asynchronously
  var request = new HttpRequest.get(url, onDataLoaded);
}


void saveData(_) {
  print("Saving structured data");
  
  // Setup the request
  var request = new HttpRequest();
  request.onLoad.listen((_) {
    if (request.readyState == HttpRequest.DONE) {
      // data saved OK.
      print(" Data saved successfully");
      
      // update the UI
      var jsonString = request.responseText;
      query("#json_content").text = jsonString;
    }
  });
  
  // Get some data to save
  var jsonString = query("#json_content").text;
  var jsonObject = new JsonObject.fromJsonString(jsonString);
  jsonObject.isExtendable = true;
  jsonObject.language = jsonObject.language.toUpperCase();
  jsonObject.version = "M3";
  
  // POST the data to the server
  var url = "http://localhost:8080/programming-languages";
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