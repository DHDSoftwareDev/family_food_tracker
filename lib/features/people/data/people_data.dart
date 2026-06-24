import 'package:flutter/material.dart';

class PersonProfile {
  final String name;
  final String summary;
  final IconData icon;
  final List<String> preferences;
  final List<String> likes;
  final List<String> dislikes;
  final String pattern;
  final String prediction;

  const PersonProfile({
    required this.name,
    required this.summary,
    required this.icon,
    required this.preferences,
    required this.likes,
    required this.dislikes,
    required this.pattern,
    required this.prediction,
  });
}

const peopleProfiles = [
  PersonProfile(
    name: 'John',
    summary: 'Loves spicy food',
    icon: Icons.local_fire_department,
    preferences: ['Spicy', 'Crunchy', 'Savory'],
    likes: ['Tacos', 'Hot wings', 'Nachos'],
    dislikes: ['Dairy', 'Soft textures'],
    pattern: 'Usually chooses bold, savory meals with heat and crunch.',
    prediction: 'Most likely to enjoy spicy chicken tacos with crisp toppings.',
  ),
  PersonProfile(
    name: 'Sarah',
    summary: 'Vegetarian',
    icon: Icons.eco,
    preferences: ['Vegetarian', 'Fresh', 'Herby'],
    likes: ['Salads', 'Falafel', 'Pasta'],
    dislikes: ['Meat', 'Heavy sauces'],
    pattern: 'Favors fresh plant-based meals that are filling but not heavy.',
    prediction:
        'Most likely to enjoy a falafel bowl with vegetables and herbs.',
  ),
  PersonProfile(
    name: 'Emma',
    summary: 'Avoids dairy',
    icon: Icons.no_food,
    preferences: ['Dairy-free', 'Fruity', 'Light'],
    likes: ['Smoothie bowls', 'Rice dishes', 'Sorbet'],
    dislikes: ['Cheese', 'Cream sauces'],
    pattern: 'Leans toward lighter meals and naturally dairy-free options.',
    prediction: 'Most likely to enjoy a rice bowl with vegetables and avocado.',
  ),
  PersonProfile(
    name: 'Mike',
    summary: 'Prefers crunchy textures',
    icon: Icons.texture,
    preferences: ['Crunchy', 'Savory', 'Grilled'],
    likes: ['Fried chicken', 'Chips', 'Roasted vegetables'],
    dislikes: ['Mushy foods', 'Soggy bread'],
    pattern: 'Texture drives his choices, especially crisp or grilled foods.',
    prediction: 'Most likely to enjoy grilled chicken with crispy potatoes.',
  ),
  PersonProfile(
    name: 'Olivia',
    summary: 'Sweet tooth',
    icon: Icons.cake,
    preferences: ['Sweet', 'Baked', 'Fruity'],
    likes: ['Pancakes', 'Berries', 'Cookies'],
    dislikes: ['Very spicy food', 'Bitter flavors'],
    pattern: 'Often prefers sweet, baked, or fruit-forward choices.',
    prediction: 'Most likely to enjoy berry pancakes or a fruit-filled pastry.',
  ),
];
