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
	public class SScroller extends SComponets
	{
		public static const SCROLL_POLICY_ON : String = "on";
		public static const SCROLL_POLICY_OFF : String = "off";
		public static const CHANGE : String = "scroll_change";
		/**
		 * 按钮的大小
		 */
		private var mBtnSize : int;
		private var mUpBtn : SButton;
		private var mDownBtn : SButton;
		private var mScrollBtn : SButton;
		private var mBgImage : DisplayObject;
		private var mTarget : DisplayObject;
		private var mMask : Shape = new Shape();
		/**
		 * 最大滚动
		 */
		private var mMaxScroll : int;
		private var mMaxBarScroll : int;
		/**
		 * 百分比
		 */
		protected var mCurrScrollPercent : Number = 0;
		/**
		 * 滚动条y
		 */
		private var mLastDragPosition : int;
		private var whellDelta : int = 10;
		protected var mVerticalScrollPolicy : String = SCROLL_POLICY_ON;
		protected var mHorizontalScrollPolicy : String = SCROLL_POLICY_OFF;
		private var mDragRectangle : Rectangle;

		public function SScroller(skin : DisplayObject = null)
		{
			this.mask = mMask;
			addChildAt(mMask, 0);
			super(skin);
		}

		override public function setSKin(value : DisplayObject) : void
		{
			if (value == null)
				return;
			super.setSKin(value);
			var skin : Sprite = mSkin as Sprite;

			if (value["btn_down"])
			{
				mUpBtn = new SButton(value["btn_up"]);
				skin.addChild(mUpBtn);
				mDownBtn = new SButton(value["btn_down"]);
				skin.addChild(mDownBtn);

				if (mUpBtn.width == mUpBtn.height)
					mBtnSize = mUpBtn.width;
			}

			mScrollBtn = new SButton(value["btn_bar"]);
			skin.addChild(mScrollBtn);
			mBgImage = value["bg"];
		}

		public function setTarget(target : DisplayObject) : void
		{
			if (target == null)
				return;
			mTarget = target;
			addChildAt(mTarget, 1);
			mResize = true;
		}

		override protected function addListenerHandler() : void
		{
			if (!mSkin)
				return;
			addViewListener(mScrollBtn, MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addViewListener(stage, MouseEvent.MOUSE_UP, onMouseUpHandler);
			addViewListener(this, MouseEvent.ROLL_OVER, onRollOverHandler);
			addViewListener(this, MouseEvent.ROLL_OUT, onRollOutHandler);
			addViewListener(mTarget, CHANGE, targetChangeHandler);
			addViewListener(mDownBtn, MouseEvent.CLICK, onScrollDownHandler);
			addViewListener(mUpBtn, MouseEvent.CLICK, onScrollUpHandler);
		}

		private function onScrollUpHandler(evt : Event) : void
		{
			setTargetPosition(mVerticalScrollPolicy == SCROLL_POLICY_ON ? mTarget.y + mHeight : mTarget.x + mWidth, 1);
		}

		private function onScrollDownHandler(evt : Event) : void
		{
			setTargetPosition(mVerticalScrollPolicy == SCROLL_POLICY_ON ? mTarget.y - mHeight : mTarget.x - mWidth, -1);
		}

		override protected function hide() : void
		{
			mScrollBtn && mScrollBtn.stopDrag();
		}

		private function onMouseDownHandler(evt : MouseEvent) : void
		{
			addViewListener(this, Event.ENTER_FRAME, onEnterFrame);
			mScrollBtn.startDrag(false, mDragRectangle);
		}

		private function onMouseUpHandler(evt : Event) : void
		{
			removeViewListener(this, Event.ENTER_FRAME, onEnterFrame);
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
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
			{
				if (mScrollBtn.y == mLastDragPosition)
					return;
				mLastDragPosition = mScrollBtn.y;
				setScrollPercent((mScrollBtn.y - mBtnSize) / mMaxBarScroll);
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				if (mScrollBtn.x == mLastDragPosition)
					return;
				mLastDragPosition = mScrollBtn.x;
				setScrollPercent((mScrollBtn.x - mBtnSize) / mMaxBarScroll);
			}
		}

		protected function onMouseWheelHandler(event : MouseEvent) : void
		{
			setTargetPosition(mVerticalScrollPolicy == SCROLL_POLICY_ON ? mTarget.y : mTarget.x, event.delta > 0 ? 1 : -1);
		}

		private function setTargetPosition(position : Number, dir : int) : void
		{
			setScrollPercent((position + dir * whellDelta) / mMaxScroll);
		}

		/**
		 * 设置滚动位置，取值0-1
		 * @param value
		 *
		 */
		public function setScrollPercent(value : Number) : void
		{
			if (mCurrScrollPercent == value)
				return;
			mCurrScrollPercent = value;
			validate();
		}

		protected function get targetSize() : int
		{
			return mVerticalScrollPolicy == SCROLL_POLICY_ON ? mTarget.height : mTarget.width;
		}

		override protected function validate() : void
		{
			if (!mSkin)
				return;
			if (mResize)
			{
				mResize = false;
				targetChangeHandler();
				updateBtn();
				updateMask();
			}
			mCurrScrollPercent = Math.max(0, mCurrScrollPercent);
			mCurrScrollPercent = Math.min(1, mCurrScrollPercent);
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
			{
				mTarget.y = mCurrScrollPercent * mMaxScroll;
				mScrollBtn.y = mBtnSize + mMaxBarScroll * mCurrScrollPercent;
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				mTarget.x = mCurrScrollPercent * mMaxScroll;
				mScrollBtn.x = mBtnSize + mMaxBarScroll * mCurrScrollPercent;
			}
		}

		/**
		 * 目标文件宽高有改变
		 *
		 */
		private function targetChangeHandler(evt : Event = null) : void
		{
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
			{
				mMaxScroll = Math.min(0, mHeight - targetSize);
				mScrollBtn.height = Math.max(10, mMaxScroll / mHeight);
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				mMaxScroll = Math.min(0, mWidth - targetSize);
				mScrollBtn.width = Math.max(10, mMaxScroll / mWidth);
			}
			mScrollBtn.visible = mMaxScroll != 0;
			evt && invalidate();
		}

		protected function updateBtn() : void
		{
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
			{
				mBgImage.height = mHeight;
				mSkin.x = mWidth - mSkin.width;
				if (mDownBtn)
					mDownBtn.y = mHeight - mBtnSize;
				mMaxBarScroll = mHeight - mBtnSize * 2 - mScrollBtn.height;
				mDragRectangle = new Rectangle(0, mBtnSize, 0, mMaxBarScroll);
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				mBgImage.width = mWidth;
				mSkin.y = mHeight - mSkin.height;
				if (mDownBtn)
					mDownBtn.x = mWidth - mBtnSize;
				mMaxBarScroll = mWidth - mBtnSize * 2 - mScrollBtn.width;
				mDragRectangle = new Rectangle(mBtnSize, 0, mMaxBarScroll, 0);
			}
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

		public function get verticalScrollPolicy() : String
		{
			return mVerticalScrollPolicy;
		}

		public function set verticalScrollPolicy(value : String) : void
		{
			if (mVerticalScrollPolicy == value)
				return;
			mVerticalScrollPolicy = value;
			mHorizontalScrollPolicy = mVerticalScrollPolicy == SCROLL_POLICY_ON ? SCROLL_POLICY_OFF : SCROLL_POLICY_ON;
			invalidate();
		}

		public function get horizontalScrollPolicy() : String
		{
			return mHorizontalScrollPolicy;
		}

		public function set horizontalScrollPolicy(value : String) : void
		{
			if (mHorizontalScrollPolicy == value)
				return;
			mHorizontalScrollPolicy = value;
			mVerticalScrollPolicy = mHorizontalScrollPolicy == SCROLL_POLICY_ON ? SCROLL_POLICY_OFF : SCROLL_POLICY_ON;
			invalidate();
		}

		override public function dispose() : void
		{
			super.dispose();
			mScrollBtn = null;
			mUpBtn = null;
			mDownBtn = null;
			mBgImage = null;
			mTarget = null;
		}
	}
}