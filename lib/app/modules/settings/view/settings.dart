import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/controller/isar_contoller.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/settings/widgets/settings_card.dart';
import 'package:todark/main.dart';
import 'package:todark/theme/theme_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final todoController = Get.put(TodoController());
  final isarController = Get.put(IsarController());
  final themeController = Get.put(ThemeController());
  String? appVersion;

  Future<void> infoVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  updateLanguage(Locale locale) {
    settings.language = '$locale';
    isar.writeTxnSync(() => isar.settings.putSync(settings));
    Get.updateLocale(locale);
    Get.back();
  }

  String firstDayOfWeek(newValue) {
    if (newValue == 'monday'.tr) {
      return 'monday';
    } else if (newValue == 'tuesday'.tr) {
      return 'tuesday';
    } else if (newValue == 'wednesday'.tr) {
      return 'wednesday';
    } else if (newValue == 'thursday'.tr) {
      return 'thursday';
    } else if (newValue == 'friday'.tr) {
      return 'friday';
    } else if (newValue == 'saturday'.tr) {
      return 'saturday';
    } else if (newValue == 'sunday'.tr) {
      return 'sunday';
    } else {
      return 'monday';
    }
  }

  void _openLinkedin() async {
    Future<bool> isLinkedInInstalled() async {
      Uri url = Uri.parse('linkedin://');
      if (await canLaunchUrl(url)) {
        return true;
      } else {
        return false;
      }
    }

    String dt = 'https://www.linkedin.com/in/prashant-ranjan-singh-b9b6b9217/';
    bool isInstalled = await isLinkedInInstalled();
    if (isInstalled != false) {
      AndroidIntent intent = AndroidIntent(action: 'action_view', data: dt);
      await intent.launch();
    } else {
      Uri url = Uri.parse(dt);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  void _openGithub() async {
    Future<bool> isGithubInInstalled() async {
      Uri url = Uri.parse('github://');
      if (await canLaunchUrl(url)) {
        return true;
      } else {
        return false;
      }
    }

    String dt =
        'https://github.com/Prashant-ranjan-singh-123/Priority-list-task';
    bool isInstalled = await isGithubInInstalled();
    if (isInstalled != false) {
      AndroidIntent intent = AndroidIntent(action: 'action_view', data: dt);
      await intent.launch();
    } else {
      Uri url = Uri.parse(dt);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }


  @override
  void initState() {
    infoVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'settings'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profile_photo(),
            SettingCard(
              icon: const Icon(Iconsax.brush_1),
              text: 'appearance'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'appearance'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.moon),
                                text: 'theme'.tr,
                                dropdown: true,
                                dropdownName: settings.theme?.tr,
                                dropdownList: <String>[
                                  'system'.tr,
                                  'dark'.tr,
                                  'light'.tr
                                ],
                                dropdownCange: (String? newValue) {
                                  ThemeMode themeMode =
                                      newValue?.tr == 'system'.tr
                                          ? ThemeMode.system
                                          : newValue?.tr == 'dark'.tr
                                              ? ThemeMode.dark
                                              : ThemeMode.light;
                                  String theme = newValue?.tr == 'system'.tr
                                      ? 'system'
                                      : newValue?.tr == 'dark'.tr
                                          ? 'dark'
                                          : 'light';
                                  themeController.saveTheme(theme);
                                  themeController.changeThemeMode(themeMode);
                                  setState(() {});
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.mobile),
                                text: 'amoledTheme'.tr,
                                switcher: true,
                                value: settings.amoledTheme,
                                onChange: (value) {
                                  themeController.saveOledTheme(value);
                                  MyApp.updateAppState(context,
                                      newAmoledTheme: value);
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: const Icon(Iconsax.code),
              text: 'Configuration'.tr,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  'Configuration'.tr,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.clock),
                                text: 'timeformat'.tr,
                                dropdown: true,
                                dropdownName: settings.timeformat.tr,
                                dropdownList: <String>['12'.tr, '24'.tr],
                                dropdownCange: (String? newValue) {
                                  isar.writeTxnSync(() {
                                    settings.timeformat =
                                        newValue == '12'.tr ? '12' : '24';
                                    isar.settings.putSync(settings);
                                  });
                                  MyApp.updateAppState(context,
                                      newTimeformat:
                                          newValue == '12'.tr ? '12' : '24');
                                  setState(() {});
                                },
                              ),
                              SettingCard(
                                elevation: 4,
                                icon: const Icon(Iconsax.calendar_edit),
                                text: 'firstDayOfWeek'.tr,
                                dropdown: true,
                                dropdownName: settings.firstDay.tr,
                                dropdownList: <String>[
                                  'monday'.tr,
                                  'tuesday'.tr,
                                  'wednesday'.tr,
                                  'thursday'.tr,
                                  'friday'.tr,
                                  'saturday'.tr,
                                  'sunday'.tr,
                                ],
                                dropdownCange: (String? newValue) {
                                  isar.writeTxnSync(() {
                                    if (newValue == 'monday'.tr) {
                                      settings.firstDay = 'monday';
                                    } else if (newValue == 'tuesday'.tr) {
                                      settings.firstDay = 'tuesday';
                                    } else if (newValue == 'wednesday'.tr) {
                                      settings.firstDay = 'wednesday';
                                    } else if (newValue == 'thursday'.tr) {
                                      settings.firstDay = 'thursday';
                                    } else if (newValue == 'friday'.tr) {
                                      settings.firstDay = 'friday';
                                    } else if (newValue == 'saturday'.tr) {
                                      settings.firstDay = 'saturday';
                                    } else if (newValue == 'sunday'.tr) {
                                      settings.firstDay = 'sunday';
                                    }
                                    isar.settings.putSync(settings);
                                  });
                                  MyApp.updateAppState(context,
                                      newTimeformat: firstDayOfWeek(newValue));
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SettingCard(
              icon: Image.asset(
                'assets/images/github.png',
                scale: 20,
              ),
              text: '${'project'.tr} GitHub',
              onPressed: () async {
                _openGithub();
              },
            ),

            SettingCard(
              icon: Image.asset(
                'assets/images/linkedin.png',
                scale: 20,
              ),
              text: 'Connect On Linkedin',
              onPressed: () async {
                _openLinkedin();
              },
            ),


            thank_you()
          ],
        ),
      ),
    );
  }

  Widget profile_photo() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: Get.width * 0.8,
              width: Get.width * 0.8,
              child: Image.asset('assets/icons/profile_photo.jpeg'),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget thank_you() {
    return const Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Center(
            child: Text(
              '----Thank You----',
              style: TextStyle(fontSize: 30, fontFamily: 'OpenSans'),
            )),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
