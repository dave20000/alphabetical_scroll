import 'dart:developer';

import 'package:alphabetical_scroll/alphabetical_scroll.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'contact_info.dart';
import 'contact_tile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ContactInfo> contacts = [];

  List<ContactInfo> contactList = [];

  @override
  void initState() {
    super.initState();
    var faker = Faker();

    for (int i = 0; i < 100; i++) {
      if (i < 60) {
        contacts.add(ContactInfo(
          id: i,
          name: faker.person.name(),
          bgColor: Colors.blue,
        ));
        // contacts.add(faker.person.name());
      }
      // else if (i > 60 && i < 90) {
      //   contacts.add(ContactInfo(
      //     id: i,
      //     name: faker.person.firstName(),
      //     bgColor: Colors.blue,
      //   ));
      //   // contacts.add(faker.phoneNumber.us());
      // }
      else {
        contacts.add(ContactInfo(
          id: i,
          name: faker.phoneNumber.us(),
          bgColor: Colors.blue,
        ));
        // contacts.add(faker.phoneNumber.us());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: const Color(0xFFEDEDED),
          title: const Text(
            'Contacts',
            style: TextStyle(color: Color(0xFF171717)),
          ),
        ),
        body: AlphabetListScreen<ContactInfo>(
          itemBuilder: (context, contactInfo) {
            return ContactTile(
              name: contactInfo.name,
            );
          },
          sources: contacts,
          sourceFilterItemList: contacts.map((e) => e.name).toList(),
          onTap: (item) {
            log("pressed ${item.id} do something");
          },
        ),
      ),
    );
  }
}
