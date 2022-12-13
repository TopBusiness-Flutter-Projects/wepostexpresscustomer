import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_bloc/new_order_bloc.dart';
import 'package:wepostexpresscustomer/ui/new_order/new_order_bloc/new_order_states.dart';
import 'package:wepostexpresscustomer/utils/config/config.dart';
import 'package:wepostexpresscustomer/utils/constants/constants.dart';

class StepTrackerHorizontal extends StatefulWidget {
  StepTrackerHorizontal({@required this.screenSize,@required this.circleSizeStart,@required this.circleSizeEnd,@required this.iconFilled,@required this.index,@required this.stepDone,@required this.title, @required this.icon, @required this.isLast, @required this.firstFilled, @required this.secondFilled});

  final String title;
  final bool isLast;
  final bool firstFilled;
  final bool secondFilled;
  final bool iconFilled;
  final bool stepDone;
  final String icon;
  final int index;
  final double screenSize;
  final double circleSizeStart;
  final double circleSizeEnd;

  @override
  _StepTrackerHorizontalState createState() => _StepTrackerHorizontalState();
}

class _StepTrackerHorizontalState extends State<StepTrackerHorizontal> with TickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  Animation animation2;
  AnimationController controllerCircle;
  Animation animationCircle;
  AnimationController controllerForSecond;
  Animation animationForSecond;
  Animation animation2ForSecond;

  Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
        end: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
      ),
    ),
  ]);


  Animatable<Color> backgroundForSecond = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
        end: rgboOrHex(Config.get.styling[Config.get.themeMode].primary),
      ),
    ),
  ]);

  bool isFalse = false;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    animation = Tween<double>(begin: 5.0, end: 0.0).animate(controller);
    animation2 = Tween<double>(begin: 5.0, end: widget.screenSize).animate(controller);

    controllerCircle = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animationCircle = Tween<double>(begin: widget.circleSizeStart, end: widget.circleSizeEnd).animate(controllerCircle);
    if(widget.index == 0){
      controllerCircle.forward();
    }

    controllerForSecond = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    animationForSecond = Tween<double>(begin: 5.0, end: 0.0).animate(controllerForSecond);
    animation2ForSecond = Tween<double>(begin: 5.0, end: widget.screenSize).animate(controllerForSecond);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewOrderBloc, NewOrderStates>(
      listener: (BuildContext context, state) {
        if(BlocProvider.of<NewOrderBloc>(context).currentIndex ==widget.index){
          controllerCircle.forward();
        }else{
          controllerCircle.reverse();
        }
        if(state is SuccessStepForwardNewOrderState){
          if(BlocProvider.of<NewOrderBloc>(context).currentIndex ==1){
            controller.forward();
          }
          if(BlocProvider.of<NewOrderBloc>(context).currentIndex == 2){
            controllerForSecond.forward();
          }
        }
        if(state is SuccessStepBackwardNewOrderState){
          if(BlocProvider.of<NewOrderBloc>(context).currentIndex ==0){
            controller.reverse();
          }
          if(BlocProvider.of<NewOrderBloc>(context).currentIndex == 1){
            controllerForSecond.reverse();
          }
        }

      },
      child: Column(
        children: [
          Row(
            children: <Widget>[
              if(!widget.isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 100,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Row(
                        children: [
                          AnimatedBuilder(
                            builder: (context, child) => Container(
                              width: animation.value ,
                            ),
                            animation: animation,
                          ),
                          AnimatedBuilder(
                            builder: (context, child) => Container(
                              decoration: BoxDecoration(
                                      color: background.evaluate(
                                              AlwaysStoppedAnimation(controller.value)),
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                              width: animation2.value,
                            ),
                            animation: animation2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AnimatedBuilder(
                        builder: (context, child) => Container(
                          width: animationCircle.value,
                          height: animationCircle.value,
                          decoration: BoxDecoration(
                                  color: widget.stepDone?rgboOrHex(Config.get.styling[Config.get.themeMode].primary):widget.iconFilled?Colors.white:
                                  Color(0xff281B13),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(width: 1,color: widget.stepDone?rgboOrHex(Config.get.styling[Config.get.themeMode].primary):widget.iconFilled?Colors.white:rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant))
                          ),
                          child: IconButton(
                            icon: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: SvgPicture.asset(widget.icon,
                                color: widget.stepDone? Color(0xff281B13):widget.iconFilled? Color(0xff281B13):
                                rgboOrHex(Config.get.styling[Config.get.themeMode].secondaryVariant),
                              ),
                            ),
                            onPressed: () {
                            },
                          ),
                        ),
                        animation: animationCircle,
                      ),

                    ],
                  ),
                ),
              ),
              if(!widget.isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 100,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Row(
                        children: [
                          AnimatedBuilder(
                            builder: (context, child) => Container(
                              width: animationForSecond.value ,
                            ),
                            animation: animationForSecond,
                          ),
                          AnimatedBuilder(
                            builder: (context, child) => Container(
                              decoration: BoxDecoration(
                                      color: backgroundForSecond.evaluate(
                                              AlwaysStoppedAnimation(controllerForSecond.value)),
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                              height: (MediaQuery.of(context).size.height * (2.2 / 100)) / 3,
                              width: animation2ForSecond.value,
                            ),
                            animation: animation2ForSecond,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
