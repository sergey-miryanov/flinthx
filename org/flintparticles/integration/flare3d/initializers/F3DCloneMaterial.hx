package org.flintparticles.integration.flare3d.initializers;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.integration.flare3d.initializers.F3DCloneMaterial;
	import org.flintparticles.common.initializers.InitializerBase;


	/**
	 * @author Richard
	 */
	class F3DCloneMaterial extends InitializerBase
	{
		public var material(materialGetter,null):Material3D;
		private var _material : Material3D;

		public function new( material : Material3D )
		{
			_material = material;
			_priority = -10;
		}
		
		public function materialGetter() : Material3D
		{
			return _material;
		}
		
		public function set material( value:Material3D ):Void
		{
			_material = material;
		}
		
		override public function initialize( emitter:Emitter, particle:Particle ) : Void
		{
			if( particle.image && particle.image is Pivot3D )
			{
				Pivot3D( particle.image ).setMaterial( _material.clone() );
			}
		}
	}
