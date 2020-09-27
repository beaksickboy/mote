import 'dart:async';
import 'dart:math';

import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/vec2d.dart';
import 'package:flutter/rendering.dart';

class TeddyScreen extends StatefulWidget {
  static final String routeName = 'teddy-screen';

  @override
  _TeddyScreenState createState() => _TeddyScreenState();
}

class _TeddyScreenState extends State<TeddyScreen> {
  TeddyController _teddyController;
  @override
  initState() {
    _teddyController = TeddyController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: Color.fromRGBO(93, 142, 155, 1.0),
      body: Container(
          child: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.0, 1.0],
                colors: [
                  Color.fromRGBO(170, 207, 211, 1.0),
                  Color.fromRGBO(93, 142, 155, 1.0),
                ],
              ),
            ),
          )),
          Positioned.fill(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: devicePadding.top + 50.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 200,
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: FlareActor(
                            "assets/Teddy.flr",
                            shouldClip: false,
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.contain,
                            controller: _teddyController,
                          )),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Form(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TrackingTextInput(
                                    label: "Email",
                                    hint: "What's your email address?",
                                    onCaretMoved: (Offset caret) {
                                      _teddyController.lookAt(caret);
                                    }),
                                TrackingTextInput(
                                  label: "Password",
                                  hint: "Try 'bears'...",
                                  isObscured: true,
                                  onCaretMoved: (Offset caret) {
                                    _teddyController.coverEyes(caret != null);
                                    _teddyController.lookAt(null);
                                  },
                                  onTextChanged: (String value) {
                                    _teddyController.setPassword(value);
                                  },
                                ),
                                SigninButton(
                                    child: Text("Sign In",
                                        style: TextStyle(
                                            fontFamily: "RobotoMedium",
                                            fontSize: 16,
                                            color: Colors.white)),
                                    onPressed: () {
                                      _teddyController.submitPassword();
                                    })
                              ],
                            )),
                          )),
                    ])),
          ),
        ],
      )),
    );
  }
}

class TeddyController extends FlareControls {
  // Store a reference to our face control node (the "ctrl_look" node in Flare)
  ActorNode _faceControl;

  // Storage for our matrix to get global Flutter coordinates into Flare world coordinates.
  Mat2D _globalToFlareWorld = Mat2D();

  // Caret in Flutter global coordinates.
  Vec2D _caretGlobal = Vec2D();

  // Caret in Flare world coordinates.
  Vec2D _caretWorld = Vec2D();

  // Store the origin in both world and local transform spaces.
  Vec2D _faceOrigin = Vec2D();
  Vec2D _faceOriginLocal = Vec2D();

  bool _hasFocus = false;

  // Project gaze forward by this many pixels.
  static const double _projectGaze = 60.0;

  String _password;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    Vec2D targetTranslation;
    if (_hasFocus) {
      // Get caret in Flare world space.
      Vec2D.transformMat2D(_caretWorld, _caretGlobal, _globalToFlareWorld);

      // To make it more interesting, we'll also add a sinusoidal vertical offset.
      _caretWorld[1] +=
          sin(new DateTime.now().millisecondsSinceEpoch / 300.0) * 70.0;

      // Compute direction vector.
      Vec2D toCaret = Vec2D.subtract(Vec2D(), _caretWorld, _faceOrigin);
      Vec2D.normalize(toCaret, toCaret);
      Vec2D.scale(toCaret, toCaret, _projectGaze);

      // Compute the transform that gets us in face "ctrl_face" space.
      Mat2D toFaceTransform = Mat2D();
      if (Mat2D.invert(toFaceTransform, _faceControl.parent.worldTransform)) {
        // Put toCaret in local space, note we're using a direction vector
        // not a translation so transform without translation
        Vec2D.transformMat2(toCaret, toCaret, toFaceTransform);
        // Our final "ctrl_face" position is the original face translation plus this direction vector
        targetTranslation = Vec2D.add(Vec2D(), toCaret, _faceOriginLocal);
      }
    } else {
      targetTranslation = Vec2D.clone(_faceOriginLocal);
    }

