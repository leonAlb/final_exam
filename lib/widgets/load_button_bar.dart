import 'package:flutter/material.dart';

class LoadButtonBar extends StatelessWidget {
    final bool canLoadMore;
    final VoidCallback onLoadMore;
    final String loadMoreLabel;
    final bool isLoadingMore;
    final VoidCallback onCreate;
    final IconData createIcon;
    final String createLabel;

    const LoadButtonBar({
        super.key,
        required this.canLoadMore,
        required this.onLoadMore,
        this.loadMoreLabel = "Load More",
        this.isLoadingMore = false,
        required this.onCreate,
        this.createIcon = Icons.add,
        required this.createLabel
    });

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                children: [
                    ElevatedButton.icon(
                        onPressed: canLoadMore ? onLoadMore : null,
                        icon: canLoadMore
                            ? const Icon(Icons.add)
                            : const Icon(Icons.check_circle_outline),
                        label: canLoadMore
                            ? Text(loadMoreLabel)
                            : Text("All Loaded!"),
                        iconAlignment: IconAlignment.end,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            backgroundColor: canLoadMore ? null : Colors.grey
                        )
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                        onPressed: onCreate,
                        icon: Icon(createIcon),
                        label: Text(createLabel),
                        iconAlignment: IconAlignment.start,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0)
                        )
                    )
                ]
            )
        );
    }
}