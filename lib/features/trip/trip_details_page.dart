import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../shared/data/trips_data.dart';
import '../../shared/models/trip.dart';

class TripDetailsPage extends ConsumerStatefulWidget {
  final String id;

  const TripDetailsPage({super.key, required this.id});

  @override
  ConsumerState<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends ConsumerState<TripDetailsPage> {
  String _activeTab = 'itinerary';
  int? _expandedDay = 1;

  @override
  Widget build(BuildContext context) {
    final trip = mockTrips.firstWhere(
      (t) => t.id == widget.id,
      orElse: () => throw Exception('Trip not found'),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final budgetProgress = trip.budget.spent / trip.budget.total;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Image with Back button
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(LucideIcons.arrowLeft, color: Colors.black, size: 20),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                trip.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        trip.destination,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${DateFormat('MMM d, yyyy').format(trip.startDate)} - ${DateFormat('MMM d, yyyy').format(trip.endDate)}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Trip Summary
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trip Summary',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          trip.summary,
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  // Travel Notes
                  _CardContainer(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(LucideIcons.stickyNote, size: 20, color: Color(0xFF20878E)),
                                SizedBox(width: 10),
                                Text(
                                  'Travel Notes',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(LucideIcons.plus, size: 20),
                              style: IconButton.styleFrom(
                                backgroundColor: primaryColor.withValues(alpha: 0.1),
                                foregroundColor: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...trip.notes.map((note) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('•', style: TextStyle(color: primaryColor, fontSize: 18)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  note,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  // Photo Memories
                  _CardContainer(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(LucideIcons.camera, size: 20, color: Color(0xFF20878E)),
                                SizedBox(width: 10),
                                Text(
                                  'Photo Memories',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(LucideIcons.plus, size: 20),
                              style: IconButton.styleFrom(
                                backgroundColor: primaryColor.withValues(alpha: 0.1),
                                foregroundColor: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (trip.photos.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Icon(LucideIcons.camera, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text('No photos yet. Capture your memories!', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: trip.photos.length,
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(trip.photos[index], fit: BoxFit.cover),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _TabButton(
                          label: 'Itinerary',
                          isActive: _activeTab == 'itinerary',
                          onTap: () => setState(() => _activeTab = 'itinerary'),
                        ),
                        _TabButton(
                          label: 'Route',
                          isActive: _activeTab == 'route',
                          onTap: () => setState(() => _activeTab = 'route'),
                        ),
                        _TabButton(
                          label: 'Transport',
                          isActive: _activeTab == 'transport',
                          onTap: () => setState(() => _activeTab = 'transport'),
                        ),
                        _TabButton(
                          label: 'Budget',
                          isActive: _activeTab == 'budget',
                          onTap: () => setState(() => _activeTab = 'budget'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tab Content
                  if (_activeTab == 'itinerary')
                    ...trip.itinerary.map((day) => _ItineraryDayCard(
                      day: day,
                      isExpanded: _expandedDay == day.day,
                      onTap: () => setState(() => _expandedDay = _expandedDay == day.day ? null : day.day),
                    )),
                  
                  if (_activeTab == 'route')
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.navigation, size: 20, color: Color(0xFF20878E)),
                              SizedBox(width: 10),
                              Text('Route Optimization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.mapPin, size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Interactive Map of Davao Region', style: TextStyle(color: Colors.grey)),
                                  Text('Optimized route for all destinations', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Distance', style: TextStyle(color: Colors.grey)),
                              Text('~45 km', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Estimated Travel Time', style: TextStyle(color: Colors.grey)),
                              Text('2.5 hours', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),

                  if (_activeTab == 'transport')
                    ...trip.transport.map((t) => _TransportCard(transport: t)),

                  if (_activeTab == 'budget')
                    _CardContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(LucideIcons.wallet, size: 20, color: Color(0xFF20878E)),
                              SizedBox(width: 10),
                              Text('Personal Budget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _BudgetRow(label: 'Total Budget', value: trip.budget.total),
                          _BudgetRow(label: 'Spent', value: trip.budget.spent, color: primaryColor),
                          _BudgetRow(label: 'Remaining', value: trip.budget.total - trip.budget.spent),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: budgetProgress,
                              minHeight: 12,
                              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              '${(budgetProgress * 100).toStringAsFixed(0)}% of budget used',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text('Expense Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ...trip.budget.categories.map((cat) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(cat.name, style: const TextStyle(fontSize: 14)),
                                    Text('₱${NumberFormat('#,###').format(cat.amount)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: cat.amount / trip.budget.total,
                                    minHeight: 8,
                                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _parseColor(cat.color),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Daily Spending Limit', style: TextStyle(color: Colors.grey)),
                                Text('₱${NumberFormat('#,###').format(trip.budget.daily)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorStr) {
    if (colorStr.startsWith('#')) {
      return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
    }
    return Colors.teal;
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : (isDark ? Colors.grey[900] : Colors.white),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!isActive) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ItineraryDayCard extends StatelessWidget {
  final ItineraryDay day;
  final bool isExpanded;
  final VoidCallback onTap;

  const _ItineraryDayCard({required this.day, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Day ${day.day}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(day.title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  Icon(isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: day.activities.map((act) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(act.time, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(act.activity, style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(LucideIcons.mapPin, size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(act.location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  final TransportInfo transport;
  const _TransportCard({required this.transport});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(LucideIcons.bus, color: Color(0xFF20878E), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transport.mode, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${transport.from} → ${transport.to}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fare', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(transport.fare, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Duration', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(transport.duration, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final String label;
  final double value;
  final Color? color;

  const _BudgetRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            '₱${NumberFormat('#,###').format(value)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
