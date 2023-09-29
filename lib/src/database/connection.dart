import 'package:postgres/postgres.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

PostgreSQLConnection getConnection() {
  var config = loadYaml(File('config/db_config.yaml').readAsStringSync());
  return PostgreSQLConnection (
    config['host'],
    config['port'],
    config['database'],
    username: config['user'],
    password: config['password'],
  );
}