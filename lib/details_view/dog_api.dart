import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class DogApi extends StatefulWidget {
  const DogApi({super.key});

  @override
  State<DogApi> createState() => _DogApiState();
}

class _DogApiState extends State<DogApi> {
  Future<List<String>> getSpaceX() async {
    const endpoint =
        "https://api.thecatapi.com/v1/images/search?limit=10&breed_ids=beng&live_rbEO7MjfVYST3rYvSr4JOUxCH9OOXgHrKLfuOP6kBnrzIG7mj1mAlmiw3Wkzh3J9";
    List<String> values = [];
    Logger().i(endpoint);
    try {
      final response = await http.get(Uri.parse(endpoint));
      Logger().i(response);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        for (var item in data) {
          values.add(
              " capsule_serial - ${item['capsule_serial']} \n capsule_id - ${item['capsule_id']} \n original_launch - ${item['original_launch']} \n details - ${item['details']}");
        }
        return values;
      } else {
        Logger().e(response.statusCode);
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
        title: const Text("Dogs details"),
      ),
      body: Center(
        child: FutureBuilder(
          future: getSpaceX(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError || snapshot.data == null) {
              // Handle the error or null data case here
              return const Text("Error");
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
