import 'package:flutter/material.dart';
import "ProjectCard.dart";
import "type.dart";
import "Section.dart";

void main() {
  runApp(const SalemKodeCVApp());
}

class SalemKodeCVApp extends StatelessWidget {
  const SalemKodeCVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salem Kode • CV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EA5E9)),
        fontFamily: 'Roboto',
      ),
      home: const CVScreen(),
    );
  }
}

class CVScreen extends StatelessWidget {
  const CVScreen({super.key});

  static const String name = 'Salem Kode';
  static const String title = 'Full-Stack Typescript Developer';
  static const String avatarUrl =
      'https://avatars.githubusercontent.com/u/58360393?v=4';
  static const String tagline = 'Creating digital magic';

  static const String about =
      'مطوّر ويب متخصّص في الواجهات والخلفيات، عاشق لـ TypeScript وكل ما هو type-safe. '
      'عمل/ساهم في بيئة Flipstarter، ويطوّر Faststarter كمفهوم تمويل جماعي بالعقود الذكية.';

  static const List<String> skills = [
    'TypeScript',
    'JavaScript',
    'React',
    'Next.js',
    'Vue',
    'Nuxt',
    'Vite',
    'Node.js',
    'CSS',
  ];

  // مشاريع مذكورة في الموقع
  static final List<Project> projects = [
    Project(
      name: 'Snapcraft Downloader',
      description: 'واجهة GUI مبسطة لتحميل حزم Snapcraft (React + Bootstrap).',
      url: Uri.parse('https://snap.salemkode.com'),
      tags: const ['React', 'Bootstrap'],
    ),
    Project(
      name: 'Bitcoin Cash Explorer',
      description: 'مستكشف لسلسلة Bitcoin Cash مع دعم للـ Tokens (Vue + TS).',
      url: Uri.parse('https://explorer.salemkode.com'),
      tags: const ['Vue', 'TypeScript', 'BCH'],
    ),
    Project(
      name: 'SLP Icon Uploader',
      description:
          'أداة رفع/تهيئة أيقونات التوكن إلى GitHub (Node + GitHub API).',
      url: Uri.parse('https://slp-icons.salemkode.com'),
      tags: const ['Node.js', 'GitHub API'],
    ),
    Project(
      name: 'Faststarter',
      description:
          'مشروع تمويل جماعي يعتمد العقود الذكية (Vue + Solidity) ويقارن مع Flipstarter.',
      url: Uri.parse('https://faststarter.salemkode.com'),
      tags: const ['Vue', 'Solidity', 'Web3'],
    ),
  ];

  // الخبرة العملية → محوّلة لبنود مشاريع
  static const List<String> experienceAsProjects = [
    'المساهمة/العمل ضمن منظومة Flipstarter (تحسينات وميزات).',
    'بناء Faststarter كمنصّة تمويل عقود ذكية (مقارنة ب Flipstarter).',
  ];

  // التعليم
  static const String education = 'بكالوريوس – Seiyun University (جامعة سيئون)';

  // روابط اجتماعية (أزرار/أيقونات)
  static final List<SocialLink> links = [
    SocialLink(
      icon: Icons.language,
      label: 'Website',
      url: Uri.parse('https://salemkode.com'),
    ),
    SocialLink(
      icon: Icons.alternate_email,
      label: 'X (Twitter)',
      url: Uri.parse('https://x.com/salemkode'),
    ),
    SocialLink(
      icon: Icons.code,
      label: 'GitHub',
      url: Uri.parse('https://github.com/salemkode'),
    ),
    SocialLink(
      icon: Icons.send,
      label: 'Telegram',
      url: Uri.parse('https://t.me/salemkode'),
    ),
    SocialLink(
      icon: Icons.workspaces_outline,
      label: 'GitLab',
      url: Uri.parse('https://gitlab.com/salemkode'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('السيرة الذاتية'), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                name,
                                softWrap: true,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: cs.primary),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              avatarUrl,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // About
              Section(
                title: 'البيانات / نبذة',
                child: Text(
                  about,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 16),

              // Skills
              Section(
                title: 'المهارات',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills
                      .map((s) => Chip(label: Text(s)))
                      .toList(growable: false),
                ),
              ),

              const SizedBox(height: 16),

              // Projects (as experience)
              Section(
                title: 'المشاريع',
                isCard: false,
                child: Column(
                  children: [...projects.map((p) => ProjectCard(project: p))],
                ),
              ),

              const SizedBox(height: 16),

              // Experience converted to projects bullets
              Section(
                title: 'الخبرات العملية (كمشاريع)',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: experienceAsProjects
                      .map(
                        (e) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  '),
                            Expanded(child: Text(e)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Education
              Section(title: 'الخبرات العلمية', child: Text(education)),

              const SizedBox(height: 16),

              // Links
              Section(
                title: 'روابط',
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: links
                      .map(
                        (l) => ElevatedButton.icon(
                          onPressed: () => print(l.url),
                          icon: Icon(l.icon),
                          label: Text(l.label),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
