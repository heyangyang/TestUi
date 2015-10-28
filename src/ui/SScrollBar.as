package ui
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import ui.base.SComponets;

	/**
	 * 滚动条
	 * @author hyy
	 *
	 */
	public class SScrollBar extends SComponets
	{
		private var mUpBtn : SButton;
		private var mDownBtn : SButton;
		private var mScrollBtn : SButton;
		private var mBgImage : DisplayObject;
		private var mTarget : DisplayObject;
		private var mMask : Shape = new Shape();
		/**
		 * 最大滚动Y
		 */
		private var mMaxScrollY : int;
		private var mMaxBarScrollY : int;
		/**
		 * 百分比
		 */
		protected var mCurrScrollPercent : Number = 0;
		/**
		 * 滚动条y
		 */
		private var mLastDragY : int;
		private var whellDelta : int = 10;

		public function SScrollBar(skin : DisplayObject = null)
		{
			super(skin);
			this.mask = mMask;
			addChildAt(mMask, 0);
		}

		override public function setSKin(value : DisplayObject) : void
		{
			if (value == null)
				return;
			super.setSKin(value);
			var skin : Sprite = mSkin as Sprite;
			mUpBtn = new SButton(value["btn_up"]);
			skin.addChild(mUpBtn);
			mDownBtn = new SButton(value["btn_down"]);
			skin.addChild(mDownBtn);
			mScrollBtn = new SButton(value["btn_bar"]);
			skin.addChild(mScrollBtn);
			mBgImage = value["bg"];
		}

		public function setTarget(taget : DisplayObject) : void
		{
			mTarget = taget;
			addChildAt(mTarget, 1);
			mResize = true;
		}

		override protected function addListenerHandler() : void
		{
			addViewListener(mScrollBtn, MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addViewListener(stage, MouseEvent.MOUSE_UP, onMouseUpHandler);
			addViewListener(this, MouseEvent.ROLL_OVER, onRollOverHandler);
			addViewListener(this, MouseEvent.ROLL_OUT, onRollOutHandler);
		}


		private function onMouseDownHandler(evt : MouseEvent) : void
		{
			addViewListener(this, Event.ENTER_FRAME, onEnterFrame);
			mScrollBtn.startDrag(false, new Rectangle(0, mUpBtn.height, 0, mMaxBarScrollY));
		}

		private function onMouseUpHandler(evt : Event) : void
		{
			mScrollBtn.stopDrag();
		}

		private function onRollOutHandler(evt : Event) : void
		{
			removeViewListener(stage, MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}

		private function onRollOverHandler(evt : MouseEvent) : void
		{
			stage.focus = stage;
			addViewListener(stage, MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}

		private function onEnterFrame(evt : Event) : void
		{
			if (mScrollBtn.y == mLastDragY)
				return;
			mLastDragY = mScrollBtn.y;
			mCurrScrollPercent = (mScrollBtn.y - mUpBtn.height) / mMaxBarScrollY;
			validate();
		}

		protected function onMouseWheelHandler(event : MouseEvent) : void
		{
			mCurrScrollPercent = (mTarget.y + event.delta / 3 * whellDelta) / mMaxScrollY;
			invalidate();
		}

		private function targetChangeHandler() : void
		{
			mMaxScrollY = Math.min(0, mHeight - mTarget.height);
			mScrollBtn.height = mMaxScrollY / mMaxBarScrollY;
			validate();
		}

		override protected function validate() : void
		{
			if (!mSkin)
				return;
			if (mResize)
			{
				mResize = false;
				targetChangeHandler();
				mDownBtn.y = mHeight - mDownBtn.height;
				mBgImage.height = mHeight;
				mSkin.x = mWidth - mSkin.width;
				mMaxBarScrollY = mHeight - mUpBtn.height * 2 - mScrollBtn.height;
				updateMask();
			}
			mCurrScrollPercent = Math.max(0, mCurrScrollPercent);
			mCurrScrollPercent = Math.min(1, mCurrScrollPercent);
			mTarget.y = mCurrScrollPercent * mMaxScrollY;
			mScrollBtn.y = mUpBtn.height + mMaxBarScrollY * mCurrScrollPercent;
		}

		private function updateMask() : void
		{
			mMask.graphics.beginFill(0, 0.1);
			mMask.graphics.drawRect(0, 0, mWidth, mHeight);
			mMask.graphics.endFill();

			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, mWidth, mHeight);
			graphics.endFill();
		}

		/**
		 * 滚轮滚动的距离
		 */
		public function get whellValue() : int
		{
			return whellDelta;
		}

		/**
		 * @private
		 */
		public function set whellValue(value : int) : void
		{
			whellDelta = value;
		}

	}
}