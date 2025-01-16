import 'package:flutter/material.dart';
import '../services/scraping_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? currentUsageKB = 0;
  int? dataLimitKB = 0;
  double usagePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data when the screen loads
  Future<void> _fetchData() async {
    String url = "https://www.digi-belgium.be/en/my-digi/overview";
    Map<String, int>? mobileUsageInKB = await ScrapingService.scrapeMobileUsageInKB(url);

    if (mobileUsageInKB != null) {
      setState(() {
        currentUsageKB = mobileUsageInKB['currentUsageKB'];
        dataLimitKB = mobileUsageInKB['dataLimitKB'];
        if (currentUsageKB != null && dataLimitKB != null) {
          usagePercentage = currentUsageKB! / dataLimitKB!; // Calculate usage percentage
        }
      });
    }
  }

  // Convert KB to MB or GB
  String formatData(int? dataKB) {
    if (dataKB == null) return '0.0 MB';
    double dataMB = dataKB / 1000;
    if (dataMB > 1000) {
      return '${(dataMB / 1000).toStringAsFixed(2)} GB';
    }
    return '${dataMB.toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Soft background color
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main usage container with rounded corners
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Title of the section
                  Text(
                    'Mobile Data Usage',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Display current usage and data limit in MB/GB
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Current Usage',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            formatData(currentUsageKB),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Column(
                        children: [
                          Text(
                            'Data Limit',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            formatData(dataLimitKB),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Display usage percentage as a circular progress indicator
                  // Circular progress indicator with grey remainder and larger size
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Grey circle background
                      SizedBox(
                        width: 75, // Increase the size of the circle
                        height: 75, // Increase the size of the circle
                        child: CircularProgressIndicator(
                          value: 1.0, // Always full circle for grey background
                          strokeWidth: 7,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[300]!),
                        ),
                      ),
                      // Colored progress circle
                      SizedBox(
                        width: 75, // Same size for both circles
                        height: 75, // Same size for both circles
                        child: CircularProgressIndicator(
                          value: usagePercentage,
                          strokeWidth: 7,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            usagePercentage >= 0.8
                                ? Colors.red
                                : usagePercentage >= 0.5
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Display usage percentage as a text
                  Text(
                    '${(usagePercentage * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: usagePercentage >= 0.8
                          ? Colors.red
                          : usagePercentage >= 0.5
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            // Display fallback message if no data is fetched
            if (currentUsageKB == 0 || dataLimitKB == 0)
              Text(
                'No data available.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
