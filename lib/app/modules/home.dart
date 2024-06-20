import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todark/app/modules/tasks/view/all_tasks.dart';
import 'package:todark/app/modules/settings/view/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/modules/tasks/widgets/tasks_action.dart';
import 'package:todark/app/modules/todos/view/calendar_todos.dart';
import 'package:todark/app/modules/todos/view/all_todos.dart';
import 'package:todark/app/modules/todos/widgets/todos_action.dart';
import 'package:todark/theme/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final themeController = Get.put(ThemeController());
  int tabIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: returnBody(tabIndex),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: tabIndex,
        backgroundColor: Theme.of(context).primaryColor,
        showElevation: false,
        animationCurve: Curves.decelerate,
        animationDuration: const Duration(milliseconds: 400),
        onItemSelected: (index) => setState(() {
          tabIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: returnIcon(0),
            title: returnText(0),
          ),
          FlashyTabBarItem(
            icon: returnIcon(1),
            title: returnText(1),
          ),
          FlashyTabBarItem(
            icon: returnIcon(2),
            title: returnText(2),
          ),
        ],
      ).animate()
          .fadeIn(duration: 1000.ms)
          .slideY(duration: 1000.ms, curve: Curves.decelerate, begin: 0.5),

      floatingActionButton: tabIndex == 2
          ? null
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  enableDrag: false,
                  isDismissible: false,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return tabIndex == 0
                        ? TasksAction(
                            text: 'create'.tr,
                            edit: false,
                          )
                        : TodosAction(
                            text: 'create'.tr,
                            edit: false,
                            category: true,
                          );
                  },
                );
              },
              child: const Icon(Iconsax.add),
            ),
    );
  }

  Widget returnIcon(int index){
    if(index==0){
      return Icon(Iconsax.folder_2, size: 25, color: context.iconColor,);
    }else if (index ==1){
      return Icon(Icons.shopping_cart_outlined, size: 25, color: context.iconColor,);
    }else{
      return Icon(Iconsax.setting, size: 25, color: context.iconColor,);
    }
  }


  Widget returnText(int index){
    if(index==0){
      return Text('Categories', style: context.textTheme.bodyLarge);
    }else if (index ==1){
      return Text('All Todos',style: context.textTheme.bodyLarge);
    }else{
      return Text('Settings', style: context.textTheme.bodyLarge);
    }
  }

  Widget returnBody(int index){
    if(index==0){
      return AllTasks();
    }else if (index ==1){
      return AllTodos();
    } else{
      return SettingsPage();
    }
  }
}
