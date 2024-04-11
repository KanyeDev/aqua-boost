
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/skeleton.dart';

Shimmer categoryShimmerLoading(){
  return  Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: const Skeleton(
    height: 54.95,
    width: 133.24,
    radius: 12.49,
  ));

}
