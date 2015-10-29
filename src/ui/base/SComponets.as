package ui.base
{
	import flash.display.DisplayObject;

	import ui.core.SUiSkinManager;
	import ui.core.SViewControl;
	import ui.namespaces.self;


	public class SComponets extends ViewBase
	{
		protected var mSkin : DisplayObject;
		protected var mWidth : Number;
		protected var mHeight : Number;
		/**
		 *  重置大小
		 */
		protected var mResize : Boolean;

		public function SComponets(skin : DisplayObject = null)
		{
			super();
			setSKin(skin);
		}

		public function setSKin(value : DisplayObject) : void
		{
			if (mSkin == value)
				return;
			mSkin = value;
			addChild(mSkin);
			invalidate();
		}

		public function invalidate() : void
		{
			SViewControl.getInstance().addControl(this);
		}

		/**
		 * 设置大小
		 * @param w
		 * @param h
		 *
		 */
		public function setSize(w : int, h : int) : void
		{
			mResize = true;
			mWidth = w;
			mHeight = h;
			invalidate();
		}

		self function onEnterFrame() : void
		{
			if (mSkin == null)
				setSKin(SUiSkinManager.getInstance().getBindSkin(this["constructor"]));
			validate();
		}

		protected function validate() : void
		{

		}

		public function move(tx : int, ty : int) : void
		{
			x = tx;
			y = ty;
		}

		override public function get width() : Number
		{
			if (isNaN(mWidth))
				return super.width;
			return mWidth;
		}

		override public function get height() : Number
		{
			if (isNaN(mHeight))
				return super.height;
			return mHeight;
		}

		override public function dispose() : void
		{
			super.dispose();
			mSkin = null;
		}
	}
}