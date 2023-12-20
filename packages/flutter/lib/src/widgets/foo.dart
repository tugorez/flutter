import 'dart:async';
import 'dart:ui' show FlutterView, FocusStateChange, FocusDirection;
import 'framework.dart';
import 'focus_manager.dart';    
import 'focus_scope.dart';      
import 'focus_traversal.dart';  

class FocusableView extends StatefulWidget {
  final FlutterView view;
  final Widget child;

  const FocusableView({super.key, required this.view, required this.child});

  @override 
  State<FocusableView> createState() => _FocusableViewState();
}

class _FocusableViewState extends State<FocusableView> {
  late FocusScopeNode _focusNode;
  StreamSubscription? _focusListener;

  @override
  void initState() {
    super.initState();
    _focusListener?.cancel();
    _focusNode = FocusScopeNode();
    _focusListener = widget.view.onFocusStateChange.listen(_handleFocusStateChange);
  }

  void _handleFocusStateChange(FocusStateChange focusStateChange) {
    final isFocused = focusStateChange.currentState.isFocused;     
    final direction = focusStateChange.currentState.direction;     
    if (isFocused) {                                               
      _focusNode.requestFocus();
      /*
      if (direction == FocusDirection.backwards) {
        _focusNode.previousFocus();
      } else {
        _focusNode.nextFocus();
      }
      */
    } else {
      print('lost it ${widget.view.viewId}');
      _focusNode.unfocus();                                         
    }                                                              
  }


  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: FocusScope(
        node: _focusNode,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusListener?.cancel();
  }
}
