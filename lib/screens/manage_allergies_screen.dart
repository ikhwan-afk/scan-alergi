import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pluralize/pluralize.dart';
import 'package:scan_alergi/providers/allergy_provider.dart';
import 'package:scan_alergi/utils/utils.dart';

class ManageAllergiesScreen extends StatefulWidget {
  const ManageAllergiesScreen({super.key});

  @override
  _ManageAllergiesScreenState createState() => _ManageAllergiesScreenState();
}

class _ManageAllergiesScreenState extends State<ManageAllergiesScreen> {
  // Text controller to manage input for adding allergens
  final TextEditingController _controller = TextEditingController();
  static const int maxAllergies =
      30; // Max limit for number of allergies that can be added
  String?
      _selectedGroupAllergen; // Stores the currently selected group allergen from dropdown

  @override
  void initState() {
    super.initState();
    // Listener to update state whenever text input changes
    _controller.addListener(() {
      setState(() {});
    });
  }

  // Dispose of the controller to free up resources
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dipilh Alergi ne yo'), // Title for the app bar
        actions: [
          IconButton(
            icon: const Icon(
                Icons.delete_sweep), // Icon for the "Clear All" button
            onPressed: () {
              // Show a confirmation dialog before clearing all allergies
              showConfirmationDialog(
                context,
                title: 'Meh mbok hapus alergi',
                content: 'Beneran meh diapus semua alergi ne?',
                onConfirm: () {
                  Provider.of<AllergyProvider>(context, listen: false)
                      .clearAllergies();
                },
              );
            },
            tooltip: 'Hapus semua alergi', // Tooltip text
          ),
        ],
      ),
      body: Consumer<AllergyProvider>(
        // Consumer to listen to changes in AllergyProvider
        builder: (context, allergyProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: allergyProvider
                      .allergies.length, // Number of items in the list
                  itemBuilder: (context, index) {
                    String allergy = allergyProvider
                        .allergies[index]; // Get each allergy from the list
                    String displayAllergy = capitalizeFirstLetter(
                        allergy); // Capitalize first letter for display

                    // Handle Tree Nuts allergen - Display title with its corresponding nuts
                    if (allergy == 'Tree Nuts') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                                displayAllergy), // Display capitalized allergy name
                            trailing: IconButton(
                              icon: const Icon(
                                  Icons.delete), // Delete icon button
                              onPressed: () =>
                                  allergyProvider.removeAllergensOfType(
                                      'Tree Nuts',
                                      allergyProvider
                                          .treeNuts), // Remove "Tree Nuts" and all corresponding nuts
                            ),
                          ),
                          ...allergyProvider.treeNuts.map((treeNut) {
                            return allergyProvider.allergies.contains(treeNut)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0), // Indent child item
                                    child: ListTile(
                                      title: Text(capitalizeFirstLetter(
                                          treeNut)), // Display capitalized tree nut
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete), // Delete icon button
                                        onPressed: () =>
                                            allergyProvider.removeAllergy(
                                                treeNut), // Remove specific tree nut
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                        ],
                      );
                    }

                    // Handle Crustacean Shellfish allergen - Display title with its corresponding shellfish
                    else if (allergy == 'Crustacean Shellfish') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                                displayAllergy), // Display capitalized allergy name
                            trailing: IconButton(
                              icon: const Icon(
                                  Icons.delete), // Delete icon button
                              onPressed: () =>
                                  allergyProvider.removeAllergensOfType(
                                      'Crustacean Shellfish',
                                      allergyProvider
                                          .crustaceanShellfish), // Remove "Crust. Shell." and all corresponding allergens
                            ),
                          ),
                          ...allergyProvider.crustaceanShellfish
                              .map((shellfish) {
                            return allergyProvider.allergies.contains(shellfish)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0), // Indent child item
                                    child: ListTile(
                                      title: Text(capitalizeFirstLetter(
                                          shellfish)), // Display capitalized crust. shell.
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete), // Delete icon button
                                        onPressed: () =>
                                            allergyProvider.removeAllergy(
                                                shellfish), // Remove specific crust. shellfish
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                        ],
                      );
                    }

                    // Handle Fish allergen - Display title with its corresponding fish
                    else if (allergy == 'Fish') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                                displayAllergy), // Display capitalized allergy name
                            trailing: IconButton(
                              icon: const Icon(
                                  Icons.delete), // Delete icon button
                              onPressed: () =>
                                  allergyProvider.removeAllergensOfType(
                                      'Fish',
                                      allergyProvider
                                          .fish), // Remove "Fish" and all corresponding allergens
                            ),
                          ),
                          ...allergyProvider.fish.map((fish) {
                            return allergyProvider.allergies.contains(fish)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0), // Indent child item
                                    child: ListTile(
                                      title: Text(capitalizeFirstLetter(
                                          fish)), // Display capitalized fish
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete), // Delete icon button
                                        onPressed: () =>
                                            allergyProvider.removeAllergy(
                                                fish), // Remove specific crust. shellfish
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                        ],
                      );
                    }

                    // Handle Legumes allergen - Display title with its corresponding legumes
                    else if (allergy == 'Legumes') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                                displayAllergy), // Display capitalized allergy name
                            trailing: IconButton(
                              icon: const Icon(
                                  Icons.delete), // Delete icon button
                              onPressed: () =>
                                  allergyProvider.removeAllergensOfType(
                                      'Legumes',
                                      allergyProvider
                                          .legumes), // Remove "Legumes" and all corresponding allergens
                            ),
                          ),
                          ...allergyProvider.legumes.map((legume) {
                            return allergyProvider.allergies.contains(legume)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0), // Indent child item
                                    child: ListTile(
                                      title: Text(capitalizeFirstLetter(
                                          legume)), // Display capitalized legume
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete), // Delete icon button
                                        onPressed: () =>
                                            allergyProvider.removeAllergy(
                                                legume), // Remove specific legume
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                        ],
                      );
                    }

                    // Handle individual (non-group) allergens
                    else if (allergyProvider.treeNuts.contains(allergy) ||
                        allergyProvider.crustaceanShellfish.contains(allergy) ||
                        allergyProvider.fish.contains(allergy) ||
                        allergyProvider.legumes.contains(allergy)) {
                      // Skip rendering individual items handled above
                      return Container();
                    } else {
                      // Display other individual allergens
                      return ListTile(
                        title: Text(
                            displayAllergy), // Display capitalized allergy name
                        trailing: IconButton(
                          icon: const Icon(Icons.delete), // Delete icon button
                          onPressed: () => allergyProvider.removeAllergy(
                              allergy), // Remove allergy when pressed
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.all(8.0), // Padding around the input row
                color: const Color.fromARGB(255, 247, 244,
                    191), // Background color for the input and dropdown area
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: _controller, // Controller for text input
                          style: const TextStyle(
                            color: Color.fromARGB(
                                255, 90, 6, 100), // Purple color for text input
                          ),
                          decoration: const InputDecoration(
                            labelText:
                                'Nek Meh nulis alergi kene', // Input field label
                            labelStyle: TextStyle(
                              color: Color.fromARGB(
                                  255, 90, 6, 100), // Purple color for label
                              fontWeight: FontWeight.bold,
                            ),
                            filled:
                                true, // Ensures the background color is filled
                            fillColor: Color.fromARGB(255, 247, 244,
                                191), // Background color for the TextField
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 90, 6,
                                    100), // Purple color for focused border
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 90, 6,
                                    100), // Purple color for enabled border
                              ),
                            ),
                          ),
                          cursorColor: const Color.fromARGB(
                              255, 90, 6, 100), // Purple cursor color
                        )),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(
                                4.0), // Add padding to create space between the icon and the circle
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(
                                  255, 101, 156, 103), // Green background
                              shape: BoxShape.circle, // Circle shape
                            ),
                            child: const Icon(
                              Icons.add, //Plus icon
                              color: Color.fromARGB(255, 255, 253,
                                  208), // Cream color for the plus sign
                            ),
                          ),
                          onPressed: () {
                            String newAllergy = _controller.text
                                .trim()
                                .toLowerCase(); // Normalize input to lowercase

                            if (newAllergy.isNotEmpty) {
                              // Check if input is not empty
                              if (allergyProvider.allergies.length <
                                  maxAllergies) {
                                // Check if not exceeding max limit
                                bool isDuplicate = allergyProvider.allergies
                                    .map((allergy) => Pluralize()
                                        .singular(allergy)
                                        .toLowerCase()) // Compare lowercase singular form to check for duplicates
                                    .contains(Pluralize().singular(newAllergy));
                                if (!isDuplicate) {
                                  allergyProvider.addAllergy(
                                      newAllergy); // Add the new allergen
                                  _controller.clear(); // Clear the input field
                                } else {
                                  showSnackBar(context,
                                      'This allergen is already in the list.');
                                }
                              } else {
                                showSnackBar(context,
                                    'You can add a maximum of 30 allergies.');
                              }
                            } else {
                              showSnackBar(
                                  context, 'Please enter a valid allergen.');
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                        height:
                            8.0), // Small space between the TextField and DropdownButtonFormField
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              filled:
                                  true, // Ensures the background color is filled
                              fillColor: Color.fromARGB(255, 247, 244,
                                  191), // Background color for the DropdownButton
                              labelText: 'Nek milih group alergi kene',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(
                                    255, 90, 6, 100), // Purple color for label
                                fontWeight: FontWeight.bold, // Bold text
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 90, 6,
                                      100), // Purple color for focused border
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 90, 6,
                                      100), // Purple color for enabled border
                                ),
                              ),
                            ),
                            value:
                                _selectedGroupAllergen, // Selected group allergen value
                            onChanged: (String? value) {
                              setState(() {
                                _selectedGroupAllergen =
                                    value; // Set selected group allergen
                              });
                            },
                            items: <String>[
                              'Tree Nuts',
                              'Crustacean Shellfish',
                              'Fish',
                              'Legumes',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value, // Display dropdown item
                                  style: TextStyle(
                                    color: _selectedGroupAllergen == value
                                        ? const Color.fromARGB(255, 90, 6,
                                            100) // Purple color for selected item
                                        : const Color.fromARGB(255, 255, 253,
                                            208), // Cream color for unselected items
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(
                                4.0), // Add padding to create space between the icon and the circle
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(
                                  255, 101, 156, 103), // Green background
                              shape: BoxShape.circle, // Circle shape
                            ),
                            child: const Icon(
                              Icons.add, //Plus icon
                              color: Color.fromARGB(255, 255, 253,
                                  208), // Cream color for the plus sign
                            ),
                          ), // Add icon button
                          onPressed: () {
                            if (_selectedGroupAllergen != null) {
                              // Check if a group allergen is selected
                              int totalAllergies = allergyProvider.allergies
                                  .length; // Total current allergies count

                              if (_selectedGroupAllergen == 'Tree Nuts') {
                                // Add tree nuts count
                                totalAllergies +=
                                    allergyProvider.treeNuts.length;
                              } else if (_selectedGroupAllergen ==
                                  'Crustacean Shellfish') {
                                // Add crust. shellfish count
                                totalAllergies +=
                                    allergyProvider.crustaceanShellfish.length;
                              } else if (_selectedGroupAllergen == 'Fish') {
                                // Add fish count
                                totalAllergies += allergyProvider.fish.length;
                              } else if (_selectedGroupAllergen == 'Legumes') {
                                // Add legumes count
                                totalAllergies +=
                                    allergyProvider.legumes.length;
                              }

                              // Check if not exceeding max limit
                              if (totalAllergies < maxAllergies) {
                                bool isDuplicate = allergyProvider.allergies
                                    .map((allergy) => allergy.toLowerCase())
                                    .contains(
                                        _selectedGroupAllergen!.toLowerCase());
                                if (!isDuplicate) {
                                  allergyProvider.addAllergy(
                                      _selectedGroupAllergen!); // Add the selected group allergen

                                  // Check selected group allergen
                                  if (_selectedGroupAllergen == 'Tree Nuts') {
                                    for (var treeNut
                                        in allergyProvider.treeNuts) {
                                      // For each tree nut in the list ...
                                      if (!allergyProvider.allergies
                                          .contains(treeNut)) {
                                        //...Check if not already in allergies list
                                        allergyProvider.addAllergy(
                                            treeNut); // Add tree nut to allergies list
                                      }
                                    }
                                  } else if (_selectedGroupAllergen ==
                                      'Crustacean Shellfish') {
                                    for (var shellfish in allergyProvider
                                        .crustaceanShellfish) {
                                      // For each shellfish in the list ...
                                      if (!allergyProvider.allergies
                                          .contains(shellfish)) {
                                        //...Check if not already in allergies list
                                        allergyProvider.addAllergy(
                                            shellfish); // Add shellfish to allergies list
                                      }
                                    }
                                  } else if (_selectedGroupAllergen == 'Fish') {
                                    for (var fish in allergyProvider.fish) {
                                      // For each fish in the list ...
                                      if (!allergyProvider.allergies
                                          .contains(fish)) {
                                        //...Check if not already in allergies list
                                        allergyProvider.addAllergy(
                                            fish); // Add fish to allergies list
                                      }
                                    }
                                  } else if (_selectedGroupAllergen ==
                                      'Legumes') {
                                    for (var legume
                                        in allergyProvider.legumes) {
                                      // For each legume in the list ...
                                      if (!allergyProvider.allergies
                                          .contains(legume)) {
                                        //...Check if not already in allergies list
                                        allergyProvider.addAllergy(
                                            legume); // Add legume to allergies list
                                      }
                                    }
                                  }
                                  setState(() {
                                    _selectedGroupAllergen =
                                        null; // Clear selected group allergen
                                  });
                                } else {
                                  showSnackBar(context,
                                      'This group allergen is already in the list.');
                                }
                              } else {
                                showSnackBar(context,
                                    'Adding this group allergen exceeds the maximum limit of 30 allergies.');
                              }
                            } else {
                              showSnackBar(
                                  context, 'Please select a group allergen.');
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
