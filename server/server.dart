import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_router/shelf_router.dart';
import 'handlers/auth_handlers.dart';

void main() async {
  final router = Router();

  // handle Flutter Web build files
  var staticHandler = createStaticHandler('flutter_webapp/build/web', defaultDocument: 'index.html', listDirectories: false);
  router.mount('/web/', staticHandler);

  // Handlers
  router.get('/hello', (shelf.Request request) {
    return shelf.Response.ok('Hello, Dart Backend!');
  });

  router.post('/submit-feedback', (shelf.Request request) async {
    // read and process req body, i.e. store in database when able to
    return shelf.Response.ok('Feedback received!');
  });

  // add routes here
  router.post('/login', loginUser);
  router.post('/logout', logoutUser);
  router.post('/signup', signupUser);


  // starting server
  final server = await io.serve(router, 'localhost', 8080);
  print('Server listening on port ${server.port}');

}