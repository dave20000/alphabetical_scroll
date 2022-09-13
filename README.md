# A Flutter package to achieve alphabet scrolling. Based on flutter_sticky_header

## Features

Add this to your flutter app to:

1. Have alphabet stacked scroll bar.
2. Scrolling with list view header alphabet persistent to stacked scroll bar alphabet.
3. Call on tap function on list view item tapped
4. Support easy creation of the contacts or countries app list view interface
5. Support custom header
6. Support styling stacked alphabet scrollbar
7. Support custom widget for list view item

## Getting started

Add the package to your pubspec.yaml:

```yaml
alphabetical_scroll:
```

In your dart file, import the library:

```dart
import 'package:alphabetical_scroll/alphabetical_scroll.dart';
```

## Usage

Firstly,you can have list of data items:

```dart
List<String> contacts = ["Jessica Jones","Rob Stark","Tom Holland",];
```

After that, you can get the required dependencies from pub.dev and use the below code in your project like this

```dart
body: AlphabetListScreen<String>(
    itemBuilder: (context, name) {
        return ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                    name name,
                    style: const TextStyle(color: Colors.white,),
                ),
            ),
            title: Text(name ?? ""),
        );
    },
    sources: contacts,
    soruceFilterItemList: contacts,
    onTap: (item) {
        print("pressed ${item.id} do something");
    },
),
```
