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
import org.flintparticles.common.counters.Steady;
import org.flintparticles.common.displayobjects.RadialDot;
import org.flintparticles.common.initializers.ImageClass;
import org.flintparticles.common.initializers.ScaleImageInit;
import org.flintparticles.twod.actions.DeathZone;
import org.flintparticles.twod.actions.Move;
import org.flintparticles.twod.actions.RandomDrift;
import org.flintparticles.twod.emitters.Emitter2D;
import org.flintparticles.twod.initializers.Position;
import org.flintparticles.twod.initializers.Velocity;
import org.flintparticles.twod.zones.LineZone;
import org.flintparticles.twod.zones.PointZone;
import org.flintparticles.twod.zones.RectangleZone;
import flash.geom.Point;

class Snowfall extends Emitter2D
{

	public function new()
	{
		counter = new Steady(150);
		addInitializer(new ImageClass(RadialDot, [2]));
		addInitializer(new Position(new LineZone(new Point(-5, -5), new Point(605, -5))));
		addInitializer(new Velocity(new PointZone(new Point(0, 65))));
		addInitializer(new ScaleImageInit(0.75, 2));
		addAction(new Move());
		addAction(new DeathZone(new RectangleZone(-10, -10, 620, 420), true));
		addAction(new RandomDrift(20, 20));
	}

}

