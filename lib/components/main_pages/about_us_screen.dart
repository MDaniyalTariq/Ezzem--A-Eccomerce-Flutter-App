import 'package:ezzem/components/static_components/Faq.dart';
import 'package:flutter/material.dart';

class Testimonial {
  final String imagePath;
  final String date;
  final String name;
  final String text;

  Testimonial({
    required this.imagePath,
    required this.date,
    required this.name,
    required this.text,
  });
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam viverra mi ut ligula dictum, eu condimentum justo molestie. Pellentesque nec dui vitae elit finibus ultricies id non velit. Fusce sit amet odio a nulla condimentum accumsan. Vivamus tempus nisi quis massa semper luctus. Nunc sit amet velit sit amet odio sollicitudin eleifend. Cras vestibulum justo in libero interdum, in congue turpis convallis. Nullam nec eros justo. Ut ac fermentum justo. Vivamus fringilla interdum turpis, non ullamcorper orci placerat vel. Fusce gravida, lectus vel sagittis tristique, dui lectus elementum nunc, in luctus felis sem vitae tellus. Proin in interdum urna. Morbi suscipit justo ut mauris commodo eleifend.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20.0),
            Image.asset(
              'assests/logo.png',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20.0),
            _buildSustainabilitySection(),
            SizedBox(height: 20.0),
            _buildMissionAndVisionSection(),
            SizedBox(height: 20.0),
            _buildSectionTitle("Company History"),
            SizedBox(height: 10.0),
            _buildCompanyHistoryContent(),
            SizedBox(height: 20.0),
            _buildSectionTitle("Meet Our Team"),
            SizedBox(height: 10.0),
            Text(
              'Our team is comprised of dedicated professionals with expertise in various fields. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam viverra mi ut ligula dictum, eu condimentum justo molestie.',
              textAlign: TextAlign.justify,
            ),
            TeamMembersList(),
            SizedBox(height: 20.0),
            _buildSectionTitle('Social Responsibility'),
            SizedBox(height: 10.0),
            _buildSocialResponsibilityContent(),
            SizedBox(height: 20.0),
            _buildSectionTitle('Customer Testimonials'),
            SizedBox(height: 10.0),
            _buildTestimonialsDescription(),
            SizedBox(height: 20.0),
            _buildTestimonialsSlider(),
            SizedBox(height: 20.0),
            _buildSectionTitle('FAQs'),
            SizedBox(height: 10.0),
            _buildFAQContent(context),
            SizedBox(height: 20.0),
           
            _buildsideheading("Contact Us"),
            _buildContactUsSection(),
            SizedBox(height: 10.0),
            SizedBox(height: 20.0),
            _buildSectionTitle("Contact Form"),
            SizedBox(height: 10.0),
            ContactForm(),
          ],
        ),
      ),
    );
  }
Widget _buildContactUsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.email),
          title: Text('Email'),
          subtitle: Text('info@m.daniyaltariq.com'),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('Phone'),
          subtitle: Text('+92 301 9659063'),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Address'),
          subtitle: Text('New Area Main Cantt, Sialkot, Pakistan'),
          onTap: () {
          },
        ),
      ],
    );
  }
}
  Widget _buildFAQContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore our frequently asked questions to learn more about our company, products, and services. ',
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20.0),
        _buildFAQList(context),
        SizedBox(height: 20.0),
        _buildFAQLink(context),
      ],
    );
  }

  Widget _buildFAQList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFAQItem(
          context,
          'What are your company\'s core values?',
          'Our core values include integrity, innovation, and customer satisfaction.',
        ),
        _buildFAQItem(
          context,
          'What products do you offer?',
          'We offer a wide range of products including electronics, home appliances, and more.',
        ),
        _buildFAQItem(
          context,
          'How can I contact customer support?',
          'You can contact our customer support team via phone, email, or live chat.',
        ),
      ],
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            answer,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildFAQLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FAQPage()),
        );
      },
      child: Center(
        child: Text(
          'Visit FAQ Page',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }


Widget _buildTestimonialsSlider() {
  List<Testimonial> testimonials = [
    Testimonial(
      imagePath: 'assests/image1.jpg',
      date: 'March 10, 2023',
      name: 'M.Daniyal Tariq',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam viverra mi ut ligula dictum, eu condimentum justo molestie.',
    ),
    Testimonial(
      imagePath: 'assests/image2.jpg',
      date: 'April 15, 2023',
      name: 'M.Suleman',
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam viverra mi ut ligula dictum, eu condimentum justo molestie.',
    ),
  ];

  return Container(
    height: 250,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: testimonials.length,
      itemBuilder: (context, index) {
        return _buildTestimonialCard(testimonials[index]);
      },
    ),
  );
}

