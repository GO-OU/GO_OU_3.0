import 'package:cryptography/cryptography.dart';

Future<String> hashPassword(String password) async {
  final hash = Argon2id();
  final salt = Sodium.randomBytes(16); // Generate random salt, theoretically this still isn't best practice.

  final secretKey = await hash.hashPassword(
    password: password,
    salt: salt,
  );

  // Combining salt with hash for db storage
  return base64.encode([...salt, ...secretKey.extractSync()]);
}

Future<bool> verifyPassword(String storedHash, String inputPassword) async {
  final bytes = base64.decode(storedHash); // retrieve hash
  final salt = bytes.sublist(0, 16);  // extract salt 1st 16 bits of hash
  final storedPasswordBytes = bytes.sublist(16);

  final hash = Argon2id();
  final secretKey = await hash.hashPassword( // hash the incoming password with extracted salt
    password: inputPassword,
    salt: salt,
  );

  // use const-time cmp against timing attacks
  final areEqual = constTimeEquality.equals(secretKey.extractSync(), storedPasswordBytes);
  return areEqual;
}
