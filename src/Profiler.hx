/**
 * a Small Profiler Class
 *
 * @author x2f, https://github.com/x2f
 *  
 *  The MIT License (MIT)
 * 
 * Copyright (c) 2016 x2f, https://github.com/x2f
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * 
 *
 * USAGE:
 * ------
 *
 * // Enable a profiler
 * Profiler.enable(ProfilerGameLoop, true);
 *
 * // In the game loop, measure time with:
 * Profiler.start(ProfilerGameLoop, "SomeLabel1");
 * ...
 * Profiler.start(ProfilerGameLoop, "SomeLabel2");
 * ...
 * Profiler.stop(ProfilerGameLoop, "SomeLabel2");
 * ...
 * Profiler.stop(ProfilerGameLoop, "SomeLabel1");
 * ...
 * Profiler.print(ProfilerGameLoop, 100, function(str:String) {trace(str);});
 *
 * // This will print the following every 100 call of the 'print' method:
 * // PROFILING[ProfilerGameLoop]: SomeLabel1[100]=2.7ms SomeLabel2[100]=12.5ms
 *
 */

enum ProfilerName {
  ProfilerGameLoop;
  ProfilerSimulation;
}

/** A simple profiler utility class */
class Profiler {

  private static var profiling = new Map<ProfilerName,Map<String, Array<Float>>>();
  private static var profilingStart = new Map<ProfilerName,Map<String, Float>>();
  private static var currentNumIterations = new Map<ProfilerName, Int>();
  private static var profilingEnabled = new Map<ProfilerName, Bool>();

  /** enable or disable a particular profiler */
  static public function enable(profiler:ProfilerName, enable:Bool) {
    if (enable) {
      if (!profiling.exists(profiler)) {
        profiling[profiler] = new Map<String, Array<Float>>();
        profilingStart[profiler] = new Map<String, Float>();
        currentNumIterations[profiler] = 0;
      }
      profilingEnabled[profiler] = true;
    } else {
      if (profiling.exists(profiler)) {
        profiling.remove(profiler);
        profilingStart.remove(profiler);
        currentNumIterations.remove(profiler);
      }
      profilingEnabled[profiler] = false;
    }
  }

  /** start the timer 'label' for a given profiler */
  static public function start(profiler:ProfilerName, label:String) {
    if (!profilingEnabled[profiler]) return;
    var start = haxe.Timer.stamp();
    profilingStart[profiler][label] = start;
  }

  /** stop the timer 'label' for a given profiler, and record the (stop-start) time delta */
  static public function stop(profiler:ProfilerName, label:String) {
    if (!profilingEnabled[profiler]) return;
    if ( (!profilingStart[profiler].exists(label)) || (profilingStart[profiler][label] == 0.0) ) return;
    var stop = haxe.Timer.stamp();
    var delta = stop - profilingStart[profiler][label];
    if (!profiling[profiler].exists(label)) profiling[profiler][label] = new Array<Float>();
    profiling[profiler][label].push(delta);
    profilingStart[profiler][label] = 0.0;
  }

  /** print profiling information every 'numIterations' times this function is called. Use the 'logger' function to do that. */
  static public function print(profiler:ProfilerName, numIterations:Int, logger:String->Void) {
    if (!profilingEnabled[profiler]) return;
    currentNumIterations[profiler] += 1;
    if (currentNumIterations[profiler] >= numIterations) {
      var keys = profiling[profiler].keys();
      var str = 'PROFILING[$profiler]: ';
      for (k in keys) {
        var num = profiling[profiler][k].length;
        var sum = Lambda.fold(profiling[profiler][k], function(n,total) {return total += n;} , 0);
        var avg = Math.round(1000.0 * 10.0 * sum / num) / 10.0;
        str += '$k[$num]=${avg}ms ';
      }
      logger(str);
      profiling[profiler] = new Map<String, Array<Float>>();
      currentNumIterations[profiler] = 0;
    }
  }
}
