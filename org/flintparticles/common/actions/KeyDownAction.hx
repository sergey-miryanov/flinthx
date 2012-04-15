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

package org.flintparticles.common.actions;

import nme.display.Stage;
import nme.events.KeyboardEvent;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.actions.Action;
import org.flintparticles.common.actions.KeyDownAction;
import org.flintparticles.common.actions.ActionBase;


/**
 * The KeyDownAction Action uses another action. It applies the other action
 * to the particles only if a specified key is down.
 * 
 * @see org.flintparticles.common.actions.Action
 */

class KeyDownAction extends ActionBase
{
	public var stage(stageGetter,stageSetter):Stage;
	public var action(actionGetter,actionSetter):Action;
	public var priority(priorityGetter,prioritySetter):Int;
	public var keyCode(keyCodeGetter, keyCodeSetter):Int;
	
	private var _action:Action;
	private var _keyCode:Int;
	private var _isDown:Bool;
	private var _stage:Stage;

	/**
	 * The constructor creates a KeyDownAction action for use by 
	 * an emitter. To add a KeyDownAction to all particles created by an emitter, use the
	 * emitter's addAction method.
	 * 
	 * @see org.flintparticles.emitters.Emitter#addAction()
	 * 
	 * @param action The action to apply when the key is down.
	 * @param keyCode The key code of the key that controls the action.
	 * @param stage A reference to the stage.
	 */
	public function new( action:Action= null, keyCode:Int = 0, stage:Stage = null )
	{
		_action = action;
		_keyCode = keyCode;
		_isDown = false;
		_stage = stage;
		createListeners();
	}
	
	private function createListeners():Void
	{
		if( _stage != null )
		{
			//_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener );
			//_stage.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
			_stage.addEventListener( KeyboardEvent.KEY_UP, keyUpListener );
		}
	}
	
	private function keyDownListener( ev:KeyboardEvent ):Void
	{
		if( ev.keyCode == _keyCode )
		{
			_isDown = true;
		}
	}
	private function keyUpListener( ev:KeyboardEvent ):Void
	{
		if( ev.keyCode == _keyCode )
		{
			_isDown = false;
		}
	}

	/**
	 * A reference to the stage
	 */
	public function stageGetter():Stage
	{
		return _stage;
	}
	public function stageSetter( value:Stage ):Stage
	{
		_stage = value;
		createListeners();
		return _stage;
	}
	
	/**
	 * The action to apply when the key is down.
	 */
	public function actionGetter():Action
	{
		return _action;
	}
	public function actionSetter( value:Action ):Void
	{
		_action = value;
		return _action;
	}
	
	/**
	 * The key code of the key that controls the action.
	 */
	public function keyCodeGetter():Int
	{
		return _keyCode;
	}
	public function keyCodeSetter( value:Int ):Void
	{
		_keyCode = value;
		return _keyCode;
	}
	
	/**
	 * Returns the default priority of the action that is applied.
	 * 
	 * @see org.flintparticles.common.actions.Action#getDefaultPriority()
	 */
	override public function priorityGetter():Int
	{
		return _action.priority;
	}
	override public function prioritySetter( value:Int ):Int
	{
		_action.priority = value;
		return value;
	}
	
	/**
	 * Calls the addedToEmitter method of the action that is applied
	 * 
	 * @param emitter The Emitter that the Action was added to.
	 * 
	 * @see org.flintparticles.common.actions.Action#addedToEmitter()
	 */
	override public function addedToEmitter( emitter:Emitter ):Void
	{
		_action.addedToEmitter( emitter );
	}
	
	/**
	 * Calls the removedFromEmitter method of the action that is applied
	 * 
	 * @param emitter The Emitter that the Action was removed from.
	 * 
	 * @see org.flintparticles.common.actions.Action#removedFromEmitter()
	 */
	override public function removedFromEmitter( emitter:Emitter ):Void
	{
		_action.removedFromEmitter( emitter );
	}

	/**
	 * If the key is down, this method calls the update method of the 
	 * action that is applied.
	 * 
	 * <p>This method is called by the emitter and need not be called by the 
	 * user</p>
	 * 
	 * @param emitter The Emitter that created the particle.
	 * @param particle The particle to be updated.
	 * @param time The duration of the frame - used for time based updates.
	 * 
	 * @see org.flintparticles.common.actions.Action#update()
	 */
	override public function update( emitter:Emitter, particle:Particle, time:Float ):Void
	{
		if( _isDown )
		{
			_action.update( emitter, particle, time );
		}
	}
}
