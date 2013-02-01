import 'dart:io';

/* A simple web server that responds to **ALL** GET requests by returning
 * the contents of data.json file, and responds to ALL **POST** requests
 * by overwriting the contents of the data.json file
 * 
 * Browse to it using http://localhost:8080  
 * 
 * Provides CORS headers, so can be accessed from any other page
 */

var host = "127.0.0.1"; // eg: localhost 
var port = 8080; 
var datafile = "data.json";

void main() {
  var httpServer = new HttpServer();
  
  httpServer.addRequestHandler((req) => req.method == "GET", handleGet);
  httpServer.addRequestHandler((req) => req.method == "POST", handlePost);
  httpServer.addRequestHandler((req) => req.method == "OPTIONS", handleOptions);
  httpServer.defaultRequestHandler = defaultHandler;
  // no default handler - returns 404 for any other method
  
  httpServer.listen(host,port);
  print("Listening for GET and POST on http://$host:$port");
}

/**
 * Handle GET requests by reading the contents of data.json
 * and returning it to the client
 */
void handleGet(req,HttpResponse res) {
  print("${req.method}: ${req.path}");
  addCorsHeaders(res);
  var outputStream = res.outputStream;
  
  var file = new File(datafile);
  if (file.existsSync()) {
    res.headers.add(HttpHeaders.CONTENT_TYPE, "application/json");
    file.openInputStream().pipe(outputStream); // automatically close output stream
  }
  else {
    var err = "Could not find file: $datafile";
    outputStream.writeString(err);
    outputStream.close();  
  }
  
}

/**
 * Handle POST requests by overwriting the contents of data.json
 * Return the same set of data back to the client.
 */
void handlePost(HttpRequest req,res) {
  print("${req.method}: ${req.path}");
  
  addCorsHeaders(res);
  
  InputStream inputStream = req.inputStream;
  inputStream.onData = () {
    var buffer = inputStream.read();
    var file = new File(datafile);
    var outputStream = file.openOutputStream();
    outputStream.write(buffer);
    outputStream.close();
    
    // return the same results back to the client
    res.outputStream.write(buffer);
    res.outputStream.close();
  };
}

/**
 * Add Cross-site headers to enable accessing this server from pages
 * not served by this server
 * 
 * See: http://www.html5rocks.com/en/tutorials/cors/ 
 * and http://enable-cors.org/server.html
 */
void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*");
  res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
}

void handleOptions(req,HttpResponse res) {
  addCorsHeaders(res);
  res.statusCode = HttpStatus.ACCEPTED;  
  res.outputStream.close();
}

void defaultHandler(req,HttpResponse res) {
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;  
  res.outputStream.writeString("Not found: ${req.method}, ${req.path}");
  res.outputStream.close();
}