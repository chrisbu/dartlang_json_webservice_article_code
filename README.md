dartlang_json_webservice_article_code
=====================================

The source code that goes along with the article published at http://www.dartlang.org/articles/json-web-service/

There are two separate projects in this repo.  **simpleserver** and **json_client**.

**simpleserver** is a simple HTTP server that either serves up the `data.json` file in response to GET requests, 
or overwrites the content in the file in response to POST requests.  The url path is ignored.  
**simpleserver** adds proper CORS headers, so that it can be used with client code served from a different url.  
This means that the server can serve data to client-side apps launched from the Dart Editor without 
`access-control-allow-origin` issues.

To execute, either run:

    dart simpleserver.dart
    
Load the project into the Dart Editor, and click "Run"

This starts the server listening on http://localhost:8080

----

**json_client** contains example code used in the JSON Web Services article.  

When the `Load` button is clicked, it GETs JSON data 
from the simpleserver and displays it on the client.  

The `Load structured data` button loads the JSON and uses JsonObject to convert
the json data into a class-like structure.  

Finally, the `Save` button edits a field and POSTs the data back to the server.

