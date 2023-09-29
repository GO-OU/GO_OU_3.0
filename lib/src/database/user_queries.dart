import 'package:flutter_webapp/src/database/connection.dart';

Future<void> createUser(String email, String password) async {
  final connection = getConnection();
  await connection.open();

  // Hash the password using Argon2id
  final hashedPassword = await hashPassword(password);

  // ALWAYS store the hashed password in database, never plaintext
  await connection.query(
    'INSERT INTO users(email, password) VALUES (@e, @p)',
    substitutionValues: {'e': email, 'p': hashedPassword},
  );
  // when we check a user's password, use verifyPassword from inside utils crypt
  await connection.close();
}

// Add more CRUD operations.