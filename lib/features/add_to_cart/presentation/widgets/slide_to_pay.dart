import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideToPay extends StatefulWidget {
  final double amount;
  final Future<bool> Function() onPaymentProcess;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;

  const SlideToPay({Key? key, required this.amount, required this.onPaymentProcess, this.onSuccess, this.onFailure})
    : super(key: key);

  @override
  _SlideToPayState createState() => _SlideToPayState();
}

class _SlideToPayState extends State<SlideToPay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragPosition = 0;
  double _maxDragExtent = 0;
  bool _isProcessing = false;
  bool _paymentSuccess = false;
  bool _paymentFailed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    setState(() {
      _isProcessing = true;
      _paymentFailed = false;
    });

    try {
      final success = await widget.onPaymentProcess();

      if (success) {
        HapticFeedback.heavyImpact();
        setState(() => _paymentSuccess = true);
        await Future.delayed(Duration(milliseconds: 800));
        _dragPosition = 0;
        widget.onSuccess?.call();
      } else {
        _resetAfterFailure();
        widget.onFailure?.call();
      }
    } catch (e) {
      _resetAfterFailure();
      widget.onFailure?.call();
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _resetAfterFailure() {
    HapticFeedback.vibrate();
    setState(() => _paymentFailed = true);
    _controller.animateBack(0.0).then((_) {
      if (mounted) {
        setState(() {
          _dragPosition = 0;
          _paymentFailed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isSmallMobile = screenSize.width <= 390;
    final isMobile = screenSize.width <= 480;
    final isTablet = screenSize.width >= 600;
    final isDesktop = screenSize.width >= 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:
            isSmallMobile
                ? 12
                : isTablet
                ? 24
                : 16,
        vertical:
            isSmallMobile
                ? 12
                : isTablet
                ? 24
                : 16,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(isTablet ? 20 : 16)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Method Row - made responsive
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height:
                              isSmallMobile
                                  ? 36
                                  : isTablet
                                  ? 48
                                  : 42,
                          width:
                              isSmallMobile
                                  ? 36
                                  : isTablet
                                  ? 48
                                  : 42,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[800] : Color(0xFFEDE7F6),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: const DecorationImage(image: AssetImage('assets/logos/sodexo_logo.png'), fit: BoxFit.contain),
                          ),
                        ),
                        SizedBox(width: isSmallMobile ? 6 : 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'SODEXO Card',
                                  style: TextStyle(
                                    fontSize:
                                        isSmallMobile
                                            ? 11
                                            : isMobile
                                            ? 14
                                            : isTablet
                                            ? 16
                                            : 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    '|',
                                    style: TextStyle(
                                      fontSize:
                                          isSmallMobile
                                              ? 11
                                              : isMobile
                                              ? 14
                                              : isTablet
                                              ? 16
                                              : 14,
                                      color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                                    ),
                                  ),
                                ),
                                Text(
                                  '....4720',
                                  style: TextStyle(
                                    fontSize:
                                        isSmallMobile
                                            ? 11
                                            : isMobile
                                            ? 14
                                            : isTablet
                                            ? 16
                                            : 14,
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Balance: ₹8026',
                              style: TextStyle(
                                fontSize:
                                    isSmallMobile
                                        ? 10
                                        : isMobile
                                        ? 13
                                        : isTablet
                                        ? 14
                                        : 12,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Change',
                        style: TextStyle(
                          fontSize:
                              isSmallMobile
                                  ? 11
                                  : isMobile
                                  ? 14
                                  : isTablet
                                  ? 16
                                  : 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE25B1C),
                        ),
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size:
                              isSmallMobile
                                  ? 13
                                  : isMobile
                                  ? 15
                                  : isTablet
                                  ? 18
                                  : 16,
                          color: Color(0xFFE25B1C),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          SizedBox(
            height:
                isSmallMobile
                    ? 18
                    : isMobile
                    ? 22
                    : isTablet
                    ? 24
                    : 20,
          ),

          // Slide to Pay Button - made responsive
          LayoutBuilder(
            builder: (context, constraints) {
              _maxDragExtent =
                  constraints.maxWidth -
                  (isSmallMobile
                      ? 70
                      : isMobile
                      ? 85
                      : isTablet
                      ? 100
                      : 80);

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (_) {
                  if (!_isProcessing && !_paymentSuccess) {
                    _controller.stop();
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (!_isProcessing && !_paymentSuccess) {
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, _maxDragExtent);
                      _controller.value = _dragPosition / _maxDragExtent;
                    });
                  }
                },
                onHorizontalDragEnd: (_) {
                  if (_isProcessing || _paymentSuccess) return;

                  if (_dragPosition >= _maxDragExtent * 0.8) {
                    _handlePayment();
                  } else {
                    _controller.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    setState(() => _dragPosition = 0);
                  }
                },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Track Background
                    Container(
                      width: double.infinity,
                      height:
                          isSmallMobile
                              ? 48
                              : isMobile
                              ? 52
                              : isTablet
                              ? 64
                              : 56,
                      decoration: BoxDecoration(
                        color:
                            _paymentFailed
                                ? isDarkMode
                                    ? Colors.red[900]!.withOpacity(0.3)
                                    : Colors.red.shade50
                                : isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(
                          isSmallMobile
                              ? 24
                              : isMobile
                              ? 28
                              : isTablet
                              ? 32
                              : 28,
                        ),
                        border: Border.all(
                          color:
                              _paymentFailed
                                  ? isDarkMode
                                      ? Colors.red[700]!
                                      : Colors.red.shade300
                                  : isDarkMode
                                  ? Colors.grey[700]!
                                  : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: AnimatedOpacity(
                        opacity: _dragPosition > 20 ? 0 : 1,
                        duration: const Duration(milliseconds: 150),
                        child: Center(
                          child: Text(
                            'Swipe to pay ₹${widget.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize:
                                  isSmallMobile
                                      ? 12
                                      : isMobile
                                      ? 14
                                      : isTablet
                                      ? 18
                                      : 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  _paymentFailed
                                      ? isDarkMode
                                          ? Colors.red[300]
                                          : Colors.red.shade700
                                      : isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Thumb
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final position = _isProcessing || _paymentSuccess ? _maxDragExtent : _dragPosition;

                        return Positioned(left: position, child: _buildThumb(isSmallMobile, isMobile, isTablet));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThumb(bool isSmallScreen, bool isMobile, bool isTablet) {
    return Container(
      width:
          isSmallScreen
              ? 70
              : isMobile
              ? 80
              : isTablet
              ? 100
              : 80,
      height:
          isSmallScreen
              ? 45
              : isMobile
              ? 50
              : isTablet
              ? 60
              : 52,
      decoration: BoxDecoration(
        gradient:
            _paymentFailed
                ? const LinearGradient(colors: [Colors.red, Colors.redAccent])
                : _paymentSuccess
                ? null
                : const LinearGradient(colors: [Color(0xFFE25B1C), Color(0xFFF18E67)]),
        color: _paymentSuccess ? Colors.green : null,
        borderRadius: BorderRadius.circular(
          isSmallScreen
              ? 22
              : isMobile
              ? 24
              : isTablet
              ? 30
              : 24,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Center(
        child:
            _paymentFailed
                ? Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size:
                      isSmallScreen
                          ? 20
                          : isMobile
                          ? 24
                          : isTablet
                          ? 32
                          : 28,
                )
                : _isProcessing
                ? SizedBox(
                  width:
                      isSmallScreen
                          ? 20
                          : isMobile
                          ? 24
                          : isTablet
                          ? 28
                          : 24,
                  height:
                      isSmallScreen
                          ? 20
                          : isMobile
                          ? 24
                          : isTablet
                          ? 28
                          : 24,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                )
                : _paymentSuccess
                ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size:
                      isSmallScreen
                          ? 20
                          : isMobile
                          ? 24
                          : isTablet
                          ? 32
                          : 28,
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.double_arrow_outlined,
                      color: Colors.white,
                      size:
                          isSmallScreen
                              ? 20
                              : isMobile
                              ? 24
                              : isTablet
                              ? 32
                              : 28,
                    ),
                  ],
                ),
      ),
    );
  }
}
