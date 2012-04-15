/*
* FLINT PARTICLE SYSTEM
* .....................
* 
* Author: Richard Lord
* Copyright (c) Richard Lord 2008-2011
* http://flintparticles.org
* 
* 
* Licence Agreement
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

package org.flintparticles.common.counters;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.counters.Counter;
import org.flintparticles.common.counters.Blast;

/**
 * The Blast counter causes the emitter to create a single burst of
 * particles when it starts and then emit no further particles.
 * It is used, for example, to simulate an explosion.
 */
class Blast implements Counter
{
	public var running(runningGetter,null):Bool;
	public var startCount(startCountGetter,startCountSetter):Float;
	public var complete(completeGetter, null):Bool;
	
	private var _startCount:Int;
	private var _done:Bool;
	
	/**
	 * The constructor creates a Blast counter for use by an emitter. To
	 * add a Blast counter to an emitter use the emitter's counter property.
	 * 
	 * @param startCount The number of particles to emit
	 * when the emitter starts.
	 * 
	 * @see org.flintparticles.common.emitter.Emitter.counter
	 */
	public function new( startCount:Int = 0 )
	{
		_done = false;
		_startCount = startCount;
	}
			
	/**
	 * The number of particles to emit when the emitter starts.
	 */
	public function startCountGetter():Float
	{
		return _startCount;
	}
	public function startCountSetter( value:Float ):Float
	{
		_startCount = Std.int(value);
		return _startCount;
	}
	
	/**
	 * Does nothing. Since the blast counter emits a single blast and then
	 * stops, stopping it changes nothing.
	 */
	public function stop():Void
	{
	}
	
	/**
	 * Does nothing. Since the blast counter emits a single blast and then
	 * stops, stopping and resuming it changes nothing.
	 */
	public function resume():Void
	{
	}
	
	/**
	 * Initilizes the counter. Returns startCount to indicate that the emitter 
	 * should emit that many particles when it starts.
	 * 
	 * <p>This method is called within the emitter's start method 
	 * and need not be called by the user.</p>
	 * 
	 * @param emitter The emitter.
	 * @return the value of startCount.
	 * 
	 * @see org.flintparticles.common.counters.Counter#startEmitter()
	 */
	public function startEmitter( emitter:Emitter ):Int
	{
		_done = true;
		emitter.dispatchCounterComplete();
		return _startCount;
	}
	
	/**
	 * Returns 0 to indicate that no particles should be emitted after the 
	 * initial blast.
	 * 
	 * <p>This method is called within the emitter's update loop and need not
	 * be called by the user.</p>
	 * 
	 * @param emitter The emitter.
	 * @param time The time, in seconds, since the previous call to this method.
	 * @return 0
	 * 
	 * @see org.flintparticles.common.counters.Counter#updateEmitter()
	 */
	public function updateEmitter( emitter:Emitter, time:Float ):Int
	{
		return 0;
	}
	
	/**
	 * Indicates if the counter has emitted all its particles.
	 */
	public function completeGetter():Bool
	{
		return _done;
	}
	
	/**
	 * Indicates if the counter is currently emitting particles
	 */
	public function runningGetter():Bool
	{
		return false;
	}
}
