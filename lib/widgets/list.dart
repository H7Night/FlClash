import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/open_container.dart';
import 'package:flutter/material.dart';

import 'card.dart';
import 'input.dart';
import 'scaffold.dart';
import 'sheet.dart';

class Delegate {
  const Delegate();
}

class RadioDelegate<T> extends Delegate {
  final T value;
  final T groupValue;
  final void Function(T?)? onChanged;

  const RadioDelegate({
    required this.value,
    required this.groupValue,
    this.onChanged,
  });
}

class SwitchDelegate<T> extends Delegate {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitchDelegate({
    required this.value,
    this.onChanged,
  });
}

class CheckboxDelegate<T> extends Delegate {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const CheckboxDelegate({
    this.value = false,
    this.onChanged,
  });
}

class OpenDelegate extends Delegate {
  final Widget widget;
  final String title;
  final double? maxWidth;
  final Widget? action;
  final bool blur;

  const OpenDelegate({
    required this.title,
    required this.widget,
    this.maxWidth,
    this.action,
    this.blur = true,
  });
}

class OptionsDelegate<T> extends Delegate {
  final List<T> options;
  final String title;
  final T value;
  final String Function(T value) textBuilder;
  final Function(T? value) onChanged;

  const OptionsDelegate({
    required this.title,
    required this.options,
    required this.textBuilder,
    required this.value,
    required this.onChanged,
  });
}

class InputDelegate extends Delegate {
  final String title;
  final String value;
  final String? suffixText;
  final Function(String? value) onChanged;
  final String? resetValue;

  const InputDelegate({
    required this.title,
    required this.value,
    this.suffixText,
    required this.onChanged,
    this.resetValue,
  });
}

