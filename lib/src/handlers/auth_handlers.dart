// user_auth implement in routes
import 'package:shelf/shelf.dart' as shelf;
/*Receive a request with the user's email and password.
*Check the database to see if a user with this email exists.
*If the user exists, verify the hashed password.
*If verified, generate a session token and send it back to the client.*/
Future<shelf.Response> loginUser(shelf.Request request) async {
  final data = json.decode(await request.readAsString());
  final email = data['email'];
  final password = data['password'];
  // TODO(a01a02): implement this pseudo
  // Here crosscheck database for user
  final user = await getUserByEmail(email); // pseudo

  if (user == null) {
    return shelf.Response(401, body: 'Invalid email or password');
  }
  if (!await verifyPassword(password, user.hashedPassword)) { // hash func in crypt
    return shelf.Response(401, body: 'Invalid email or password'); // use same body to prevent process of elimination
  }
  // if email and password valid in db, generate session token (we need to figure out what session token we want)
  final token = generateSessionTokenForUser(user); // pseudo

  return shelf.Response.ok(json.encode({'token': token}));
}
/* This logic will depend on how we handle session tokens I.E. what token we use.
*Receive a request with the user's session token.
*Invalidate or delete this session token.*/
Future<shelf.Response> logoutUser(shelf.Request request) async {
  // Generalized logic assuming the use of session cookie:
  // remove/invalidate session cookie
  return shelf.Response.ok('Logged out').change(headers: {'Set-Cookie': 'session=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT'});
}
/*Receive a request with user's email, password, and possibly other registration data.
*Check if a user with this email already exists.
*If not, hash the password and save the new user in the database.
*Generate a session token and send it back (this step is optional; some platforms prefer to ask users to login manually after signup).*/
Future<shelf.Response> signupUser(shelf.Request request) async {
  final data = json.decode(await request.readAsString());
  final email = data['email'];
  final password = data['password'];

  final existingUser = await getUserByEmail(email); // pseudo

  if (existingUser != null) {
    return shelf.Response(409, body: 'Email already in use');
  }

  final hashedPassword = await hashPassword(password);
  await createUser(email, hashedPassword); // pseudo

  // optional auto-login user by creating session token
  final token = generateSessionTokenForEmail(email); // pseudo
  // NOTE BE VERY CAREFUL WITH THIS. THIS OPEN UP EXPLOIT WITHOUT PROPER LOGIC

  return shelf.Response.ok(json.encode({'token': token}));
}


