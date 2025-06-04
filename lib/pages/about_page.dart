import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // has a pop button and info
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Eldritch 办公自动化工单系统',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Eldritch 是一个采用 Flutter 开发开源的办公自动化工单系统，旨在帮助企业和组织更高效地管理工作流程和任务。',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                '版本: 1.0.0',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '作者: Stanley-233 Allin',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}