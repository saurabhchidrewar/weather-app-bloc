import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:weather_app/models/temperature.dart' as temp;

class MockWeatherBloc extends MockBloc<WeatherBlocEvent, WeatherBlocState>
    implements WeatherBlocBloc {}

void main() {
  group('HomeScreen Integration Tests', () {
    late WeatherBlocBloc weatherBloc;

    setUp(() {
      weatherBloc = MockWeatherBloc();
    });

    tearDown(() {
      weatherBloc.close();
    });

    testWidgets('renders HomeScreen and initial UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WeatherBlocBloc>(
            create: (_) => weatherBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays weather details on success',
        (WidgetTester tester) async {
      // Prepare mock WeatherBlocSuccess state
      final weatherState = WeatherBlocSuccess(
        WeatherModel(
          areaName: 'New York',
          weatherConditionCode: 500,
          temperature: temp.Temperature(celsius: 25.0),
          weatherMain: 'Cloudy',
          date: DateTime.now(),
          sunrise: DateTime.now().subtract(const Duration(hours: 5)),
          sunset: DateTime.now().add(const Duration(hours: 5)),
          tempMax: temp.Temperature(celsius: 28.0),
          tempMin: temp.Temperature(celsius: 20.0),
        ) as Weather,
      );

      when(() => weatherBloc.state).thenReturn(weatherState);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WeatherBlocBloc>(
            create: (_) => weatherBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('📍 San Francisco'), findsOneWidget);

      expect(find.text('25°C'), findsOneWidget);
      expect(find.text('CLOUDY'), findsOneWidget);

      expect(find.text('Sunrise'), findsOneWidget);
      expect(find.text('Sunset'), findsOneWidget);

      expect(find.text('28 °C'), findsOneWidget);
      expect(find.text('20 °C'), findsOneWidget);
    });

    testWidgets('renders fallback UI on loading or empty state',
        (WidgetTester tester) async {
      when(() => weatherBloc.state).thenReturn(WeatherBlocLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WeatherBlocBloc>(
            create: (_) => weatherBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Container), findsOneWidget);
    });
  });
}
