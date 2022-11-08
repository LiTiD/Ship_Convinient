import 'package:flutter/material.dart';
import '../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 8,
                child: Image.asset("assets/images/signup.jpg"),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
