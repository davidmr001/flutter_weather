import 'package:flutter_weather/commom_import.dart';

abstract class WeatherInter<T extends StatefulWidget> extends Inter<T> {
  Function openDrawer;

  void setDrawerOpenFunc({@required Function openDrawer}) {
    this.openDrawer = openDrawer;
  }
}
