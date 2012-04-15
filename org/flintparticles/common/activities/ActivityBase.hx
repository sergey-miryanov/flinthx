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

package org.flintparticles.common.activities;

import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.activities.ActivityBase;
import org.flintparticles.common.activities.Activity;

/**
 * The ActivityBase class is the abstract base class for all emitter activities
 * in the Flint library. It implements the Activity interface with a default
 * priority of zero and empty methods for the rest of the interface.
 * 
 * <p>Instances of the ActivityBase class should not be directly created 
 * because the ActivityBase class itself simply implements the Activity 
 * interface with default methods that do nothing.</p>
 * 
 * <p>Developers creating custom activities may either extend the ActivityBase
 * class or implement the Activity interface directly. Classes that extend the 
 * ActivityBase class need only to implement their own functionality for the 
 * methods they want to use, leaving other methods with their default empty
 * implementations.</p>
 * 
 * @see org.flintparticles.common.emitters.Emitter#addActivity()
 */
class ActivityBase implements Activity
{
	public var priority(priorityGetter,prioritySetter):Int;
	private var _priority:Int;

	/**
	 * The constructor creates an ActivityBase object. But you shouldn't use it 
	 * directly because the ActivityBase class is abstract.
	 */
	public function new()
	{
		_priority = 0;
	}

	/**
	 * Returns a default priority of 0 for this activity. Derived classes 
	 * override this method if they want a different default priority.
	 * 
	 * @see org.flintparticles.common.actions.Activity#getDefaultPriority()
	 */
	private function priorityGetter():Int
	{
		return _priority;
	}
	private function prioritySetter( value:Int ):Int
	{
		_priority = value;
		return _priority;
	}
	
	/**
	 * This method does nothing. Some derived classes override this method
	 * to perform actions when the activity is added to an emitter.
	 * 
	 * @param emitter The Emitter that the Activity was added to.
	 * 
	 * @see org.flintparticles.common.actions.Activity#addedToEmitter()
	 */
	public function addedToEmitter( emitter:Emitter ):Void
	{
	}
	
	/**
	 * This method does nothing. Some derived classes override this method
	 * to perform actions when the activity is removed from the emitter.
	 * 
	 * @param emitter The Emitter that the Action was removed from.
	 * 
	 * @see org.flintparticles.common.actions.Activity#removedFromEmitter()
	 */
	public function removedFromEmitter( emitter:Emitter ):Void
	{
	}
	
	/**
	 * This method does nothing. Derived classes override this method
	 * to alter the state of the emitter when it starts.
	 * 
	 * @param emitter The Emitter.
	 * 
	 * @see org.flintparticles.common.actions.Activity#initialize()
	 */
	public function initialize( emitter:Emitter ):Void
	{
	}
	
	/**
	 * This method does nothing. Derived classes override this method
	 * to alter the state of the emitter every frame.
	 * 
	 * @param emitter The Emitter.
	 * @param time The duration of the frame - used for time based updates.
	 * 
	 * @see org.flintparticles.common.actions.Activity#update()
	 */
	public function update( emitter:Emitter, time:Float ):Void
	{
	}
}
