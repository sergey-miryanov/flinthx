/*;
* FLINT PARTICLE SYSTEM;
* .....................;
* ;
* Author: Richard Lord;
* Copyright (c) Richard Lord 2008-2011;
* http://flintparticles.org
* ;
* ;
* Licence Agreement;
* ;
* Permission is hereby granted, free of charge, to any person obtaining a copy;
* of this software and associated documentation files (the "Software"), to deal;
* in the Software without restriction, including without limitation the rights;
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell;
* copies of the Software, and to permit persons to whom the Software is;
* furnished to do so, subject to the following conditions:
* ;
* The above copyright notice and this permission notice shall be included in;
* all copies or substantial portions of the Software.;
* ;
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR;
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,;
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE;
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER;
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,;
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN;
* THE SOFTWARE.;
*/

package org.flintparticles.twod.renderers;

import nme.events.Event;
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.events.EmitterEvent;
import org.flintparticles.common.renderers.SpriteRendererBase;
import org.flintparticles.twod.particles.Particle2D;


/**
 * The VectorLineRenderer draws particles as continuous lines mapping the 
 * path the particle travels. This is useful for effects like hair and
 * grass.
 * 
 * <p>The VectorLineRenderer uses the color and alpha of the particle
 * for the color of the current line segment, and uses the scale of
 * the particle for the line width.</p>
 * 
 * <p>If you don't want users to see the lines growing, the runAhead 
 * method of the emitter can be used to jump straight to the final image.</p>
 * 
 * @see org.flintparticles.common.emitters.Emitter#runAhead()
 */
class VectorLineRenderer extends SpriteRendererBase
{
	/**
	 * The constructor creates a VectorLineRenderer. After creation it should
	 * be added to the display list of a DisplayObjectContainer to place it on 
	 * the stage and should be applied to an Emitter using the Emitter's
	 * renderer property.
	 * 
	 * @see org.flintparticles.twoD.emitters.Emitter#renderer
	 */
	public function new()
	{
		super();
	}
	
	/**
	 * @inheritDoc
	 */
	override private function renderParticles( particles:Array<Dynamic> ):Void
	{
		var particle:Particle2D = null;
		var len:Int = particles.length;
		//for( var i:Int = 0; i < len; ++i )
		for( i in 0 ... len )
		{
			particle = cast( particles[i],Particle2D );
			graphics.lineStyle( particle.scale, particle.color & 0xFFFFFF, particle.color >>> 24 );
			graphics.moveTo( particle.previousX, particle.previousY );
			graphics.lineTo( particle.x, particle.y );
		}
	}

	override private function emitterUpdated( ev:EmitterEvent ):Void
	{
		renderParticles( cast( ev.target,Emitter ).particlesArray );
	}
	override private function updateParticles( ev:Event ):Void
	{
	}
}
