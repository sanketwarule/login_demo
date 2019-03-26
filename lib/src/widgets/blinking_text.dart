import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  ///Class that wraps a Text widget and make it blink
  ///
  final Color textColor;
  final String text;
  final String fontFamilly;
  TextAlign alignment;
  final double fontSize;
  final bool bold;
  final bool italic;
  final bool regular;
  final bool capitalLetters;
  final bool loopAnimation;


  BlinkingText({Key key, this.text,this.textColor,this.capitalLetters=false,this.loopAnimation=true
  ,this.fontFamilly,this.fontSize,this.bold=false,this.italic=false,this.regular=true,this.alignment=TextAlign.left}) : super(key: key);

  BlinkingText.bold({Key key,this.text,this.textColor,this.capitalLetters=false,this.loopAnimation=true
  ,this.fontFamilly,this.fontSize,this.bold=true,this.italic=false,this.regular=false,this.alignment=TextAlign.left}): super(key: key);

  BlinkingText.boldItalic({Key key,this.text,this.textColor,this.capitalLetters=false,this.loopAnimation=true
  ,this.fontFamilly,this.fontSize,this.bold=true,this.italic=true,this.regular=false,this.alignment=TextAlign.left}): super(key: key);

  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> with SingleTickerProviderStateMixin{
  Animation<double> textAnimation;
  AnimationController textController;

  void initState() { 
    super.initState();

    textController=AnimationController(
      duration: Duration(seconds: 2),
      vsync: this
    );
    textAnimation=Tween(begin: 0.0,end:1.0)
    .animate(CurvedAnimation(
        parent: textController,
        curve: Curves.linear,
      ),);

      textAnimation.addStatusListener((status){
        if(status==AnimationStatus.completed){
          textController.reverse();
        }else if(status==AnimationStatus.dismissed){
          textController.forward();
        }
      });
      if(widget.loopAnimation){
        textController.forward();
      }else{
        textController.reset();
        textController.stop();
      }
  }
  

  @override
  Widget build(BuildContext context) {
    if(widget.loopAnimation ){
      textController.forward();
    }else{
      textController.reset();
      textController.stop();
    }
    return AnimatedBuilder(
      animation: textAnimation,
      child:_buildText(0.0),
      builder: (BuildContext context, Widget child) {
        return _buildText(textAnimation.value);
      },
    );
  }

  Widget _buildText(double opacity){
    return Opacity(
      opacity:opacity,
      child:Text(
            widget.capitalLetters?widget.text.toUpperCase():widget.text,
            textAlign: widget.alignment,
            style: TextStyle(
              color:widget.textColor,
              fontSize: widget.fontSize!=null?widget.fontSize:10.0,
              fontStyle: widget.italic && !widget.bold?FontStyle.italic:!widget.italic && widget.bold?FontWeight.bold:FontStyle.normal,
              fontFamily: widget.fontFamilly,
            ),
          )
    );
  }
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}