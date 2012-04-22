package org.flintparticles.threed.geom;

import nme.geom.Matrix3D;
import nme.geom.Vector3D;
import nme.Vector;

/**
 * Utility methods for working with the Matrix3D class.
 */
class Matrix3DUtils
{
	/**
	 * Creates a new Matrix3D for scaling.
	 * 
	 * @param scaleX The scale factor in the x direction
	 * @param scaleY The scale factor in the y direction
	 * @param scaleZ The scale factor in the z direction
	 * 
	 * @return The new matrix
	 */
	public static function newScale( scaleX:Float, scaleY:Float, scaleZ:Float ):Matrix3D
	{
		var scale:Vector<Float> = new Vector<Float>();
		scale.push(scaleX);
		scale.push(0);
		scale.push(0);
		scale.push(0);
		scale.push(0);
		scale.push(scaleY);
		scale.push(0);
		scale.push(0);
		scale.push(0);
		scale.push(0);
		scale.push(scaleZ);
		scale.push(0);
		scale.push(0);
		scale.push(0);
		scale.push(1);
		//return new Matrix3D( ( [ scaleX,0,0,0,0,scaleY,0,0,0,0,scaleZ,0,0,0,0,1 ] ) );
		return new Matrix3D( scale );
	}
	
	/**
	 * Creates a new Matrix3D for translation.
	 * 
	 * @param x The translation along the x axis.
	 * @param y The translation along the y axis.
	 * @param z The translation along the z axis.
	 * 
	 * @return The new matrix
	 */
	public static function newTranslate( x:Float, y:Float, z:Float ):Matrix3D
	{
		var translate:Vector<Float> = new Vector<Float>();
		translate.push(1);
		translate.push(0);
		translate.push(0);
		translate.push(0);
		translate.push(0);
		translate.push(1);
		translate.push(0);
		translate.push(0);
		translate.push(0);
		translate.push(0);
		translate.push(1);
		translate.push(0);
		translate.push(x);
		translate.push(y);
		translate.push(z);
		translate.push(1);
		//return new Matrix3D( Vector<Float>( [ 1,0,0,0,0,1,0,0,0,0,1,0,x,y,z,1 ] ) );
		return new Matrix3D( translate );
	}

	/**
	 * Creates a new Matrix3D for rotation about an axis.
	 * 
	 * @param angle The angle in radians for the rotation
	 * @param axis The axis to rotate around
	 * @param pivotPoint The point the axis passes through. The default value is the origin.
	 * 
	 * @return The new matrix
	 */
	public static function newRotate( angle:Float, axis:Vector3D, pivotPoint:Vector3D = null ):Matrix3D
	{
		if ( angle == 0 )
		{
			return new Matrix3D();
		}
		var sin:Float = Math.sin( angle );
		var cos:Float = Math.cos( angle );
		var oneMinCos:Float = 1 - cos;
		var rotVec:Vector<Float> = new Vector<Float>();
		rotVec.push(cos + axis.x * axis.x * oneMinCos);
		rotVec.push(axis.x * axis.y * oneMinCos + axis.z * sin);
		rotVec.push(axis.x * axis.z  * oneMinCos - axis.y * sin);
		rotVec.push(0);
		rotVec.push(axis.x * axis.y * oneMinCos - axis.z * sin);
		rotVec.push(cos + axis.y * axis.y * oneMinCos);
		rotVec.push(axis.y * axis.z * oneMinCos + axis.x * sin);
		rotVec.push(0);
		rotVec.push(axis.x * axis.z  * oneMinCos + axis.y * sin);
		rotVec.push(axis.y * axis.z * oneMinCos - axis.x * sin);
		rotVec.push(cos + axis.z * axis.z * oneMinCos);
		rotVec.push(0);
		rotVec.push(0);
		rotVec.push(0);
		rotVec.push(0);
		rotVec.push(1);
		//var rotate:Matrix3D = new Matrix3D( Vector<Float>( [
			//cos + axis.x * axis.x * oneMinCos, axis.x * axis.y * oneMinCos + axis.z * sin, axis.x * axis.z  * oneMinCos - axis.y * sin, 0,
			//axis.x * axis.y * oneMinCos - axis.z * sin, cos + axis.y * axis.y * oneMinCos, axis.y * axis.z * oneMinCos + axis.x * sin, 0,
			//axis.x * axis.z  * oneMinCos + axis.y * sin, axis.y * axis.z * oneMinCos - axis.x * sin, cos + axis.z * axis.z * oneMinCos, 0,
			//0, 0, 0, 1 ] ) );
		var rotate:Matrix3D = new Matrix3D( rotVec );
		if( pivotPoint != null )
		{
			rotate.prependTranslation( -pivotPoint.x, -pivotPoint.y, -pivotPoint.z );
			rotate.appendTranslation( pivotPoint.x, pivotPoint.y, pivotPoint.z );
		}
		return rotate;
	}

	/**
	 * Creates a coordinate system transformation such that the vectors
	 * indicated are transformed to the x, y and z axes. The vectors need
	 * not be perpendicular, but they must form a basis for 3D space.
	 * 
	 * @param axisX The vector that is translated to ( 1, 0, 0 ) by the transform.
	 * @param axisY The vector that is translated to ( 0, 1, 0 ) by the transform.
	 * @param axisZ The vector that is translated to ( 0, 0, 1 ) by the transform.
	 */
	public static function newBasisTransform( axisX:Vector3D, axisY:Vector3D, axisZ:Vector3D ):Matrix3D
	{
		var transVec:Vector<Float> = new Vector<Float>();
		transVec.push(axisX.x);
		transVec.push(axisX.y);
		transVec.push(axisX.z);
		transVec.push(0);
		transVec.push(axisY.x);
		transVec.push(axisY.y);
		transVec.push(axisY.z);
		transVec.push(0);
		transVec.push(axisZ.x);
		transVec.push(axisZ.y);
		transVec.push(axisZ.z);
		transVec.push(0);
		transVec.push(0);
		transVec.push(0);
		transVec.push(0);
		transVec.push(1);
		//var m:Matrix3D = new Matrix3D( Vector<Float>( [
			//axisX.x, axisX.y, axisX.z, 0,
			//axisY.x, axisY.y, axisY.z, 0,
			//axisZ.x, axisZ.y, axisZ.z, 0,
			//0, 0, 0, 1 ] ) );
		var m:Matrix3D = new Matrix3D( transVec );
		m.invert();
		return m;
	}
}
