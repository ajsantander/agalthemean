package com.li.agalthemean.ui.views.renderview
{

	import com.li.minimole.core.Mesh;
	import com.li.minimole.materials.agal.AGALAdvancedPhongBitmapMaterial;
	import com.li.minimole.materials.agal.AGALBitmapMaterial;
	import com.li.minimole.materials.agal.AGALColorMaterial;
	import com.li.minimole.materials.agal.AGALEnviroSphericalMaterial;
	import com.li.minimole.materials.agal.AGALMaterial;
	import com.li.minimole.materials.agal.AGALPhongBitmapMaterial;
	import com.li.minimole.materials.agal.AGALPhongColorMaterial;
	import com.li.minimole.materials.agal.AGALVertexColorMaterial;
	import com.li.minimole.materials.agal.AGALWireframeMaterial;
	import com.li.minimole.materials.agal.mappings.RegisterMapping;
	import com.li.minimole.materials.agal.registers.constants.RegisterConstant;
	import com.li.minimole.materials.agal.registers.constants.VectorRegisterConstant;
	import com.li.minimole.materials.agal.registers.attributes.VertexAttribute;
	import com.li.minimole.parsers.ObjParser;
	import com.li.minimole.primitives.CubeR;
	import com.li.minimole.primitives.Plane;
	import com.li.minimole.primitives.Sphere;
	import com.li.minimole.primitives.Torus;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	import org.osflash.signals.Signal;

	public class DefaultAssetStore
	{
		// texture
		[Embed(source="../../../../../../../assets/head/Map-COL.jpg")]
		private var HeadTexture:Class;

		// normal map
		[Embed(source="../../../../../../../assets/head/Infinite-Level_02_World_SmoothUV.jpg")]
		private var HeadNormals:Class;

		// specular map
		[Embed(source="../../../../../../../assets/head/Map-spec.jpg")]
		private var HeadSpecular:Class;

		// cube map
		[Embed(source="../../../../../../../assets/cubemap_brightday1/brightday1_negative_x.png")]
		private var CubeNegX:Class;
		/*[Embed(source="../../../../../../../assets/cubemap_brightday1/brightday1_negative_y.png")]
		private var CubeNegY:Class;
		[Embed(source="../../../../../../../assets/cubemap_brightday1/brightday1_negative_z.png")]
		private var CubeNegZ:Class;
		[Embed(source="../../../../../../../assets/cubemap_brightday1/brightday1_positive_x.png")]
		private var CubePosX:Class;
		[Embed(source="../../../../../../../assets/cubemap_brightday1/brightday1_positive_y.png")]
		private var CubePosY:Class;
		[Embed(source="../../../../../../../assets/cubemap_brightday1/brightday1_positive_z.png")]
		private var CubePosZ:Class;*/

		// model
		[Embed (source="../../../../../../../assets/head/head.obj", mimeType="application/octet-stream")]
		private var HeadModel:Class;

		public var headTexture:BitmapData;
		public var headNormals:BitmapData;
		public var headSpecular:BitmapData;
		public var cubeNegX:BitmapData;
//		public var cubeNegY:BitmapData;
//		public var cubeNegZ:BitmapData;
//		public var cubePosX:BitmapData;
//		public var cubePosY:BitmapData;
//		public var cubePosZ:BitmapData;

		private var _material:AGALMaterial;
		private var _model:Mesh;

		private static var _instance:DefaultAssetStore;

		public var materialRequestedSignal:Signal;
		public var modelRequestedSignal:Signal;

		public function DefaultAssetStore() {

			headTexture = new HeadTexture().bitmapData;
			headNormals = new HeadNormals().bitmapData;
			headSpecular = new HeadSpecular().bitmapData;
			cubeNegX = new CubeNegX().bitmapData;
//			cubeNegY = new CubeNegY().bitmapData;
//			cubeNegZ = new CubeNegZ().bitmapData;
//			cubePosX = new CubePosX().bitmapData;
//			cubePosY = new CubePosY().bitmapData;
//			cubePosZ = new CubePosZ().bitmapData;

			materialRequestedSignal = new Signal( AGALMaterial );
			modelRequestedSignal = new Signal( Mesh );

			_model = new CubeR( null );

			// -----------------------
			// -----------------------
			// -----------------------
			setTimeout( function():void {

				getVertexColorMaterial();
				getAdvancedPhongBitmapMaterial();
//				getPhongColorMaterial();
//				getEnviroSphericalMaterial();

				getHeadModel();

			}, 200 );
			// -----------------------
			// -----------------------
			// -----------------------
		}

		public static function get instance():DefaultAssetStore {
			if( !_instance )
				_instance = new DefaultAssetStore();
			return _instance;
		}

		// ---------------------------------------------------------------------
		// Models
		// ---------------------------------------------------------------------

		public function getLoadedModel( modelData:ByteArray ):Mesh {
			_model = new ObjParser( modelData, _material, 0.2 );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getHeadModel():Mesh {
			_model = new ObjParser( HeadModel, _material, 0.2 );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getCubeModel():Mesh {
			_model = new CubeR( _material );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getSphereModel():Mesh {
			_model = new Sphere( _material, 1, 32, 24 );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getTorusModel():Mesh {
			_model = new Torus( _material, 0.8, 0.3 );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		public function getPlaneModel():Mesh {
			_model = new Plane( _material );
			modelRequestedSignal.dispatch( _model );
			return _model;
		}

		// ---------------------------------------------------------------------
		// Shaders
		// ---------------------------------------------------------------------

		public function getExploderMaterial():AGALMaterial {
			_material = new AGALAdvancedPhongBitmapMaterial( headTexture, headNormals, headSpecular );
			_material.addVertexAttribute( new VertexAttribute( "vertexNormals", VertexAttribute.NORMALS ) );
			var exploder:RegisterConstant = _material.addVertexConstant( new VectorRegisterConstant( "exploder", 0, 0, 0, 0, new RegisterMapping( RegisterMapping.OSCILLATOR_MAPPING ) ) );
			var smallRange:Point = new Point( 0, 0.05 );
			VectorRegisterConstant( exploder ).setComponentRanges( smallRange, smallRange, smallRange, smallRange );
			_material.vertexAGAL = "" +
					"m44 vt0, va0, vc4 // calculate vertex positions in scene space\n" +
					"mul vt1, va2.xyz, vc10.y // read normal and scale with exploder\n" +
					"add vt0.xyz, vt0.xyz, vt1.xyz // displace vertex in normal dir\n" +
					"sub v0, vc8, vt0 // interpolate direction to light\n" +
					"sub v1, vc9, vt0 // interpolate direction to camera\n" +
					"mov v2, va1 // interpolate uvs\n" +
					"m44 op, vt0, vc0 // output position to clip space";
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getWireframeMaterial():AGALMaterial {
			_material = new AGALWireframeMaterial( 0xFF0000, 0xCCCCCC );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getVertexColorMaterial():AGALMaterial {
			_material = new AGALVertexColorMaterial();
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getEnviroSphericalMaterial():AGALMaterial {
			_material = new AGALEnviroSphericalMaterial( cubeNegX );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getSimplestMaterial():AGALMaterial {
			_material = new AGALColorMaterial();
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getPhongColorMaterial():AGALMaterial {
			_material = new AGALPhongColorMaterial();
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getAdvancedPhongBitmapMaterial():AGALMaterial {
			_material = new AGALAdvancedPhongBitmapMaterial( headTexture, headNormals, headSpecular );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getBasicPhongBitmapMaterial():AGALMaterial {
			_material = new AGALPhongBitmapMaterial( headTexture );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getBitmapMaterial():AGALMaterial {
			_material = new AGALBitmapMaterial( headTexture );
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}

		public function getEmptyMaterial():AGALMaterial {
			_material = new AGALMaterial();
			_model.material = _material;
			materialRequestedSignal.dispatch( _material );
			return _material;
		}
	}
}
