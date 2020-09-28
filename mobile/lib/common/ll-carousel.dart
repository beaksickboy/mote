import 'dart:html';

import 'package:flutter/material.dart';

class LLCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 500,
        child: PageView.builder(
          itemBuilder: (context, index) {
            print(index);
            return index % 2 == 0
                ? Container(
                    child: Text('a'),
                    color: Colors.purple,
                  )
                : Container(
                    child: Text('b'),
                  );
          },
          itemCount: 2,
//          controller: ,
        ),
      ),
    );
  }
}


//////// RtcLegacyStatsReport


import 'dart:ui';
import 'package:flutter/material.dart';

class ParallaxCarousel extends StatefulWidget {
  final List<ParallaxCardModel> items;
  final int borderRadius;
  final bool showScrollIndicator;
  final Color thumbColor;
  final Color trackColor;

  ParallaxCarousel({
    @required this.items,
    this.borderRadius,
    this.showScrollIndicator = false,
    this.thumbColor = Colors.black,
    this.trackColor = Colors.white,
  });

  @override
  _ParallaxCarouselState createState() => _ParallaxCarouselState();
}

class _ParallaxCarouselState extends State<ParallaxCarousel>
    with TickerProviderStateMixin {
  Offset startDrag;
  double scrollPercentOnStartDrag;
  double scrollPercent = 0.0;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 150))
      ..addListener(() {
        // Update scroll percent
        setState(() {
          scrollPercent = lerpDouble(
            finishScrollStart,
            finishScrollEnd,
            animationController.value,
          );
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  List<Widget> _buildCards() {
    final numCards = widget.items.length;
    int index = -1;
    return widget.items.map((ParallaxCardModel el) {
      ++index;
      return buildCard(index, numCards, scrollPercent, el);
    }).toList();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    scrollPercentOnStartDrag = scrollPercent;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currentPosition = details.globalPosition;

    ///    Swipe from right to left => negative number
    ///    Swipe from left to right => positive number
    final dragDistance = currentPosition.dx - startDrag.dx;
    final singleCardScrollPercent = dragDistance / context.size.width;

    ///    [clamp] giúp card không bị scroll hết ra ngoài màn hình, (scroll ra xa phía
    ///    trước card đầu tiên hay scroll ra xa phía sau card cuối
    ///    nghĩa là vẫn còn giữ lại card đầu và cuối lúc scroll gần hết

    ///    Prevent last card scroll out of screen, giữ card cuối trong screen
    ///      => 1.0 - (1 / numCards)

    ///    (singleCardScrollPercent / numCards) (1)
    ///    giúp tăng số lần swipe bằng số lần card
    ///    Do với 1 mình singleCardScrollPercent thì khi
    ///    swipe từ sát bên phải sang sát bên trái màn hình => 1 lần swipe sẽ
    ///    scroll qua hết tất cả numCards
    ///    => (singleCardScrollPercent / numCards)
    ///    swipe từ sát bên phải sang sát bên trái màn hình tổng cộng numCards lần,
    ///    để scroll Qua hết  tất cả numCards
    setState(() {
      scrollPercent = (scrollPercentOnStartDrag -
          (singleCardScrollPercent / widget.items.length))
          .clamp(0.0, 1.0 - (1 / widget.items.length));
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    /// Store release scrollPercent and calculate end scroll for snapping
    /// Nhân lại với tổng số card để lấy đc vị trí hiện tại của card
    /// 0.3441358024691359 * 3 = 1.03240740741
    /// => vị trí release drag đang bên phải card index 1 khoảng 0.03240740741

    /// round để lấy vị trí cần snapping tới
    /// divide cho numcards để lấy scrollPercent (1)(tham khảo)
    finishScrollStart = scrollPercent;
    finishScrollEnd =
        (scrollPercent * widget.items.length).round() / widget.items.length;

    final duration = details.velocity.pixelsPerSecond.dx
        .abs()
        .clamp(300.0, MediaQuery.of(context).size.width)
        .round();
    animationController.duration = Duration(milliseconds: 500);
    animationController.forward(from: 0.0);
    setState(() {
      startDrag = null;
      scrollPercentOnStartDrag = null;
    });
  }

  Widget buildCard(
      int index, int count, double scrollPercent, ParallaxCardModel el) {
    final cardScrollPercent = scrollPercent * count;

    ///    (index / count) is the beginning scroll percent for a given index
    final parallax = scrollPercent - (index / count);

    ///    Card scroll percent === 0
    ///    => 0 1 2
    ///    Card show is card with dx = 0
    return FractionalTranslation(
      translation: Offset(index - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _CarouselCard(parallax: parallax, el: el),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,

      /// Override default behavior is deferToChild.
      /// Vì deferToChild sẽ deletegate event xuống cho child, nên khi drag start
      /// ở phần bị trốn do padding các item, event sẽ không bắn
      /// => sẽ không handle đc event.
      /// opaque cho phép receive các event xảy ra và ngăn chặn child nhận đc event
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: _buildCards(),
            ),
          ),
          _BottomBar(
            scrollPercent: scrollPercent,
            numCards: widget.items.length,
            showScrollIndicator: widget.showScrollIndicator,
            thumbColor: widget.thumbColor,
            trackColor: widget.trackColor,
          )
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final double scrollPercent;
  final int numCards;
  final Color thumbColor;
  final Color trackColor;
  final bool showScrollIndicator;

  _BottomBar(
      {@required this.scrollPercent,
        @required this.numCards,
        this.thumbColor,
        this.trackColor,
        this.showScrollIndicator});

  @override
  Widget build(BuildContext context) {
    return showScrollIndicator
        ? Container(
      height: 40.0,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
      child: _ScrollIndicator(
        scrollPercent: scrollPercent,
        numCards: numCards,
        thumbColor: thumbColor,
        trackColor: trackColor,
      ),
    )
        : SizedBox(
      height: 0,
      width: 0,
    );
  }
}

class _ScrollIndicator extends StatelessWidget {
  final double scrollPercent;
  final int numCards;
  final Color thumbColor;
  final Color trackColor;

  _ScrollIndicator(
      {@required this.scrollPercent,
        @required this.numCards,
        this.thumbColor,
        this.trackColor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScrollIndicatorPainter(
          scrollPercent: scrollPercent,
          numCards: numCards,
          thumbColor: thumbColor,
          trackColor: trackColor),
    );
  }
}

class _ScrollIndicatorPainter extends CustomPainter {
  final double scrollPercent;
  final int numCards;
  final Paint trackPaint;
  final Paint thumbPaint;
  final Color thumbColor;
  final Color trackColor;

  _ScrollIndicatorPainter(
      {@required this.scrollPercent,
        @required this.numCards,
        this.thumbColor,
        this.trackColor})
      : trackPaint = Paint()
    ..color = trackColor
    ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            0.0,
            0.0,
            size.width,
            size.height,
          ),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        trackPaint);

    final widthThumb = size.width / numCards;
    final startLeftThumb = scrollPercent * size.width;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            startLeftThumb,
            0.0,
            widthThumb,
            size.height,
          ),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _CarouselCard extends StatelessWidget {
  final double parallax;
  final ParallaxCardModel el;
  final BorderRadius borderRadius;

  _CarouselCard({
    @required this.parallax,
    @required this.el,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: this.borderRadius ?? BorderRadius.circular(10),
          child: FractionalTranslation(
            translation: Offset(parallax * 2.0, 0),
            child: OverflowBox(
              maxWidth: double.infinity,
              child: el.backgroundImage,
            ),
          ),
        ),

        /// SizedBox.shrink() Return an container width and height is 0
        el.widget ?? SizedBox.shrink(),
      ],
    );
  }
}


class ParallaxCardModel {
  final Image backgroundImage;
  final Widget widget;

  ParallaxCardModel({@required this.backgroundImage, @required this.widget});
}