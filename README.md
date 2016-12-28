# ClosestPointWorkshop

This project explores four solution types to the Closest Points problem. The project is written in Swift for macOS. The project is configured to target El Capitan or higher.

Four solution types are explored:

1. Permutation Search - A purely naive matching of all permutations with ordering (even though ordering doesn't really matter). This solution is the easiest to test-drive without knowing any algorithm. The permutation search is O(n!).
2. Combination Search - A better naive matching of all combination regardless of ordering. This solution can be test-driven, provided the developer observes that the checking of points does not depend on order. The combination search is O(n!)/2 (i.e., "n choose 2").
3. Plane Sweep - An efficient matching of points where the points are ordered by their x position and then the plane is swept, looking for best matches in a sliding window whose size is based on the best match found so far. This solution can be test-driven provided the developer has worked out the algorithm a priori (i.e., the critical operations of the algorithm are test-driven, and then the integration of those operations is test-driven). This method is O(n log n).
4. Divide and Conquer - An efficient matching of points where the points are ordered by their x position and then recursively bisected into smaller regions until the point set is sufficiently small to easily search. This solution can be test-driven provided the developer has worked out the algorithm a priori (i.e., the critical operations of the algorithm are test-driven, and then the integration of those operations is test-driven). This method is O(n log n).
