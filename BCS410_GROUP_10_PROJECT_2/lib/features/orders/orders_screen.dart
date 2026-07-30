import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const int _ordersPerPage = 5;

  final List<OrderItem> _orders = const [
    OrderItem(
      id: 'GA10432',
      date: 'Jul 30, 2026',
      itemCount: 3,
      total: 50.50,
      status: OrderStatus.onTheWay,
      progress: 0.75,
    ),
    OrderItem(
      id: 'GA10388',
      date: 'Jul 21, 2026',
      itemCount: 4,
      total: 33.20,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'GA10351',
      date: 'Jul 14, 2026',
      itemCount: 2,
      total: 27.90,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'GA10296',
      date: 'Jul 7, 2026',
      itemCount: 6,
      total: 91.40,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'GA10244',
      date: 'Jun 28, 2026',
      itemCount: 1,
      total: 15.00,
      status: OrderStatus.cancelled,
    ),
    OrderItem(
      id: 'GA10201',
      date: 'Jun 18, 2026',
      itemCount: 5,
      total: 72.80,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'GA10178',
      date: 'Jun 10, 2026',
      itemCount: 3,
      total: 48.50,
      status: OrderStatus.cancelled,
    ),
    OrderItem(
      id: 'GA10122',
      date: 'May 29, 2026',
      itemCount: 7,
      total: 110.60,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'GA10095',
      date: 'May 20, 2026',
      itemCount: 2,
      total: 31.25,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'GA10048',
      date: 'May 12, 2026',
      itemCount: 4,
      total: 67.90,
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: 'GA10011',
      date: 'May 2, 2026',
      itemCount: 3,
      total: 44.30,
      status: OrderStatus.cancelled,
    ),
  ];

  OrderFilter _selectedFilter = OrderFilter.all;
  int _currentPage = 0;

  List<OrderItem> get _filteredOrders {
    switch (_selectedFilter) {
      case OrderFilter.all:
        return _orders;

      case OrderFilter.active:
        return _orders.where((order) {
          return order.status == OrderStatus.processing ||
              order.status == OrderStatus.onTheWay;
        }).toList();

      case OrderFilter.delivered:
        return _orders.where((order) {
          return order.status == OrderStatus.delivered;
        }).toList();

      case OrderFilter.cancelled:
        return _orders.where((order) {
          return order.status == OrderStatus.cancelled;
        }).toList();
    }
  }

  OrderItem? get _activeOrder {
    for (final order in _orders) {
      if (order.status == OrderStatus.processing ||
          order.status == OrderStatus.onTheWay) {
        return order;
      }
    }

    return null;
  }

  void _selectFilter(OrderFilter filter) {
    setState(() {
      _selectedFilter = filter;
      _currentPage = 0;
    });
  }

  void _changePage(int page, int totalPages) {
    if (page < 0 || page >= totalPages) {
      return;
    }

    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _filteredOrders;

    final totalPages = filteredOrders.isEmpty
        ? 0
        : (filteredOrders.length / _ordersPerPage).ceil();

    final safeCurrentPage = totalPages == 0
        ? 0
        : _currentPage.clamp(0, totalPages - 1);

    final startIndex = safeCurrentPage * _ordersPerPage;

    final endIndex = math.min(
      startIndex + _ordersPerPage,
      filteredOrders.length,
    );

    final visibleOrders = filteredOrders.isEmpty
        ? <OrderItem>[]
        : filteredOrders.sublist(startIndex, endIndex);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
          constraints.maxWidth >= 700 ? 40.0 : 20.0;

          return ListView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              32,
            ),
            children: [
              const _OrdersHeader(),

              const SizedBox(height: 24),

              if (_activeOrder != null) ...[
                _ActiveOrderCard(
                  order: _activeOrder!,
                  onTrackOrder: () {
                    _showOrderDetails(
                      context,
                      _activeOrder!,
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],

              const Text(
                'Order history',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 21,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'View and manage your previous grocery orders.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              _OrderFilters(
                selectedFilter: _selectedFilter,
                onSelected: _selectFilter,
              ),

              const SizedBox(height: 20),

              _OrderResultSummary(
                totalOrders: filteredOrders.length,
                startIndex:
                filteredOrders.isEmpty ? 0 : startIndex + 1,
                endIndex: endIndex,
              ),

              const SizedBox(height: 14),

              if (visibleOrders.isEmpty)
                const _EmptyOrdersState()
              else
                ...visibleOrders.map(
                      (order) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: _OrderCard(
                      order: order,
                      onTap: () {
                        _showOrderDetails(
                          context,
                          order,
                        );
                      },
                    ),
                  ),
                ),

              if (totalPages > 1) ...[
                const SizedBox(height: 14),
                _PaginationControls(
                  currentPage: safeCurrentPage,
                  totalPages: totalPages,
                  onPageSelected: (page) {
                    _changePage(
                      page,
                      totalPages,
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showOrderDetails(
      BuildContext context,
      OrderItem order,
      ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return _OrderDetailsSheet(
          order: order,
        );
      },
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My orders',
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 29,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Track current orders and view your history.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.softGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_outlined,
            color: AppColors.darkGreen,
          ),
        ),
      ],
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({
    required this.order,
    required this.onTrackOrder,
  });

  final OrderItem order;
  final VoidCallback onTrackOrder;

  @override
  Widget build(BuildContext context) {
    final statusDetails = order.status.details;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withValues(
              alpha: 0.16,
            ),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active order',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Order #${order.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  statusDetails.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _ActiveOrderInfo(
                  label: 'Items',
                  value: '${order.itemCount}',
                ),
              ),
              Container(
                width: 1,
                height: 34,
                color: Colors.white.withValues(
                  alpha: 0.18,
                ),
              ),
              Expanded(
                child: _ActiveOrderInfo(
                  label: 'Total',
                  value: _formatMoney(order.total),
                ),
              ),
              Container(
                width: 1,
                height: 34,
                color: Colors.white.withValues(
                  alpha: 0.18,
                ),
              ),
              Expanded(
                child: _ActiveOrderInfo(
                  label: 'Date',
                  value: order.date.split(',').first,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: order.progress,
              minHeight: 8,
              color: Colors.white,
              backgroundColor: Colors.white.withValues(
                alpha: 0.18,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your groceries are on the way.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(order.progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onTrackOrder,
              icon: const Icon(
                Icons.location_searching_rounded,
                size: 19,
              ),
              label: const Text('Track order'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.darkGreen,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveOrderInfo extends StatelessWidget {
  const _ActiveOrderInfo({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _OrderFilters extends StatelessWidget {
  const _OrderFilters({
    required this.selectedFilter,
    required this.onSelected,
  });

  final OrderFilter selectedFilter;
  final ValueChanged<OrderFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: OrderFilter.values.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 9);
        },
        itemBuilder: (context, index) {
          final filter = OrderFilter.values[index];
          final isSelected = filter == selectedFilter;

          return ChoiceChip(
            selected: isSelected,
            label: Text(filter.label),
            onSelected: (_) {
              onSelected(filter);
            },
            showCheckmark: false,
            side: BorderSide(
              color: isSelected
                  ? AppColors.green
                  : AppColors.border,
            ),
            selectedColor: AppColors.green,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : AppColors.darkGreen,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
          );
        },
      ),
    );
  }
}

class _OrderResultSummary extends StatelessWidget {
  const _OrderResultSummary({
    required this.totalOrders,
    required this.startIndex,
    required this.endIndex,
  });

  final int totalOrders;
  final int startIndex;
  final int endIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          totalOrders == 1
              ? '1 order'
              : '$totalOrders orders',
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          totalOrders == 0
              ? 'No results'
              : '$startIndex–$endIndex of $totalOrders',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onTap,
  });

  final OrderItem order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusDetails = order.status.details;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: statusDetails.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  statusDetails.icon,
                  color: statusDetails.color,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order #${order.id}',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _formatMoney(order.total),
                          style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            order.date,
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.muted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                            statusDetails.backgroundColor,
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusDetails.label,
                            style: TextStyle(
                              color: statusDetails.color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.muted,
                          size: 21,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  List<int> _visiblePages() {
    if (totalPages <= 5) {
      return List.generate(
        totalPages,
            (index) => index,
      );
    }

    if (currentPage <= 2) {
      return [0, 1, 2, 3, 4];
    }

    if (currentPage >= totalPages - 3) {
      return [
        totalPages - 5,
        totalPages - 4,
        totalPages - 3,
        totalPages - 2,
        totalPages - 1,
      ];
    }

    return [
      currentPage - 2,
      currentPage - 1,
      currentPage,
      currentPage + 1,
      currentPage + 2,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _visiblePages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PaginationArrow(
          icon: Icons.chevron_left_rounded,
          enabled: currentPage > 0,
          tooltip: 'Previous page',
          onPressed: () {
            onPageSelected(currentPage - 1);
          },
        ),

        const SizedBox(width: 8),

        Flexible(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 7,
            runSpacing: 7,
            children: pages.map((page) {
              final isSelected = page == currentPage;

              return Material(
                color: isSelected
                    ? AppColors.green
                    : AppColors.softGreen,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    onPageSelected(page);
                  },
                  child: SizedBox(
                    width: 38,
                    height: 38,
                    child: Center(
                      child: Text(
                        '${page + 1}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.darkGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(width: 8),

        _PaginationArrow(
          icon: Icons.chevron_right_rounded,
          enabled: currentPage < totalPages - 1,
          tooltip: 'Next page',
          onPressed: () {
            onPageSelected(currentPage + 1);
          },
        ),
      ],
    );
  }
}

class _PaginationArrow extends StatelessWidget {
  const _PaginationArrow({
    required this.icon,
    required this.enabled,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        minimumSize: const Size(40, 40),
        backgroundColor: enabled
            ? AppColors.softGreen
            : AppColors.border.withValues(
          alpha: 0.4,
        ),
        foregroundColor: enabled
            ? AppColors.darkGreen
            : AppColors.muted.withValues(
          alpha: 0.5,
        ),
      ),
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 44,
      ),
      decoration: BoxDecoration(
        color: AppColors.softGreen.withValues(
          alpha: 0.45,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 60,
            color: AppColors.muted,
          ),
          SizedBox(height: 14),
          Text(
            'No orders found',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Orders matching this filter will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsSheet extends StatelessWidget {
  const _OrderDetailsSheet({
    required this.order,
  });

  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    final details = order.status.details;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          8,
          24,
          28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Order details',
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 22),

            _DetailsRow(
              label: 'Order number',
              value: '#${order.id}',
            ),
            _DetailsRow(
              label: 'Order date',
              value: order.date,
            ),
            _DetailsRow(
              label: 'Items',
              value: '${order.itemCount}',
            ),
            _DetailsRow(
              label: 'Total',
              value: _formatMoney(order.total),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Text(
                  'Status',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: details.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    details.label,
                    style: TextStyle(
                      color: details.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum OrderFilter {
  all,
  active,
  delivered,
  cancelled,
}

extension OrderFilterExtension on OrderFilter {
  String get label {
    switch (this) {
      case OrderFilter.all:
        return 'All';

      case OrderFilter.active:
        return 'Active';

      case OrderFilter.delivered:
        return 'Delivered';

      case OrderFilter.cancelled:
        return 'Cancelled';
    }
  }
}

enum OrderStatus {
  processing,
  onTheWay,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  OrderStatusDetails get details {
    switch (this) {
      case OrderStatus.processing:
        return const OrderStatusDetails(
          label: 'Processing',
          icon: Icons.inventory_2_outlined,
          color: Color(0xFFB26A00),
          backgroundColor: Color(0xFFFFF1D7),
        );

      case OrderStatus.onTheWay:
        return const OrderStatusDetails(
          label: 'On the way',
          icon: Icons.local_shipping_outlined,
          color: AppColors.green,
          backgroundColor: AppColors.softGreen,
        );

      case OrderStatus.delivered:
        return const OrderStatusDetails(
          label: 'Delivered',
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.green,
          backgroundColor: AppColors.softGreen,
        );

      case OrderStatus.cancelled:
        return const OrderStatusDetails(
          label: 'Cancelled',
          icon: Icons.cancel_outlined,
          color: AppColors.red,
          backgroundColor: Color(0xFFFFE9E7),
        );
    }
  }
}

class OrderStatusDetails {
  const OrderStatusDetails({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
}

class OrderItem {
  const OrderItem({
    required this.id,
    required this.date,
    required this.itemCount,
    required this.total,
    required this.status,
    this.progress = 1,
  });

  final String id;
  final String date;
  final int itemCount;
  final double total;
  final OrderStatus status;
  final double progress;
}

String _formatMoney(double amount) {
  return 'GHS ${amount.toStringAsFixed(2)}';
}