class ListItem<T> extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final EdgeInsets padding;
  final ListTileTitleAlignment tileTitleAlignment;
  final bool? dense;
  final Widget? trailing;
  final Delegate delegate;
  final double? horizontalTitleGap;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final void Function()? onTap;

  const ListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.trailing,
    this.horizontalTitleGap,
    this.dense,
    this.onTap,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.tileTitleAlignment = ListTileTitleAlignment.center,
  }) : delegate = const Delegate();

  const ListItem.open({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.trailing,
    required OpenDelegate this.delegate,
    this.horizontalTitleGap,
    this.dense,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.tileTitleAlignment = ListTileTitleAlignment.center,
  }) : onTap = null;

  const ListItem.options({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.trailing,
    required OptionsDelegate<T> this.delegate,
    this.horizontalTitleGap,
    this.dense,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.tileTitleAlignment = ListTileTitleAlignment.center,
  }) : onTap = null;

  const ListItem.input({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.trailing,
    required InputDelegate this.delegate,
    this.horizontalTitleGap,
    this.dense,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.tileTitleAlignment = ListTileTitleAlignment.center,
  }) : onTap = null;

  const ListItem.checkbox({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.only(left: 16, right: 8),
    required CheckboxDelegate<T> this.delegate,
    this.horizontalTitleGap,
    this.dense,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.tileTitleAlignment = ListTileTitleAlignment.center,
  })  : trailing = null,
        onTap = null;

  const ListItem.switchItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.padding = const EdgeInsets.only(left: 16, right: 8),
    required SwitchDelegate<T> this.delegate,
    this.horizontalTitleGap,
    this.dense,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.tileTitleAlignment = ListTileTitleAlignment.center,
  })  : trailing = null,
        onTap = null;

  const ListItem.radio({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.only(left: 12, right: 16),
    required RadioDelegate<T> this.delegate,
    this.horizontalTitleGap = 8,
    this.dense,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.tileTitleAlignment = ListTileTitleAlignment.center,
  })  : leading = null,
        onTap = null;

  _buildListTile({
    void Function()? onTap,
    Widget? trailing,
    Widget? leading,
  }) {
    return ListTile(
      key: key,
      dense: dense,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      leading: leading ?? this.leading,
      horizontalTitleGap: horizontalTitleGap,
      title: title,
      subtitle: subtitle,
      titleAlignment: tileTitleAlignment,
      onTap: onTap,
      trailing: trailing ?? this.trailing,
      contentPadding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (delegate is OpenDelegate) {
      final openDelegate = delegate as OpenDelegate;
      final child = SafeArea(
        child: openDelegate.widget,
      );
      return OpenContainer(
        closedBuilder: (_, action) {
          openAction() {
            final isMobile = globalState.appState.viewMode == ViewMode.mobile;
            if (!isMobile) {
              showExtend(
                context,
                props: ExtendProps(
                  blur: openDelegate.blur,
                  maxWidth: openDelegate.maxWidth,
                ),
                builder: (_, type) {
                  return AdaptiveSheetScaffold(
                    actions: [
                      if (openDelegate.action != null) openDelegate.action!,
                    ],
                    type: type,
                    body: child,
                    title: openDelegate.title,
                  );
                },
              );
              return;
            }
            action();
          }

          return _buildListTile(
            onTap: openAction,
          );
        },
        openBuilder: (_, action) {
          return CommonScaffold.open(
            key: Key(openDelegate.title),
            onBack: action,
            title: openDelegate.title,
            body: child,
            actions: [
              if (openDelegate.action != null) openDelegate.action!,
            ],
          );
        },
      );
    }
    if (delegate is OptionsDelegate) {
      final optionsDelegate = delegate as OptionsDelegate<T>;
      return _buildListTile(
        onTap: () async {
          final value = await globalState.showCommonDialog<T>(
            child: OptionsDialog<T>(
              title: optionsDelegate.title,
              options: optionsDelegate.options,
              textBuilder: optionsDelegate.textBuilder,
              value: optionsDelegate.value,
            ),
          );
          optionsDelegate.onChanged(value);
        },
      );
    }
    if (delegate is InputDelegate) {
      final inputDelegate = delegate as InputDelegate;
      return _buildListTile(
        onTap: () async {
          final value = await globalState.showCommonDialog<String>(
            child: InputDialog(
              title: inputDelegate.title,
              value: inputDelegate.value,
              suffixText: inputDelegate.suffixText,
              resetValue: inputDelegate.resetValue,
            ),
          );
          inputDelegate.onChanged(value);
        },
      );
    }
    if (delegate is CheckboxDelegate) {
      final checkboxDelegate = delegate as CheckboxDelegate;
      return _buildListTile(
        onTap: () {
          if (checkboxDelegate.onChanged != null) {
            checkboxDelegate.onChanged!(!checkboxDelegate.value);
          }
        },
        trailing: CommonCheckBox(
          value: checkboxDelegate.value,
          onChanged: checkboxDelegate.onChanged,
        ),
      );
    }
    if (delegate is SwitchDelegate) {
      final switchDelegate = delegate as SwitchDelegate;
      return _buildListTile(
        onTap: () {
          if (switchDelegate.onChanged != null) {
            switchDelegate.onChanged!(!switchDelegate.value);
          }
        },
        trailing: Switch(
          value: switchDelegate.value,
          onChanged: switchDelegate.onChanged,
        ),
      );
    }
    if (delegate is RadioDelegate) {
      final radioDelegate = delegate as RadioDelegate<T>;
      return _buildListTile(
        onTap: () {
          if (radioDelegate.onChanged != null) {
            radioDelegate.onChanged!(radioDelegate.value);
          }
        },
        leading: SizedBox(
          width: 32,
          height: 32,
          child: Radio<T>(
            value: radioDelegate.value,
            groupValue: radioDelegate.groupValue,
            onChanged: radioDelegate.onChanged,
          ),
        ),
        trailing: trailing,
      );
    }

    return _buildListTile(
      onTap: onTap,
    );
  }
}

class ListHeader extends StatelessWidget {
  final String title;
  final String? subTitle;
  final List<Widget> actions;
  final EdgeInsets? padding;
  final double? space;

  const ListHeader({
    super.key,
    required this.title,
    this.subTitle,
    this.padding,
    List<Widget>? actions,
    this.space,
  }) : actions = actions ?? const [];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: padding ??
          const EdgeInsets.only(
            left: 16,
            right: 8,
            top: 24,
            bottom: 8,
          ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .opacity80,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ...genActions(
                actions,
                space: space,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<Widget> generateSection({
  String? title,
  required Iterable<Widget> items,
  List<Widget>? actions,
  bool separated = true,
}) {
  final genItems = separated
      ? items.separated(
          const Divider(
            height: 0,
          ),
        )
      : items;
  return [
    if (items.isNotEmpty && title != null)
      ListHeader(
        title: title,
        actions: actions,
      ),
    ...genItems,
  ];
}

List<Widget> generateInfoSection({
  required Info info,
  required Iterable<Widget> items,
  List<Widget>? actions,
  bool separated = true,
}) {
  final genItems = separated
      ? items.separated(
          const Divider(
            height: 0,
          ),
        )
      : items;
  return [
    if (items.isNotEmpty)
      InfoHeader(
        info: info,
        actions: actions,
      ),
    ...genItems,
  ];
}

Widget generateListView(List<Widget> items) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (_, index) => items[index],
    padding: const EdgeInsets.only(
      bottom: 16,
    ),
  );
}