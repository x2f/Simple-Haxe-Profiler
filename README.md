# Simple Haxe Profiler

*Very simple (one class) profiler library.*

### Install

 * Copy Profiler.hx somewhere in your application tree...
 * You may want to update the list of profilers by updating the ProfilerName enum 
 * Voila!
 
### Usage

* Function without arguments:

```haxe
/**
 * Profiler test
 *
 * @author x2f, https://github.com/x2f
 *
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=2.5ms total[500]=10.9ms doThis[500]=2.9ms
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=2.5ms total[500]=10.4ms doThis[500]=2.8ms
 * TestMain.hx:40: PROFILING[ProfilerGameLoop]: doThisAndThat[1000]=5.3ms total[1000]=10.6ms
 * TestMain.hx:40: -------------------
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=3ms total[500]=10.3ms doThis[500]=2.3ms
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=2.8ms total[500]=10.4ms doThis[500]=2.6ms
 * TestMain.hx:40: PROFILING[ProfilerGameLoop]: doThisAndThat[1000]=5.4ms total[1000]=10.4ms
 * TestMain.hx:40: -------------------
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=2.2ms total[500]=10.3ms doThis[500]=2.8ms
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=2.8ms total[500]=10.4ms doThis[500]=2.3ms
 * TestMain.hx:40: PROFILING[ProfilerGameLoop]: doThisAndThat[1000]=5ms total[1000]=10.4ms
 * TestMain.hx:40: -------------------
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=2.4ms total[500]=10.3ms doThis[500]=2.7ms
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=3.5ms total[500]=10.4ms doThis[500]=1.9ms
 * TestMain.hx:40: PROFILING[ProfilerGameLoop]: doThisAndThat[1000]=5.2ms total[1000]=10.3ms
 * TestMain.hx:40: -------------------
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=1.9ms total[500]=10.3ms doThis[500]=3.4ms
 * TestMain.hx:39: PROFILING[ProfilerSimulation]: doThat[500]=2.7ms total[500]=10.4ms doThis[500]=2.5ms
 * TestMain.hx:40: PROFILING[ProfilerGameLoop]: doThisAndThat[1000]=5.2ms total[1000]=10.3ms
 * TestMain.hx:40: -------------------
 *
 */

class TestMain {

  static function main() {
    Profiler.enable(ProfilerGameLoop, true);
    Profiler.enable(ProfilerSimulation, true);
    var k = 0;
    for (i in 0...5000) {
      Profiler.start(ProfilerGameLoop, "total");
      Profiler.start(ProfilerSimulation, "total");
      for (j in 0...100000) {
        k += i + j;
      }
      Profiler.start(ProfilerSimulation, "doThis");
      Profiler.start(ProfilerGameLoop, "doThisAndThat");
      for (j in 0...100000) {
        k += i + j;
      }
      Profiler.stop(ProfilerSimulation, "doThis");
      Profiler.start(ProfilerSimulation, "doThat");
      for (j in 0...100000) {
        k += i + j;
      }
      Profiler.stop(ProfilerSimulation, "doThat");
      Profiler.stop(ProfilerGameLoop, "doThisAndThat");
      for (j in 0...100000) {
        k += i + j;
      }
      Profiler.stop(ProfilerGameLoop, "total");
      Profiler.stop(ProfilerSimulation, "total");
      Profiler.print(ProfilerSimulation, 500, function(str:String) { trace(str);});
      Profiler.print(ProfilerGameLoop, 1000, function(str:String) { trace(str); trace('-------------------'); });
    }
  }
}
```
