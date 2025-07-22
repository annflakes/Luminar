import 'package:flutter/material.dart';


class EducationalContentPage extends StatelessWidget {
  final List<Map<String, dynamic>> content = [
    {
      'title1': 'What',
      'title2':'What is Color Blindness',
      'description':
          "Color blindness is a condition where individuals have difficulty distinguishing certain colors due to deficiencies in the cone cells of the eyes.\n\n"
          "It most commonly affects the perception of red and green but can also impact blue and yellow or, in rare cases, result in a complete inability to see colors.\n\n"
          "This condition is usually inherited, but it can also develop due to eye diseases, injuries, or aging. Advances in technology have led to tools like color-correcting glasses and mobile apps that help affected individuals perceive colors more accurately.",
      'image': 'assets/eye.jpg',
    },
    {
      'title1': 'Causes',
      'title2':'Different Causes of Color Blindness',
      'description': "Color blindness is often inherited and occurs due to genetic mutations affecting the photoreceptor cells in the retina. However, other causes include:",
      'subtopics': [
        {
          'subtitle': 'Aging',
          'description': "The ability to perceive colors may decline with age due to natural changes in the eye's lens and retina.",
          'image': 'assets/Vision-Problems-in-Seniors.jpg',
        },
        {
          'subtitle': 'Eye Diseases',
          'description': "Conditions like glaucoma, macular degeneration, and diabetic retinopathy can affect color vision.",
          'image': 'assets/eye_disease.jpg',
        },
        {
          'subtitle': 'Medicine and Chemicals',
          'description': "Certain drugs or toxic exposures can alter color perception, sometimes temporarily or permanently.",
          'image': 'assets/pill-bottle.jpg',
        },
        {
          'subtitle': 'Injury or Damage',
          'description': "Retinal or optic nerve damage from accidents, surgery, or trauma can impair color differentiation.",
          'image': 'assets/eye-injury.jpg',

        }
      ]
    },
    {
      'title1': 'Types',
      'title2':'Different Types of Color Blindness',
      'description': "There are different types of color blindness based on which cone cells are affected:",
      'subtopics': [
        {
          'subtitle': 'Red-Green Color Blindness',
          'description': "The most common type, making red and green appear similar.",
          'image': 'assets/protonopia.jpg',
        },
        {
          'subtitle': 'Blue-Yellow Color Blindness',
          'description': "Less common, affecting blue and yellow distinction.",
          'image': 'assets/tritanopia.jpg',
        },
        {
          'subtitle': 'Complete Color Blindness',
          'description': "A rare condition where no colors can be perceived.",
          'image': 'assets/total.png',
        },
      ]
    },
    {
      'title1': 'Living',
      'title2':'Living with Color Blindness',
      'description': "People with color blindness can adapt using different methods:",
      'subtopics': [
        {
          'subtitle': 'Special Glasses & Contact Lenses',
          'description': "Designed to enhance color perception by filtering specific wavelengths of light.",
          'image': 'assets/glasses.jpg',
        },
        
        {
          'subtitle': 'Lifestyle Adaptations',
          'description': "Learning to rely on patterns, labels, and context instead of colors.",
          'image': 'assets/pattern.jpg',
        },
      ]
    
    
      },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: content.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Educational Content'),
          bottom: TabBar(
            isScrollable: true,
            tabs: content.map((item) => Tab(text: item['title1'])).toList(),
          ),
        ),
        body: TabBarView(
          children: content.map((item) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item['title2'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),

                    // Image FIRST in "What" Tab
                    if (item['title1'] == 'What' && item.containsKey('image'))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item['image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                '❌ Image not found!',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    if (item['title1'] == 'What') const SizedBox(height: 10),

                    // Description
                    Text(
                      item['description'],
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),

                    // Subtopics (if available)
                    if (item.containsKey('subtopics'))
                      ...item['subtopics'].map<Widget>((subtopic) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // Subtitle
                            Text(
                              subtopic['subtitle'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),

                            // Subtopic Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                subtopic['image'],
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text(
                                      '❌ Image not found!',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Subtopic Description
                            Text(
                              subtopic['description'],
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        );
                      }).toList()
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
