import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ذكرني',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Arial',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? timer;
  Duration interval = Duration(minutes: 60);
  String selectedLang = 'ar';

  final quotes = {
    'ar': [
      'اترك الهاتف، إنه مضيعة للوقت.',
      'التدخين مضر بالصحة.',
      'استثمر وقتك في شيء مفيد.',
      'ابتسم، الحياة جميلة.',
      'تعلم شيئاً جديداً اليوم.',
    ],
    'fr': [
      'Laisse ton téléphone, c’est une perte de temps.',
      'Fumer nuit gravement à la santé.',
      'Investis ton temps dans quelque chose d’utile.',
      'Souris, la vie est belle.',
      'Apprends quelque chose de nouveau aujourd’hui.',
    ],
    'en': [
      'Put your phone down, it’s a waste of time.',
      'Smoking is harmful to your health.',
      'Invest your time in something useful.',
      'Smile, life is beautiful.',
      'Learn something new today.',
    ],
    'tn': [
      'نحّي التاليفون، راهو يضيعلك وقتك.',
      'الدخان يضرّ بصحّتك.',
      'عمل حاجة تفيّدك.',
      'تبسّم، الدنيا زينة.',
      'تعلّم حاجة جديدة اليوم.',
    ],
  };

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void startNotifications() {
    timer?.cancel();
    timer = Timer.periodic(interval, (_) => showRandomNotification());
  }

  void stopNotifications() {
    timer?.cancel();
  }

  void showRandomNotification() async {
    final quoteList = quotes[selectedLang]!;
    final quote = quoteList[Random().nextInt(quoteList.length)];
    var androidDetails = AndroidNotificationDetails('id', 'channel', importance: Importance.high);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      '📢 تذكير',
      quote,
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('ذكرني'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'تطبيق "ذكرني" هو مشروع توعوي يهدف إلى تشجيع المستخدمين على العادات الإيجابية مثل تقليل استخدام الهاتف، وتجنّب التدخين، واستثمار الوقت بطريقة مفيدة.\n\nتم إنشاء التطبيق كجزء من مشروع مدرسي تحت إشراف الأستاذة سلوى بن رمضان، وهو يعمل على إرسال إشعارات دورية بلغات متعددة (العربية، الفرنسية، الإنجليزية، التونسية) تحتوي على رسائل تحفيزية وإيجابية.\n\nطريقة الاستخدام:\n١. اختر اللغة التي تود تلقي الإشعارات بها.\n٢. اختر الفاصل الزمني بين كل إشعار (30 دقيقة أو ساعة).\n٣. اضغط على "تفعيل الإشعارات" لبدء التذكيرات، أو "إيقاف الإشعارات" لإيقافها.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 20),
                Text(
                  'اختار المدة بين كل إشعار:',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => interval = Duration(minutes: 30));
                        startNotifications();
                      },
                      child: Text('كل 30 دقيقة', style: TextStyle(color: Colors.orangeAccent)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => interval = Duration(minutes: 60));
                        startNotifications();
                      },
                      child: Text('كل ساعة', style: TextStyle(color: Colors.orangeAccent)),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'اختار اللغة:',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                DropdownButton<String>(
                  value: selectedLang,
                  dropdownColor: Colors.grey[850],
                  style: TextStyle(color: Colors.white),
                  items: [
                    DropdownMenuItem(child: Text('العربية'), value: 'ar'),
                    DropdownMenuItem(child: Text('Français'), value: 'fr'),
                    DropdownMenuItem(child: Text('English'), value: 'en'),
                    DropdownMenuItem(child: Text('Tounsi'), value: 'tn'),
                  ],
                  onChanged: (val) => setState(() => selectedLang = val!),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: startNotifications,
                  icon: Icon(Icons.notifications_active),
                  label: Text('تفعيل الإشعارات'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: stopNotifications,
                  icon: Icon(Icons.notifications_off),
                  label: Text('إيقاف الإشعارات'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
            Text(
              'برمجة ابراهيم التونسي و ايوب لبرق تحت تأطير الأستاذة سلوى بن رمضان في معهد باردو',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.white54),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
