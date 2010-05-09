package be.dinon.tools.twoon.adapters.eaze
{
	import aze.motion.EazeTween;
	import aze.motion.easing.Cubic;
	import aze.motion.eaze;
	
	import be.dinon.tools.twoon.adapters.TwoonAdapter;
	import be.dinon.tools.twoon.adapters.TwoonAdapterAbstract;
	import be.dinon.tools.twoon.adapters.eaze.enums.EazeEasingType;
	import be.dinon.tools.twoon.enums.TwoonEasingMovement;
	import be.dinon.tools.twoon.enums.TwoonEasingType;
	import be.dinon.tools.twoon.enums.TwoonFromToType;
	import be.dinon.tools.twoon.vos.TwoonValue;
	
	import flash.utils.getDefinitionByName;
	
	import mx.rpc.CallResponder;
	
	import org.flexunit.utils.ClassNameUtil;
	
	public class EazeAdapter extends TwoonAdapterAbstract implements TwoonAdapter
	{
		private var tween:EazeTween;
		
		override public function EazeAdapter()
		{
			// this : for fake abstract impl
			super(this);
		}
		
		override public function start():void 
		{
			super.start();
			
			tween = eaze(target);
			
			// delay
			if (!isNaN(delay)) tween.delay(getDelayInSeconds());

			// from / to
			var fromValues:Array = getFromValues();
			var toValues:Array = getToValues();
			if (fromValues.length > 0)
			{
				var newState:Object = getVarsObject(TwoonFromToType.FROM);
				tween.from(getDurationInSeconds(), newState);
				tween.apply(newState);
			}
			if (toValues.length > 0)
			{
				tween.to(getDurationInSeconds(), getVarsObject(TwoonFromToType.TO));
			}
			
			// easing
			if (easing != null) tween.easing(Cubic.easeInOut);//getEasing(easing, movement));
			
			// onUpdate
			if (updateHandler != null) tween.onUpdate(updateHandler, updateParams);
		}
		
		override protected function getVarsObject(direction:TwoonFromToType = null):Object
		{
			var res:Object = super.getVarsObject(direction);
			var value:TwoonValue;
			switch(direction)
			{
				case TwoonFromToType.FROM:
					var fromValues:Array = getFromValues();
					if (fromValues.length > 0)
					{
						for each(value in fromValues)
						{
							res[value.property.name] = value.fromValue;
						}
					}
					break;
				
				case TwoonFromToType.TO:
					var toValues:Array = getToValues();
					if (toValues.length > 0)
					{
						for each(value in toValues)
						{
							res[value.property.name] = value.toValue;
						}
					}
					break;
			}
			return res;
		}
		
		protected function getEasing(type:TwoonEasingType, movement:TwoonEasingMovement=null):Function
		{
			if (type == null) type = TwoonEasingType.CUBIC;
			if (type == TwoonEasingType.QUAD) type = EazeEasingType.QUADRATIC;
			if (movement == null) movement = TwoonEasingMovement.OUT;
			
			var className:String = type.name;
			
			var functionName:String = movement.name;
			
			var definition:String = "aze.motion.easing." + className; // + "." + functionName;
			
			var easingClass:Class = getDefinitionByName(definition) as Class;
			
			var func:Function = easingClass[functionName] as Function;
			
			return func;
		}
	}
}