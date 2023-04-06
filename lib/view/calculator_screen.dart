import 'package:flutter/material.dart';
import 'package:flutter_dashboard/constants/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = ''; // Stores the current mathematical expression
  String _result = '0'; // Declare the _result variable and initialize it to '0'

  // Handles button press events
  void _onButtonPressed(String text) {
    setState(() {
      if (text == '⌫') {
        // Handle backspace button separately
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else {
        // Replace the "×" symbol with the standard "*" symbol
        if (text == '×') {
          text = '*';
        }

        // Replace the "÷" symbol with the standard "/" symbol
        if (text == '÷') {
          text = '/';
        }

        _expression += text;
      }
    });
  }

  // Clears the current expression
  void _onClearPressed() {
    setState(() {
      _expression = '';
    });
  }

  // Evaluates the current expression and updates the display
  void _onEqualsPressed() {
    setState(() {
      try {
        Parser p = Parser();
        Expression exp = p.parse(_expression);
        ContextModel cm = ContextModel();
        num eval = exp.evaluate(EvaluationType.REAL, cm);
        if (eval is int) {
          _result = eval.toString(); // convert integer result to string
        } else if (eval % 1 == 0) {
          _result = eval.toInt().toString(); // convert integer result to string
        } else {
          _result = eval.toStringAsFixed(
              2); // convert decimal result to string with 2 decimal places
        }
        _expression = _result;
      } catch (e) {
        _result = '0';
        _expression = 'Error';
      }
    });
  }

  // Builds a button with the specified text and color
  Widget _buildButton(String text, {Color color = Colors.white}) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 24,
          color: color == Colors.white ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Calculator',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Clear button
              ElevatedButton(
                onPressed: () => context.go('/weather'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sunny,
                      size: 48,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Weather',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(), // Add a spacer between the weather button and calculator

          // Displays the current mathematical expression
          Container(
            padding: EdgeInsets.all(32),
            child: Text(
              _expression,
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            alignment: Alignment.centerRight,
          ),
          height25,
          // Rows of buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Clear button
              ElevatedButton(
                  onPressed: _onClearPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  child: Text(
                    'CE',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  )),
              _buildButton('⌫', color: Colors.grey), // Backspace button
              _buildButton('%', color: Colors.grey), // Percent button
              _buildButton('÷', color: Colors.orange), // Divide button
            ],
          ),
          height16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('×', color: Colors.orange), // Multiply button
            ],
          ),
          height16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-', color: Colors.orange), // Subtract button
            ],
          ),
          height16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),

              _buildButton('+', color: Colors.orange), // Add button
            ],
          ),
          height16,
          // Bottom row of buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('.'),
              _buildButton('0'),
              _buildButton('00'),
              // Equals button
              ElevatedButton(
                onPressed: _onEqualsPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(12),
                ),
                child: Text(
                  '=',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          height16,
        ],
      ),
    );
  }
}
