part of main_class.view;

typedef LodingWrapper = Future<T?> Function<T>(Future<T?> future);
typedef CommandCallback = Function(LodingWrapper loading);

class CommandButton extends StatefulWidget {
  final Widget child;
  final CommandCallback onPressed;
  final EdgeInsetsGeometry padding;
  final ButtonStyle style;

  CommandButton({
    required this.child,
    required this.onPressed,
    this.padding = const EdgeInsets.all(0),
    this.style = const ButtonStyle(),
  });

  @override
  _CommandButtonState createState() => _CommandButtonState();
}

class _CommandButtonState extends State<CommandButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      child: Padding(
        padding: widget.padding,
        child: _buildChild(),
      ),
      onPressed: !_loading ? _act : null,
    );
  }

  _buildChild() {
    ThemeData theme = Theme.of(context);

    return AnimatedCrossFade(
      firstChild: DefaultTextStyle(
        style: (theme.textTheme.labelLarge ?? TextStyle()).copyWith(
          color: theme.textTheme.labelLarge?.color ?? Colors.black,
          fontSize: theme.textTheme.labelLarge?.fontSize ?? 14,
        ),
        child: widget.child,
      ),
      secondChild: _buildLoader(
        color: theme.textTheme.labelLarge?.color ?? Colors.black,
        fontSize: theme.textTheme.labelLarge?.fontSize ?? 14,
      ),
      crossFadeState:
          _loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildLoader({required Color color, required double fontSize}) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SizedBox(
        height: fontSize - 2,
        width: fontSize - 2,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }

  _act() {
    widget.onPressed(_interceptor);
  }

  Future<T?> _interceptor<T>(Future<T?> future) async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        _loading = true;
      });

      return await future;
    } on BusinessException catch (ex) {
      scaffoldMessenger.showSnackBar(Mensagem.error(ex.message));
      rethrow;
      // ignore: unused_catch_clause
    } on AbortException catch (ex) {
      // Ignorado
    } catch (ex, stack) {
      print("[MAIN CLASS] ERRO NÃO TRATADO: " +
          ex.toString() +
          "\n" +
          stack.toString());
      rethrow;
    } finally {
      setState(() {
        _loading = false;
      });
    }
    return future;
  }
}
