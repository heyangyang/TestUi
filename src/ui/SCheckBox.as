package ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import ui.base.SComponets;

	public class SCheckBox extends SComponets
	{
		private var mLable : SLabel;
		private var mButtonSkin : MovieClip;
		private var mClickFunction : Function;
		private var mSelected : Boolean;

		public function SCheckBox(skin : DisplayObject = null)
		{
			super(skin);
		}

		override public function setSKin(value : DisplayObject) : void
		{
			super.setSKin(value);
			mButtonSkin = value as MovieClip;
			addChildAt(value, 0);
			invalidate();
		}

		override protected function addListenerHandler() : void
		{
			addViewListener(this, MouseEvent.CLICK, onMouseDownHandler);
		}

		private function onMouseDownHandler(evt : MouseEvent) : void
		{
			mSelected = !mSelected;
			invalidate();

		}

		public function set lable(value : String) : void
		{
			if (mLable == null)
			{
				mLable = new SLabel();
				addChild(mLable);
			}
			mLable.text = value;
			invalidate();
		}

		public function get selected() : Boolean
		{
			return mSelected;
		}

		override protected function validate() : void
		{
			if (mButtonSkin == null)
				return;
			mLable.x = mButtonSkin.width + 2;
			mLable.y = (mButtonSkin.height - mLable.height) * .5;
			mButtonSkin.gotoAndStop(mSelected ? 1 : 2);
		}
	}
}