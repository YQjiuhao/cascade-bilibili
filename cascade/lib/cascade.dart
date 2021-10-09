import 'dart:html';

import 'package:flutter/material.dart';

/// 待选项模型，建立模型好规范数据
class CascadeItem {
  CascadeItem({required this.title, this.value, this.children});

  /// 标题
  final String title;

  /// 自选项
  final List<CascadeItem>? children;

  /// 需要选择的真实值
  final dynamic value;

  @override
  int get hashCode => title.hashCode | (value?.hashCode ?? 0);

  @override
  bool operator ==(Object other) {
    if (other is! CascadeItem) return false;
    return other.hashCode == hashCode;
  }
}

class CascadeView extends StatefulWidget {
  const CascadeView(this.datas, {Key? key, this.level = 2})
      : assert(level == 2 || level == 3, "不能低于两级或不能超过三级"),
        super(key: key);

  /// 传入待选项
  final List<CascadeItem> datas;

  /// 联级层此
  final int level;

  @override
  CascadeViewState createState() => CascadeViewState();
}

class CascadeViewState extends State<CascadeView> {
  /// 待选项
  final List<List<CascadeItem>> _candidateList = [];

  /// 已选项
  final List<CascadeItem> _selecteds = [];

  void _dataHandler(List<CascadeItem> datas) {
    if (_selecteds.isEmpty) {
      // 如果没有选择值，默认第一个选项为已选值
      _selecteds.add(datas.first);
    }
    // 设置默认值
    if (_selecteds.length != widget.level) {
      for (var i = 0; i < widget.level; i++) {
        if (i < _selecteds.length &&
            _selecteds[i].children?.isNotEmpty == true) {
          _selecteds.add(_selecteds[i].children!.first);
        }
      }
    }

    _candidateList.clear();
    _candidateList.add(datas);
    for (var i = 0; i < _selecteds.length; i++) {
      // 当前已选项所在的集合为候选项
      if (_selecteds[i].children?.isNotEmpty == true) {
        _candidateList.add(_selecteds[i].children ?? []);
      }
    }
  }

  /// 生成待选择列表
  Widget _generateListView(List<CascadeItem> datas, int level) {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return _CascadeViewTile(
            datas[index],
            (item) {
              _selecteds.removeRange(level, _selecteds.length);
              _selecteds.add(item);
              _dataHandler(datas);
              if (item.children?.isNotEmpty != true) {
                // 结果值返回
                Navigator.pop(context, _selecteds.map((e) => e.value).toList());
              }
              setState(() {});
            },
            selected: _selecteds.contains(datas[index]),
          );
        },
        itemCount: datas.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _dataHandler(widget.datas);
    return Container(
      height: 400,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: List.generate(widget.level, (index) {
          if (index >= _candidateList.length) return const SizedBox();
          return _generateListView(_candidateList[index], index);
        }),
      ),
    );
  }
}

class _CascadeViewTile extends StatelessWidget {
  const _CascadeViewTile(this.item, this.onTap, {this.selected = false});

  final CascadeItem item;

  final void Function(CascadeItem) onTap;

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item),
      child: ColoredBox(
        color: selected ? Colors.white : Colors.grey,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Text(item.title),
            ),
            const Icon(Icons.arrow_right),
          ],
        ),
      ),
    );
  }
}
