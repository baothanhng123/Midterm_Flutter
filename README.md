I. Add http: ^1.3.0 to your Flutter project
  1. Open pubspec.yaml
  Locate the pubspec.yaml file in the root directory of your Flutter project
  
  2. Add the http dependency:
  dependencies:
    flutter:
      sdk: flutter
    http: ^1.3.0
  
  3. Open your terminal or command prompt, and run "flutter pub get"

II. GET YOUR OWN API KEY TO USE CHAT SERVICE
1. Create login account in huggingface: https://huggingface.co/
2. Click user profile avatar -> Choose access tokens(you may be prompted to type password)
3. Write your token name, tick on every check box in Repositories, Inference, Webhooks, Collections -> Press Create token
4. Copy your own token
5. Locate chat_service.dart file(in services Folder)
6. Paste your copied api key to "final String apiKey = "YOUR_API_KEY_HERE";" (line 7)
