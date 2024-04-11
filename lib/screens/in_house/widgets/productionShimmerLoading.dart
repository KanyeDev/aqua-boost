
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/skeleton.dart';

Shimmer productionShimmerLoading(double height, double width){
  return  Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child:  Skeleton(
    height: height,
    width: width,
    radius: 12.49,
  ));
}
