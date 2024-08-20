import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Countries_api extends StatefulWidget {
  const Countries_api({super.key});

  @override
  State<Countries_api> createState() => _Countries_apiState();
}

class _Countries_apiState extends State<Countries_api> {
  Future<List<String>> getTime() async {
    const endpoint = "https://restcountries.com/v3.1/all";
    Logger().i(endpoint);
    try {
      final response = await http.get(Uri.parse(endpoint));
      Logger().i(response);

      if (response.statusCode == 200) {
        List<String> countries = [];
        List<dynamic> data = jsonDecode(response.body);
        for (var country in data) {
          countries.add(
              "${country['name']['common']} - Population: ${country['population']}");
        }
        return countries;
      } else {
        Logger().e("Error: ${response.statusCode}");
        return ["Error - ${response.statusCode}"];
      }
    } catch (e) {
      Logger().e("Exception: $e");
      return ["Error - $e"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countries"),
      ),
      body: Center(
        child: FutureBuilder(
          future: getTime(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data![index]),
                  );
                },
              );
            } else {
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }
}