    // We could just set _faceControl.translation to targetTranslation, but we want to animate it smoothly to this target
    // so we interpolate towards it by a factor of elapsed time in order to maintain speed regardless of frame rate.
    Vec2D diff =
        Vec2D.subtract(Vec2D(), targetTranslation, _faceControl.translation);
    Vec2D frameTranslation = Vec2D.add(Vec2D(), _faceControl.translation,
        Vec2D.scale(diff, diff, min(1.0, elapsed * 5.0)));

    _faceControl.translation = frameTranslation;

    return true;
  }

  // Fetch references for the `ctrl_face` node and store a copy of its original translation.
  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    _faceControl = artboard.getNode("ctrl_face");
    if (_faceControl != null) {
      _faceControl.getWorldTranslation(_faceOrigin);
      Vec2D.copy(_faceOriginLocal, _faceControl.translation);
    }
    play("idle");
  }

  @override
  onCompleted(String name) {
    play("idle");
  }

  // Called by [FlareActor] when the view transform changes.
  // Updates the matrix that transforms Global-Flutter-coordinates into Flare-World-coordinates.
  @override
  void setViewTransform(Mat2D viewTransform) {
    Mat2D.invert(_globalToFlareWorld, viewTransform);
  }

  // Transform the [Offset] into a [Vec2D].
  // If no caret is provided, lower the [_hasFocus] flag.
  void lookAt(Offset caret) {
    if (caret == null) {
      _hasFocus = false;
      return;
    }
    _caretGlobal[0] = caret.dx;
    _caretGlobal[1] = caret.dy;
    _hasFocus = true;
  }

  void setPassword(String value) {
    _password = value;
  }

  bool _isCoveringEyes = false;
  void coverEyes(bool cover) {
    if (_isCoveringEyes == cover) {
      return;
    }
    _isCoveringEyes = cover;
    if (cover) {
      play("hands_up");
    } else {
      play("hands_down");
    }
  }

  void submitPassword() {
    if (_password == "bears") {
      play("success");
    } else {
      play("fail");
    }
  }
}

class SigninButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const SigninButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(160, 92, 147, 1.0),
              Color.fromRGBO(115, 82, 135, 1.0)
            ],
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}

// Adapted these helpful functions from:
// https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/text_field_test.dart

// Returns first render editable
RenderEditable findRenderEditable(RenderObject root) {
  RenderEditable renderEditable;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder);
  }

  root.visitChildren(recursiveFinder);
  return renderEditable;
}

List<TextSelectionPoint> globalize(
    Iterable<TextSelectionPoint> points, RenderBox box) {
  return points.map<TextSelectionPoint>((TextSelectionPoint point) {
    return TextSelectionPoint(
      box.localToGlobal(point.point),
      point.direction,
    );
  }).toList();
}

Offset getCaretPosition(RenderBox box) {
  final RenderEditable renderEditable = findRenderEditable(box);
  if (!renderEditable.hasFocus) {
    return null;
  }
  final List<TextSelectionPoint> endpoints = globalize(
    renderEditable.getEndpointsForSelection(renderEditable.selection),
    renderEditable,
  );
  return endpoints[0].point + const Offset(0.0, -2.0);
}

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

// Helper widget to track caret position.
class TrackingTextInput extends StatefulWidget {
  TrackingTextInput(
      {Key key,
      this.onCaretMoved,
      this.onTextChanged,
      this.hint,
      this.label,
      this.isObscured = false})
      : super(key: key);
  final CaretMoved onCaretMoved;
  final TextChanged onTextChanged;
  final String hint;
  final String label;
  final bool isObscured;
  @override
  _TrackingTextInputState createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  Timer _debounceTimer;
  @override
  initState() {
    _textController.addListener(() {
      // We debounce the listener as sometimes the caret position is updated after the listener
      // this assures us we get an accurate caret position.
      if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (_fieldKey.currentContext != null) {
          // Find the render editable in the field.
          final RenderObject fieldBox =
              _fieldKey.currentContext.findRenderObject();
          Offset caretPosition = getCaretPosition(fieldBox);

          if (widget.onCaretMoved != null) {
            widget.onCaretMoved(caretPosition);
          }
        }
      });
      if (widget.onTextChanged != null) {
        widget.onTextChanged(_textController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: widget.hint,
            labelText: widget.label,
          ),
          key: _fieldKey,
          controller: _textController,
          obscureText: widget.isObscured,
          validator: (value) {}),
    );
  }
}
