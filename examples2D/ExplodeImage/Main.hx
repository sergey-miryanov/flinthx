/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org/
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
import org.flintparticles.common.events.EmitterEvent;
import org.flintparticles.common.particles.Particle;
import org.flintparticles.twod.actions.DeathZone;
import org.flintparticles.twod.actions.Explosion;
import org.flintparticles.twod.actions.Move;
import org.flintparticles.twod.emitters.Emitter2D;
import org.flintparticles.twod.particles.Particle2DUtils;
import org.flintparticles.twod.renderers.DisplayObjectRenderer;
import org.flintparticles.twod.zones.RectangleZone;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

@:meta(SWF(width="500",height="350",frameRate="60",backgroundColor="#000000"))
class Main extends Sprite
{

	var emitter : Emitter2D;
	var bitmap : BitmapData;
	var renderer : DisplayObjectRenderer;
	var explosion : Explosion;
	public function new()
	{
		bitmap = new Image1(384, 255);
		emitter = new Emitter2D();
		emitter.addAction(new DeathZone(new RectangleZone(-5, -5, 505, 355), true));
		emitter.addAction(new Move());
		prepare();
		renderer = new DisplayObjectRenderer();
		addChild(renderer);
		renderer.addEmitter(emitter);
		emitter.start();
		stage.addEventListener(MouseEvent.CLICK, explode, false, 0, true);
		emitter.addEventListener(EmitterEvent.EMITTER_EMPTY, prepare);
	}

	function prepare(event : EmitterEvent = null) : Void
	{
		if(explosion != null) 
		{
			emitter.removeAction(explosion);
			explosion = null;
		}
		var particles : Array<Particle> = Particle2DUtils.createRectangleParticlesFromBitmapData(bitmap, 8, emitter.particleFactory, 56, 47);
		emitter.addParticles(particles, false);
	}

	function explode(ev : MouseEvent) : Void
	{
		if(explosion == null) 
		{
			var p : Point = renderer.globalToLocal(new Point(ev.stageX, ev.stageY));
			explosion = new Explosion(8, p.x, p.y, 500);
			emitter.addAction(explosion);
		}
	}

}