Widget _buildTestimonialCard(Testimonial testimonial) {
  return Container(
    width: 300.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.grey[200],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Center(
            child: ClipOval(
              child: Image.asset(
                testimonial.imagePath,
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          testimonial.date,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Flexible(
          child: Text(
            testimonial.text,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          '- ${testimonial.name}',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );


}

Widget _buildTestimonialsDescription() {
  return Text(
    'Here are some testimonials from our satisfied customers..',
    textAlign: TextAlign.justify,
  );
}

Widget _buildSocialResponsibilityContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'We actively engage in social responsibility initiatives, including community service projects and environmental conservation efforts. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam viverra mi ut ligula dictum, eu condimentum justo molestie.',
        textAlign: TextAlign.justify,
      ),
      SizedBox(height: 20.0),
      _buildSocialResponsibilityProjects(),
    ],
  );
}

Widget _buildSocialResponsibilityProjects() {
  List<String> projects = [
    'Community Cleanup Drive',
    'Educational Scholarship Program',
    'Tree Planting Campaign',
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Recent Projects:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10.0),
      Column(
        children: projects.map((project) {
          return _buildProjectItem(project);
        }).toList(),
      ),
    ],
  );
}

Widget _buildProjectItem(String projectName) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Text(
            projectName,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _buildCompanyHistoryContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Founded in 20XX, our company has grown from a small startup to a leading player in the industry. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam viverra mi ut ligula dictum, eu condimentum justo molestie. Pellentesque nec dui vitae elit finibus ultricies id non velit.',
        textAlign: TextAlign.justify,
      ),
      SizedBox(height: 20.0),
      _buildTimeline(),
    ],
  );
}

Widget _buildTimeline() {
  return Container(
    height: 200.0,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildTimelineItem(index + 1);
      },
    ),
  );
}

Widget _buildTimelineItem(int index) {
  return Container(
    width: 150.0,
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Year $index',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          'Event $index',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5.0),
      ],
    ),
  );
}

Widget _buildMissionAndVisionSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Mission and Vision',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10.0),
      Text(
        'Our mission is to provide high-quality products/services while maintaining a strong commitment to sustainability and social responsibility. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam viverra mi ut ligula dictum, eu condimentum justo molestie.',
        textAlign: TextAlign.justify,
      ),
      SizedBox(height: 10.0),
      _buildMissionAndVisionPoints(),
    ],
  );
}

Widget _buildMissionAndVisionPoints() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Mission:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 5.0),
      _buildBulletPoint('Provide high-quality products/services'),
      _buildBulletPoint('Maintain commitment to sustainability'),
      _buildBulletPoint('Uphold social responsibility'),
      SizedBox(height: 10.0),
      Text(
        'Vision:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 5.0),
      _buildBulletPoint('Become a leader in our industry'),
      _buildBulletPoint('Make a positive impact on society'),
      _buildBulletPoint('Innovate for a sustainable future'),
    ],
  );
}

Widget _buildBulletPoint(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 10.0,
        child: Text(
          '\u2022',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      SizedBox(width: 5.0),
      Expanded(
        child: Text(text),
      ),
    ],
  );
}

Widget _buildSustainabilitySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Sustainability',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10.0),
      Text(
        'We are committed to sustainability and environmental responsibility.',
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 10.0),
      Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.green[100],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assests/certificate.png',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Certified Sustainable',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildsideheading(String title) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(labelText: 'Message'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
            maxLines: 3,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
             style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFF82249),
                            foregroundColor: Colors.white,
                          ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String name = _nameController.text;
                String email = _emailController.text;
                String message = _messageController.text;
                print('Name: $name, Email: $email, Message: $message');
              }
             
            },
            child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
          ),
          
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class TeamMember {
  final String name;
  final String role;
  final String contactNumber;
  final String imagePath;

  TeamMember({
    required this.name,
    required this.role,
    required this.contactNumber,
    required this.imagePath,
  });
}

class TeamMembersList extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: 'M.Daniyal Tariq',
      role: 'CEO',
      contactNumber: '+92 301 9659063',
      imagePath: 'assests/image1.jpg',
    ),
    TeamMember(
      name: 'M.Suleman',
      role: 'Marketing Manager',
      contactNumber: '+92 315 9659063',
      imagePath: 'assests/image1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: teamMembers.length,
      itemBuilder: (context, index) {
        return TeamMemberCard(teamMember: teamMembers[index]);
      },
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final TeamMember teamMember;

  TeamMemberCard({required this.teamMember});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(teamMember.imagePath),
        ),
        title: Text(teamMember.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teamMember.role),
            Text('Contact: ${teamMember.contactNumber}'),
          ],
        ),
      ),
    );
  }
}
