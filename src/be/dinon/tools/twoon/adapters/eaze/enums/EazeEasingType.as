package be.dinon.tools.twoon.adapters.eaze.enums
{
	import be.dinon.tools.twoon.enums.TwoonEasingType;

	public class EazeEasingType extends TwoonEasingType
	{
		public static const QUADRATIC:TwoonEasingType = new EazeEasingType("Quadratic");
		
		public function EazeEasingType(name:String)
		{
			super(name);
		}
	}
}