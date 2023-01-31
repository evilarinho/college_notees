import 'package:flutter/material.dart';

@immutable
class AppTypo {
  // Texto para Títulos
  final title = const TextStyle(
      fontFamily: "Inter", fontSize: 30, fontWeight: FontWeight.w700);

  // Texto Home
  final homeText = const TextStyle(
      color: Colors.black87,
      fontFamily: "Inter",
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.5);

  // Texto do Botão
  final button = const TextStyle(
      fontFamily: "Inter",
      fontSize: 17,
      fontWeight: FontWeight.bold,
      letterSpacing: 0);

  // Texto para Título na AppBar
  final appBar = const TextStyle(
      fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.w500);

  // Texto para formulários
  final formText = const TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0);

  // Texto Padrão Negrito
  final defaultBoldText = const TextStyle(
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0);

  const AppTypo();
}
