
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Information App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  int currentPage = 0;
  bool isVerified = false;

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController sectionController =
      TextEditingController();

  final TextEditingController courseController =
      TextEditingController();

  final List<TextEditingController> subjectControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final List<TextEditingController> timeControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    nameController.dispose();
    sectionController.dispose();
    courseController.dispose();

    for (final controller in subjectControllers) {
      controller.dispose();
    }

    for (final controller in timeControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void nextPage() {
    if (currentPage == 0) {
      if (nameController.text.trim().isEmpty ||
          sectionController.text.trim().isEmpty ||
          courseController.text.trim().isEmpty) {
        showMessage('Please complete all student information.');
        return;
      }
    }

    if (currentPage == 1) {
      for (int i = 0; i < 3; i++) {
        if (subjectControllers[i].text.trim().isEmpty ||
            timeControllers[i].text.trim().isEmpty) {
          showMessage('Please complete all 3 subjects and times.');
          return;
        }
      }
    }

    setState(() {
      currentPage++;
      isVerified = false;
    });
  }

  void previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void confirmInformation() {
    setState(() {
      isVerified = true;
    });

    showMessage('Student information verified successfully!');
  }

  Widget buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon == null ? null : Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildStudentPage() {
    return ListView(
      children: [
        const Icon(
          Icons.person,
          size: 70,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        const Text(
          'Student Information',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please enter your personal information.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        buildTextField(
          label: 'Full Name',
          hint: 'Enter your full name',
          controller: nameController,
          icon: Icons.person_outline,
        ),

        buildTextField(
          label: 'Section',
          hint: 'Enter your section',
          controller: sectionController,
          icon: Icons.groups_outlined,
        ),

        buildTextField(
          label: 'Course',
          hint: 'Example: BSIT',
          controller: courseController,
          icon: Icons.school_outlined,
        ),

        const SizedBox(height: 10),
        buildNextButton(),
      ],
    );
  }

  Widget buildSubjectPage() {
    return ListView(
      children: [
        const Icon(
          Icons.menu_book,
          size: 70,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        const Text(
          'Subjects and Schedule',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter 3 subjects and their class times.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        for (int i = 0; i < 3; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subject ${i + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: subjectControllers[i],
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                      hintText: 'Example: Programming',
                      prefixIcon: Icon(Icons.book_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: timeControllers[i],
                    decoration: const InputDecoration(
                      labelText: 'Class Time',
                      hintText: 'Example: 8:00 AM - 10:00 AM',
                      prefixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

        buildNextButton(),
        const SizedBox(height: 8),
        buildBackButton(),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget buildVerificationPage() {
    return ListView(
      children: [
        Icon(
          isVerified ? Icons.verified : Icons.fact_check_outlined,
          size: 75,
          color: isVerified ? Colors.green : Colors.blue,
        ),
        const SizedBox(height: 12),

        Text(
          isVerified ? 'Verified!' : 'Verify Information',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          isVerified
              ? 'Your information has been confirmed.'
              : 'Please review your information before confirming.',
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Student Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),

                buildInfoRow('Full Name', nameController.text),
                buildInfoRow('Section', sectionController.text),
                buildInfoRow('Course', courseController.text),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subjects and Times',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 24),

                for (int i = 0; i < 3; i++) ...[
                  Text(
                    'Subject ${i + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  buildInfoRow(
                    'Subject',
                    subjectControllers[i].text,
                  ),
                  buildInfoRow(
                    'Time',
                    timeControllers[i].text,
                  ),
                  if (i < 2) const Divider(),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isVerified ? null : confirmInformation,
            icon: const Icon(Icons.verified),
            label: Text(
              isVerified ? 'Information Confirmed' : 'Confirm Information',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 8),
        buildBackButton(),

        const SizedBox(height: 8),

        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              currentPage = 0;
              isVerified = false;
              nameController.clear();
              sectionController.clear();
              courseController.clear();

              for (final controller in subjectControllers) {
                controller.clear();
              }

              for (final controller in timeControllers) {
                controller.clear();
              }
            });
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Start Over'),
        ),
      ],
    );
  }

  Widget buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: nextPage,
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Next'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget buildBackButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: previousPage,
        icon: const Icon(Icons.arrow_back),
        label: const Text('Back'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> pageTitles = [
      'Student Details',
      'Subject Schedule',
      'Verification',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[currentPage]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: currentPage == 0
            ? buildStudentPage()
            : currentPage == 1
                ? buildSubjectPage()
                : buildVerificationPage(),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          children: [
            for (int i = 0; i < 3; i++)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentPage >= i
                        ? Colors.blue
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
