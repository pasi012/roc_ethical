import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../provider/dark_theme_provider.dart';
import '../services/global_methods.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;

  String? ageGroup;
  String? gender;
  String? city;
  String? country;
  String? occupation;
  String? knowledgeOnSustainableFashion;
  String? environmentalAwareness;
  String? ecoFriendlyActions;
  String? importanceOfSustainability;
  String? useOfEcoFriendlyMaterials;
  String? ethicalProductionAndLaborPractices;
  String? reductionOfCarbonFootprint;
  String? minimalWaterUsage;
  String? transparencyInSupplyChain;
  String? supportingLocalAndArtisanalBrands;
  String? willingnessToPayMore;
  String? influenceOfSustainabilityLabels;
  String? sustainableMaterialPreference;
  String? knowledgeOfSustainableBrands;
  String? fashionLifestyleAlignment;
  String? interestInVisualSearch;

  Future<void> saveAnswers() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection('questionnaires').doc(user?.uid).set({
        'answers': {
          'Age Group': ageGroup,
          'Gender': gender,
          'City': city,
          'Country': country,
          'Occupation': occupation,
          'Knowledge on Sustainable Fashion': knowledgeOnSustainableFashion,
          'Environmental Awareness': environmentalAwareness,
          'Eco-friendly actions': ecoFriendlyActions,
          'Importance of Sustainability': importanceOfSustainability,
          'Sustainability Factors: Use of eco-friendly materials': useOfEcoFriendlyMaterials,
          'Sustainability Factors: Ethical production and labor practices': ethicalProductionAndLaborPractices,
          'Sustainability Factors: Reduction of carbon footprint': reductionOfCarbonFootprint,
          'Sustainability Factors: Minimal water usage': minimalWaterUsage,
          'Sustainability Factors: Transparency in the supply chain': transparencyInSupplyChain,
          'Sustainability Factors: Supporting local and artisanal brands': supportingLocalAndArtisanalBrands,
          'Willingness to pay more': willingnessToPayMore,
          'Influence of Sustainability Labels': influenceOfSustainabilityLabels,
          'Sustainable Material preference': sustainableMaterialPreference,
          'Knowledge of Sustainable Brands': knowledgeOfSustainableBrands,
          'Fashion-Lifestyle Alignment': fashionLifestyleAlignment,
          'Interest in Visual Search': interestInVisualSearch,
        },
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Answers saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    bool _isDark = themeState.getDarkTheme;

    return Scaffold(
      backgroundColor: _isDark ? Theme.of(context).cardColor : Colors.white,
      appBar: AppBar(
        title: Text('Sustainable Fashion Survey', style: TextStyle(color: color),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(child: Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Age Group',
                  border: OutlineInputBorder(),
                ),
                value: ageGroup,
                onChanged: (String? newValue) {
                  setState(() {
                    ageGroup = newValue;
                  });
                },
                items: ['18-24', '25-34', '35-44', '45-54', '55+']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                value: gender,
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue;
                  });
                },
                items: ['Male', 'Female', 'Non-Binary']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                value: city,
                onChanged: (String? newValue) {
                  setState(() {
                    city = newValue;
                  });
                },
                items: ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                ),
                value: country,
                onChanged: (String? newValue) {
                  setState(() {
                    country = newValue;
                  });
                },
                items: ['USA', 'Canada', 'UK', 'Australia', 'India']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
                value: occupation,
                onChanged: (String? newValue) {
                  setState(() {
                    occupation = newValue;
                  });
                },
                items: ['Student', 'Professional', 'Self-Employed', 'Unemployed', 'Retired']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Center(child: Text('Knowledge and Awareness', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color))),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Knowledge on Sustainable Fashion',
                  border: OutlineInputBorder(),
                ),
                value: knowledgeOnSustainableFashion,
                onChanged: (String? newValue) {
                  setState(() {
                    knowledgeOnSustainableFashion = newValue;
                  });
                },
                items: ['None', 'Basic', 'Intermediate', 'Advanced']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Environmental Awareness',
                  border: OutlineInputBorder(),
                ),
                value: environmentalAwareness,
                onChanged: (String? newValue) {
                  setState(() {
                    environmentalAwareness = newValue;
                  });
                },
                items: ['Low', 'Moderate', 'High', 'Very High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Eco-friendly actions',
                  border: OutlineInputBorder(),
                ),
                value: ecoFriendlyActions,
                onChanged: (String? newValue) {
                  setState(() {
                    ecoFriendlyActions = newValue;
                  });
                },
                items: ['Never', 'Rarely', 'Sometimes', 'Often', 'Always']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Importance of Sustainability',
                  border: OutlineInputBorder(),
                ),
                value: importanceOfSustainability,
                onChanged: (String? newValue) {
                  setState(() {
                    importanceOfSustainability = newValue;
                  });
                },
                items: ['Not Important', 'Slightly Important', 'Moderately Important', 'Very Important', 'Extremely Important']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Use of eco-friendly materials',
                  border: OutlineInputBorder(),
                ),
                value: useOfEcoFriendlyMaterials,
                onChanged: (String? newValue) {
                  setState(() {
                    useOfEcoFriendlyMaterials = newValue;
                  });
                },
                items: ['Not Important', 'Slightly Important', 'Moderately Important', 'Very Important', 'Extremely Important']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Ethical production and labor practices',
                  border: OutlineInputBorder(),
                ),
                value: ethicalProductionAndLaborPractices,
                onChanged: (String? newValue) {
                  setState(() {
                    ethicalProductionAndLaborPractices = newValue;
                  });
                },
                items: ['Not Important', 'Slightly Important', 'Moderately Important', 'Very Important', 'Extremely Important']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Reduction of carbon footprint',
                  border: OutlineInputBorder(),
                ),
                value: reductionOfCarbonFootprint,
                onChanged: (String? newValue) {
                  setState(() {
                    reductionOfCarbonFootprint = newValue;
                  });
                },
                items: ['Not Important', 'Slightly Important', 'Moderately Important', 'Very Important', 'Extremely Important']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Minimal water usage',
                  border: OutlineInputBorder(),
                ),
                value: minimalWaterUsage,
                onChanged: (String? newValue) {
                  setState(() {
                    minimalWaterUsage = newValue;
                  });
                },
                items: ['Not Important', 'Slightly Important', 'Moderately Important', 'Very Important', 'Extremely Important']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Transparency in the supply chain',
                  border: OutlineInputBorder(),
                ),
                value: transparencyInSupplyChain,
                onChanged: (String? newValue) {
                  setState(() {
                    transparencyInSupplyChain = newValue;
                  });
                },
                items: ['Not Important', 'Slightly Important', 'Moderately Important', 'Very Important', 'Extremely Important']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Supporting local and artisanal brands',
                  border: OutlineInputBorder(),
                ),
                value: supportingLocalAndArtisanalBrands,
                onChanged: (String? newValue) {
                  setState(() {
                    supportingLocalAndArtisanalBrands = newValue;
                  });
                },
                items: ['Not Important', 'Slightly Important', 'Moderately Important', 'Very Important', 'Extremely Important']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Willingness to pay more',
                  border: OutlineInputBorder(),
                ),
                value: willingnessToPayMore,
                onChanged: (String? newValue) {
                  setState(() {
                    willingnessToPayMore = newValue;
                  });
                },
                items: ['Not Willing', 'Slightly Willing', 'Moderately Willing', 'Very Willing', 'Extremely Willing']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Influence of Sustainability Labels',
                  border: OutlineInputBorder(),
                ),
                value: influenceOfSustainabilityLabels,
                onChanged: (String? newValue) {
                  setState(() {
                    influenceOfSustainabilityLabels = newValue;
                  });
                },
                items: ['Not Influential', 'Slightly Influential', 'Moderately Influential', 'Very Influential', 'Extremely Influential']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sustainable Material preference',
                  border: OutlineInputBorder(),
                ),
                value: sustainableMaterialPreference,
                onChanged: (String? newValue) {
                  setState(() {
                    sustainableMaterialPreference = newValue;
                  });
                },
                items: ['None', 'Low', 'Medium', 'High', 'Very High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Knowledge of Sustainable Brands',
                  border: OutlineInputBorder(),
                ),
                value: knowledgeOfSustainableBrands,
                onChanged: (String? newValue) {
                  setState(() {
                    knowledgeOfSustainableBrands = newValue;
                  });
                },
                items: ['None', 'Basic', 'Intermediate', 'Advanced']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Fashion-Lifestyle Alignment',
                  border: OutlineInputBorder(),
                ),
                value: fashionLifestyleAlignment,
                onChanged: (String? newValue) {
                  setState(() {
                    fashionLifestyleAlignment = newValue;
                  });
                },
                items: ['None', 'Low', 'Medium', 'High', 'Very High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Interest in Visual Search',
                  border: OutlineInputBorder(),
                ),
                value: interestInVisualSearch,
                onChanged: (String? newValue) {
                  setState(() {
                    interestInVisualSearch = newValue;
                  });
                },
                items: ['Not Interested', 'Slightly Interested', 'Moderately Interested', 'Very Interested', 'Extremely Interested']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (user != null) {
            saveAnswers();
          } else {
            GlobalMethods.errorDialog(
              subtitle: 'No user found, Please login first!',
              context: context,
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}