class Profile {
  final String id;
  final String uniqueId;
  final String firstName;
  final String lastName;
  final String city;
  final String bio;
  final String experience;
  final String country;
  
  final String primaryTitle;
  final String userPhoto;
  final List<dynamic> industries;
  final List<dynamic> skills;

  Profile({
    required this.id,
    required this.uniqueId,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.bio,
    required this.experience,
    required this.country,
    
    required this.primaryTitle,
    required this.userPhoto,
    required this.industries,
    required this.skills,
  });
}
