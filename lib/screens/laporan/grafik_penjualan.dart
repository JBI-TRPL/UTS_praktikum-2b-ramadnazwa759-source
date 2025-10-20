import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailySalesChart extends StatelessWidget {
  final List<Map<String, dynamic>> dailyRevenueMaps;

  const DailySalesChart({
    super.key,
    required this.dailyRevenueMaps,
  });

  List<BarChartGroupData> _getBarGroups() {
    final List<BarChartGroupData> barGroups = [];
    
    for (int i = 0; i < dailyRevenueMaps.length; i++) {
      final map = dailyRevenueMaps[i];
      final sales = (map['daily_revenue'] as num).toDouble(); 
      
      barGroups.add(
        BarChartGroupData(
          x: i, 
          barRods: [
            BarChartRodData(
              toY: sales, 
              color: Colors.blue.shade400, 
              width: 15,
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    if (dailyRevenueMaps.isEmpty) {
      return const Center(child: Text("Tidak ada data penjualan untuk digambarkan."));
    }

    return SizedBox(
      height: 250, 
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
        child: BarChart(
          BarChartData(
            // Data Grafik
            barGroups: _getBarGroups(),
            alignment: BarChartAlignment.spaceAround,
            
            titlesData: const FlTitlesData(
              show: true,
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), 
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30)
              ),
            ),
            
            
            gridData: const FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 10000), // Tampilkan garis horizontal saja
            borderData: FlBorderData(show: false),
            
            
            barTouchData: BarTouchData(enabled: false), 
          ),
        ),
      ),
    );
  }
}