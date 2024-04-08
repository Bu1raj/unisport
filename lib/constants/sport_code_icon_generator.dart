import 'package:flutter/material.dart';

String codeGenerator(String sport){
  switch (sport){
    case 'basketball':
      return 'BB';
    case 'volleyball':
      return 'VB';
    case 'football':
      return 'FB';
    case 'cricket':
      return 'CK';
    case 'handball':
      return 'HB';
    case 'tennis':
      return 'TE';
    default :
      return '';
  }
}

IconData iconGenerator(String sport){
  switch (sport){
    case 'basketball':
      return Icons.sports_basketball;
    case 'volleyball':
      return Icons.sports_volleyball;
    case 'football':
      return Icons.sports_soccer;
    case 'cricket':
      return Icons.sports_cricket;
    case 'handball':
      return Icons.sports_handball;
    case 'tennis':
      return Icons.sports_tennis;
    default :
      return Icons.sports;
  }
} 