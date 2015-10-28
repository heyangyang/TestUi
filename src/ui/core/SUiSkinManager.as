package ui.core
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import ui.base.SComponets;
	import ui.SLabel;

	public class SUiSkinManager
	{
		private static var instance : SUiSkinManager;

		public static function getInstance() : SUiSkinManager
		{
			if (!instance)
			{
				instance = new SUiSkinManager();
				instance.init();
			}
			return instance;
		}
		private var mDictionary : Dictionary = new Dictionary();

		public function init() : void
		{
			bindSkin(SLabel, SComponets);
		}

		public function bindSkin(uiClass : Class, skinClass : Class) : void
		{
			mDictionary[uiClass] = skinClass;
		}

		public function getBindSkin(uiClass : Class) : DisplayObject
		{
			var skinClass : Class = mDictionary[uiClass];
			if (skinClass == null)
				return null
			return new skinClass();
		}
	}
}