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
3. Check your email for account authentication
4. Create token
5. Write your token name, tick on every check box in Repositories, Inference, Webhooks, Collections -> Press Create token
6. Copy your own token
7. Locate chat_service.dart file(in services Folder)
8. Paste your copied api key to "final String apiKey = "YOUR_API_KEY_HERE";" (line 7)

III. Install packages for backend
  1. In terminal, navigate to project folder and use command line "npm install express mongoose cors"

IV. Change Ip Address depending on environment(emulator or windows)
In main.dart file, line 33 "final String ipAddress = 'YOUR_IP_ADDRESS_HERE'"
  1. If run main.dart file on Emulator, change Ip Address to 10.0.2.2
  2. If run main.dart file on on Window, change Ip Address to localhost
