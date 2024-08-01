// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_weather_app_clone/AppUtils/app_colors.dart';
// import 'package:flutter_weather_app_clone/AppUtils/app_constants.dart';
// import 'package:flutter_weather_app_clone/AppUtils/app_font_size.dart';
// import 'package:flutter_weather_app_clone/AppUtils/app_font_weight.dart';
// import 'package:flutter_weather_app_clone/AppUtils/app_strings.dart';
// import 'package:flutter_weather_app_clone/Presentation/Widgets/next_day_item_widget.dart';

// import 'package:weather/weather.dart';
// import 'package:intl/intl.dart';


// class NextDayForeCastScreen extends StatefulWidget {
//   final String cityName;
//   const NextDayForeCastScreen({
//     super.key,
//     required this.cityName,
//   });

//   @override
//   State<NextDayForeCastScreen> createState() => _NextDayForeCastScreenState();
// }

// class _NextDayForeCastScreenState extends State<NextDayForeCastScreen> {
//   final WeatherFactory _wf = WeatherFactory(AppConstants.openWhetherKey);

//   List<Weather>? forecastsList = [];
//   @override
//   void initState() {
//     getWhetherOfNextFiveDays(widget.cityName);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // All Function & Methods will go above Build()

//   getWhetherOfNextFiveDays(String cityName) {
//     _wf.fiveDayForecastByCityName(cityName).then((w) {
//       setState(() {
//         forecastsList = w;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: 15,
//           ),
//           Text(
//             AppStrings.nextFiveDayscast,
//             style: TextStyle(
//               color: AppColors.deepPurple,
//               fontSize: AppFontSize.fontSize24,
//               fontWeight: AppFontWeight.fontWeight600,
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: forecastsList!.length ?? 1,
//               itemBuilder: (context, index) {
//                 DateTime? now = forecastsList![index].date;
//                 final DateFormat formatter = DateFormat('dd/MM/yyyy');
//                 final String formatted = formatter.format(now!);
//                 return Padding(
//                   padding: EdgeInsets.all(10.0),
//                   child: NextDayitemWidget(
//                     datetxt: formatted,
//                     maxTemp: forecastsList![index].tempMax.toString(),
//                     minTemp: forecastsList![index].tempMin.toString(),
//                     wind: forecastsList![index].windSpeed.toString(),
//                     humidity: forecastsList![index].humidity.toString(),
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//     ));
//   }

//   // All design widgets will go below Build()
// }


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather_app_clone/AppUtils/app_colors.dart';
import 'package:flutter_weather_app_clone/AppUtils/app_constants.dart';
import 'package:flutter_weather_app_clone/AppUtils/app_strings.dart';
import 'package:flutter_weather_app_clone/Presentation/Widgets/next_day_item_widget.dart';

import 'package:weather/weather.dart';
import 'package:intl/intl.dart';

class NextDayForeCastScreen extends StatefulWidget {
  final String cityName;
  const NextDayForeCastScreen({
    super.key,
    required this.cityName,
  });

  @override
  State<NextDayForeCastScreen> createState() => _NextDayForeCastScreenState();
}

class _NextDayForeCastScreenState extends State<NextDayForeCastScreen> {
  final WeatherFactory _wf = WeatherFactory(AppConstants.openWhetherKey);

  List<Map<String, dynamic>> dailyForecasts = []; 

  @override
  void initState() {
    getWhetherOfNextFiveDays(widget.cityName);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getWhetherOfNextFiveDays(String cityName) async {
    List<Weather> forecasts = await _wf.fiveDayForecastByCityName(cityName);

    Map<String, List<Weather>> groupedForecasts = {};

    for (var forecast in forecasts) {
      String day = DateFormat('yyyy-MM-dd').format(forecast.date!);
      
      if (!groupedForecasts.containsKey(day)) {
        groupedForecasts[day] = [];
      }
      groupedForecasts[day]!.add(forecast);
    }

    groupedForecasts.forEach((day, dayForecasts) {
      
      double minTemp = dayForecasts.first.tempMin?.celsius ?? 0;
      double maxTemp = dayForecasts.first.tempMax?.celsius ?? 0;
      double windSpeed = dayForecasts.first.windSpeed ?? 0;
      double humidity = dayForecasts.first.humidity ?? 0;

      for (var forecast in dayForecasts) {
        if (forecast.tempMin?.celsius != null && forecast.tempMin!.celsius! < minTemp) {
          minTemp = forecast.tempMin!.celsius!;
        }
        if (forecast.tempMax?.celsius != null && forecast.tempMax!.celsius! > maxTemp) {
          maxTemp = forecast.tempMax!.celsius!;
        }
        windSpeed += forecast.windSpeed ?? 0;
        humidity += forecast.humidity ?? 0;
      }

      windSpeed /= dayForecasts.length;
      humidity /= dayForecasts.length;

      dailyForecasts.add({
        'date': day,
        'minTemp': minTemp.toStringAsFixed(1),
        'maxTemp': maxTemp.toStringAsFixed(1),
        'wind': windSpeed.toStringAsFixed(1),
        'humidity': humidity.toStringAsFixed(1),
      });
    });

  
    setState(() {
      dailyForecasts = dailyForecasts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:Color.fromARGB(255, 248, 230, 176),
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              AppStrings.nextFiveDayscast,
              style: TextStyle(
                color: AppColors.deepPurple,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dailyForecasts.length,
                itemBuilder: (context, index) {
                  final forecast = dailyForecasts[index];
                  
                  
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: NextDayitemWidget(
                      datetxt: forecast['date'],
                      maxTemp: forecast['maxTemp'],
                      minTemp: forecast['minTemp'],
                      wind: forecast['wind'],
                      humidity: forecast['humidity'],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
