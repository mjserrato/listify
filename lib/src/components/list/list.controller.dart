import 'package:flutter/foundation.dart';
import 'package:listify/src/components/current-list/current-list.controller.dart';
import 'package:momentum/momentum.dart';

import '../../data/list-data.dart';
import '../../data/list-item.dart';
import '../input/index.dart';
import 'index.dart';

class ListController extends MomentumController<ListModel> {
  @override
  ListModel init() {
    return ListModel(
      this,
      items: [],
    );
  }

  bool dataExists(String listName, List<ListItem> items) {
    var exists = model.items.any((e) => e.listName == listName || listEquals(e.items, items));
    return exists;
  }

  void addList(ListData item) {
    var lists = List<ListData>.from(model.items);
    lists.add(item);
    model.update(items: lists);
  }

  /// Reorder the items in the model and rebuild the widgets.
  void reorder(int oldIndex, int newIndex) {
    var lists = List<ListData>.from(model.items); // create new instance of list.
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var item = lists.removeAt(oldIndex);
    lists.insert(newIndex, item);
    model.update(items: lists);
  }

  void reorderListItems(int oldIndex, int newIndex) {
    var dataItems = List<ListData>.from(model.items);
    var items = List<ListItem>.from(dataItems[model.viewingIndex].items);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    var data = ListData(
      listName: dataItems[model.viewingIndex].listName,
      items: items,
    );
    dataItems
      ..removeAt(model.viewingIndex)
      ..insert(model.viewingIndex, data);
    model.update(items: dataItems);
  }

  void removeItem(int index) {
    var items = List<ListData>.from(model.items); // create new instance of list.
    model.update(items: items..removeAt(index));
  }

  void removeListItem(int index) {
    var dataItems = List<ListData>.from(model.items);
    var items = List<ListItem>.from(dataItems[model.viewingIndex].items);
    items.removeAt(index);
    var data = ListData(
      listName: dataItems[model.viewingIndex].listName,
      items: items,
    );
    dataItems
      ..removeAt(model.viewingIndex)
      ..insert(model.viewingIndex, data);
    model.update(items: dataItems);
  }

  void createCopy(int index) {
    var inputController = dependOn<InputController>();
    var toCopy = model.items[index];
    inputController.setListName(toCopy.listName);
    inputController.setItems(toCopy.items);
  }

  bool getCheckState(int index) {
    var hasChecked = model.items[index].items.any((x) => x.listState == true);
    var hasUnchecked = model.items[index].items.any((x) => x.listState == false);
    var hasPartial = model.items[index].items.any((x) => x.listState == null);
    if (hasChecked && hasUnchecked) return null;
    if (hasPartial) return null;
    return hasChecked && !hasUnchecked && !hasPartial;
  }

  void view(int index) {
    model.update(viewingIndex: index);
    viewData();
  }

  void viewData() {
    var data = model.items[model.viewingIndex];
    dependOn<CurrentListController>().viewData(data);
  }

  void toggleItemState(int index) {
    var dataItems = List<ListData>.from(model.items);
    var items = List<ListItem>.from(dataItems[model.viewingIndex].items);
    var item = items[index];
    var state = item.listState;
    var updatedItem = ListItem(
      name: item.name,
      listState: state == false ? true : state == true ? null : false,
    );
    items
      ..removeAt(index)
      ..insert(index, updatedItem);
    var data = ListData(
      listName: dataItems[model.viewingIndex].listName,
      items: items,
    );
    dataItems
      ..removeAt(model.viewingIndex)
      ..insert(model.viewingIndex, data);
    model.update(items: dataItems);
  }
}
