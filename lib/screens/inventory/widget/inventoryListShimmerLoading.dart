
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/skeleton.dart';

Shimmer inventoryListShimmer(double height){
  return  Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child:  Skeleton(
    height: height,
    width: 500,
    radius: 12.49,
  ));

}
