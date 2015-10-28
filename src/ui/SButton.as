package ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import ui.base.SComponets;
	import ui.core.SUiConfig;

	public class SButton extends SComponets
	{
		private static const UP : int = 0;
		private static const DOWN : int = 1;
		protected var mLable : SLabel;
		protected var mButtonSkin : MovieClip;
		protected var mClickFunction : Function;
		protected var mSelected : Boolean;
		private var mFrameIndex : int;

		public function SButton(skin : DisplayObject = null)
		{
			super(skin);
		}

		override protected function init() : void
		{

		}

		override protected function addListenerHandler() : void
		{
			addViewListener(this, MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addViewListener(this, MouseEvent.MOUSE_UP, onMouseUpHandler);
			addViewListener(this, MouseEvent.ROLL_OVER, onMouseOverHandler);
			addViewListener(this, MouseEvent.ROLL_OUT, onMouseOutHandler);
		}

		override public function setSKin(value : DisplayObject) : void
		{
			if (value == null)
				return;
			super.setSKin(value);
			mButtonSkin = value as MovieClip;
			addChildAt(value, 0);
		}

		private function onMouseDownHandler(evt : MouseEvent) : void
		{
			mFrameIndex = DOWN;
			invalidate();
		}

		private function onMouseUpHandler(evt : MouseEvent) : void
		{
			mFrameIndex = UP;
			invalidate();
			mClickFunction != null && mClickFunction(this);
		}

		private function onMouseOverHandler(evt : MouseEvent) : void
		{
			SUiConfig.highLight(this);
		}

		private function onMouseOutHandler(evt : MouseEvent) : void
		{
			SUiConfig.reSet(this);
		}

		/**
		 * 单击处理函数
		 * @param value
		 *
		 */
		public function setClickHandler(value : Function) : void
		{
			mClickFunction = value;
		}

		public function set lable(value : String) : void
		{
			if (mLable == null)
			{
				mLable = new SLabel();
				addChild(mLable);
			}
			mLable.text = value;
		}

		public function get lable() : String
		{
			if (mLable == null)
				return "";
			return mLable.text;
		}

		override public function dispose() : void
		{
			super.dispose();
			mClickFunction = null;
			mButtonSkin = null;
			mLable = null;
		}

		public function get selected() : Boolean
		{
			return mSelected;
		}

		public function set selected(value : Boolean) : void
		{
			if (mSelected == value)
				return;
			mSelected = value;
			invalidate();
		}

		override protected function validate() : void
		{
			if (!mButtonSkin)
				return;
			if (mSelected)
				mButtonSkin.gotoAndStop(3);
			else
				mButtonSkin.gotoAndStop(mFrameIndex);
		}
	}
}