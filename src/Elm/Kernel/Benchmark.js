/*
import Elm.Kernel.Scheduler exposing (binding, succeed, fail)
import Benchmark.LowLevel as BL exposing (StackOverflow, UnknownError)
*/

var _Benchmark_getTimestamp =
  typeof performance !== "undefined"
    ? performance.now.bind(performance)
    : Date.now;

// sample : Int -> Operation -> Task Error Float
var _Benchmark_sample = F2(function(n, fn) {
  return __Scheduler_binding(function(callback) {
    var start = _Benchmark_getTimestamp();

    try {
      for (var i = 0; i < n; i++) {
        fn();
      }
    } catch (error) {
      if (error instanceof RangeError) {
        callback(__Scheduler_fail(
          __BL_StackOverflow
        ));
      } else {
        callback(__Scheduler_fail(
          __BL_UnknownError(error.message)
        ));
      }
      return;
    }

    var end = _Benchmark_getTimestamp();

    callback(__Scheduler_succeed(end - start));
  });
});

// operation : (() -> a) -> Operation
function _Benchmark_operation(thunk) {
  return thunk;
}
