import 'dart:convert';
import 'dart:io';

generateConstantCredentials(Map<String, String> items) {
  File creds = new File("lib/core/constant_credentials2.dart");
  var disclaimer =
      '''// Disclaimer: this file is on .gitignore because it contains private information
// Contain the credentials that does not change
''';
  creds.writeAsStringSync(disclaimer);
  creds.writeAsStringSync("class ConstantCredentials {\n",
      mode: FileMode.append);
  for (var variable in items.keys) {
    creds.writeAsStringSync(
        '  static const String $variable = "${items[variable]}";\n',
        mode: FileMode.append);
  }
  creds.writeAsStringSync('}\n', mode: FileMode.append);
  print("Credentials file generated at 'lib/core/constant_credentials.dart'");
}

main() {
  var path = 'android/app/google-services.json';
  // Exit if 'android/app/google-services.json' doesn't exist.
  if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
    print("Cannot find 'google-services.json' in 'android/app/' directory."
        "Copy 'google-services.json' in 'android/app/' and try again.");
    return;
  }

  File file = File(path);
  var settings = json.decode(file.readAsStringSync());
  var credentials = Map<String, String>();
  credentials['fireBaseProjectId'] = settings["project_info"]["project_id"];
  credentials['fireBaseApiKey'] = settings["client"][0]["api_key"][0]["current_key"];

  stdout.write("Enter Credentials for the created firebase User:\nEmail: ");
  credentials['userEmail'] = stdin.readLineSync();
  stdout.write("Password: ");
  credentials['userPassword'] = stdin.readLineSync();

  generateConstantCredentials(credentials);
}
