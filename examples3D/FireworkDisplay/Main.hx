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
import org.flintparticles.common.emitters.Emitter;
import org.flintparticles.common.events.EmitterEvent;
import org.flintparticles.common.events.ParticleEvent;
import org.flintparticles.threed.emitters.Emitter3D;
import org.flintparticles.threed.particles.Particle3D;
import org.flintparticles.threed.renderers.BitmapRenderer;
import org.flintparticles.threed.renderers.controllers.FirstPersonCamera;
import org.flintparticles.threed.zones.LineZone;
import flash.display.Sprite;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

@:meta(SWF(width="800",height="600",frameRate="60",backgroundColor="#000000"))
class Main extends Sprite
{

	var orbitter : FirstPersonCamera;
	var renderer : BitmapRenderer;
	public function new()
	{
		renderer = new BitmapRenderer(new Rectangle(-400, -300, 800, 600), false);
		renderer.x = 400;
		renderer.y = 300;
		renderer.addFilter(new BlurFilter(2, 2, 1));
		renderer.addFilter(new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.95, 0]));
		addChild(renderer);
		renderer.camera.position = new Vector3D(0, -150, -400);
		renderer.camera.target = new Vector3D(0, -150, 0);
		renderer.camera.projectionDistance = 400;
		orbitter = new FirstPersonCamera(stage, renderer.camera);
		orbitter.start();
		var emitter : Emitter3D = new Whizzer(new LineZone(new Vector3D(-200, 0, 0), new Vector3D(200, 0, 0)));
		renderer.addEmitter(emitter);
		emitter.addEventListener(ParticleEvent.PARTICLE_DEAD, whizzBang, false, 0, true);
		emitter.start();
		emitter = new Candle(new Vector3D(150, 0, 150));
		renderer.addEmitter(emitter);
		emitter.start();
		emitter = new Candle(new Vector3D(-150, 0, 150));
		renderer.addEmitter(emitter);
		emitter.start();
		emitter = new Candle(new Vector3D(150, 0, -150));
		renderer.addEmitter(emitter);
		emitter.start();
		emitter = new Candle(new Vector3D(-150, 0, -150));
		renderer.addEmitter(emitter);
		emitter.start();
		emitter = new CatherineWheel(new Vector3D(-200, -200, 50));
		renderer.addEmitter(emitter);
		emitter.start();
		emitter = new CatherineWheel(new Vector3D(0, -200, 50));
		renderer.addEmitter(emitter);
		emitter.start();
		emitter = new CatherineWheel(new Vector3D(200, -200, 50));
		renderer.addEmitter(emitter);
		emitter.start();
	}

	public function whizzBang(ev : ParticleEvent) : Void
	{
		var bang : Emitter3D = new SphereBang(cast((ev.particle), Particle3D).position);
		bang.addEventListener(EmitterEvent.EMITTER_EMPTY, removeEmitter, false, 0, true);
		renderer.addEmitter(bang);
		bang.start();
	}

	public function removeEmitter(ev : EmitterEvent) : Void
	{
		cast((ev.target), Emitter3D).removeEventListener(EmitterEvent.EMITTER_EMPTY, removeEmitter);
		renderer.removeEmitter(cast((ev.target), Emitter3D));
	}

	public function destroy() : Void
	{
		for(e in renderer.emitters/* AS3HX WARNING could not determine type for var: e exp: EField(EIdent(renderer),emitters) type: null*/)
		{
			e.stop();
		}

	}

}

