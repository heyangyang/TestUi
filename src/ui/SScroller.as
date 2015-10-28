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
		private var mVerticalScrollPolicy : String = SCROLL_POLICY_ON;
		private var mHorizontalScrollPolicy : String = SCROLL_POLICY_OFF;
		private var mDragRectangle : Rectangle;

		public function SScroller(skin : DisplayObject = null)
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
			addViewListener(mScrollBtn, MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			addViewListener(stage, MouseEvent.MOUSE_UP, onMouseUpHandler);
			addViewListener(this, MouseEvent.ROLL_OVER, onRollOverHandler);
			addViewListener(this, MouseEvent.ROLL_OUT, onRollOutHandler);
			addViewListener(mTarget, CHANGE, targetChangeHandler);
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
				setScrollPercent((mScrollBtn.y - mUpBtn.height) / mMaxBarScroll);
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				if (mScrollBtn.x == mLastDragPosition)
					return;
				mLastDragPosition = mScrollBtn.x;
				setScrollPercent((mScrollBtn.x - mUpBtn.width) / mMaxBarScroll);
			}
		}

		protected function onMouseWheelHandler(event : MouseEvent) : void
		{
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
				setScrollPercent((mTarget.y + event.delta / 3 * whellDelta) / mMaxScroll);
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
				setScrollPercent((mTarget.x + event.delta / 3 * whellDelta) / mMaxScroll);
		}

		/**
		 * 设置滚动位置，取值0-1
		 * @param value
		 *
		 */
		public function setScrollPercent(value : Number) : void
		{
			mCurrScrollPercent = value;
			validate();
		}

		/**
		 * 目标文件宽高有改变
		 *
		 */
		private function targetChangeHandler(evt : Event = null) : void
		{
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
			{
				mMaxScroll = Math.min(0, mHeight - mTarget.height);
				mScrollBtn.height = mMaxScroll / mMaxBarScroll;
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				mMaxScroll = Math.min(0, mWidth - mTarget.width);
				mScrollBtn.width = mMaxScroll / mMaxBarScroll;
			}
			mScrollBtn.visible = mMaxScroll != 0;
			invalidate();
		}

		override protected function validate() : void
		{
			if (!mSkin)
				return;
			if (mResize)
			{
				mResize = false;
				targetChangeHandler();
				if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
				{
					mBgImage.height = mHeight;
					mSkin.x = mWidth - mSkin.width;
					mDownBtn.y = mHeight - mDownBtn.height;
					mMaxBarScroll = mHeight - mUpBtn.height * 2 - mScrollBtn.height;
					mDragRectangle = new Rectangle(0, mUpBtn.height, 0, mMaxBarScroll);
				}
				else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
				{
					mBgImage.width = mWidth;
					mSkin.y = mHeight - mSkin.height;
					mDownBtn.x = mWidth - mDownBtn.width;
					mMaxBarScroll = mWidth - mUpBtn.width * 2 - mScrollBtn.width;
					mDragRectangle = new Rectangle(mUpBtn.width, 0, mMaxBarScroll, 0);
				}
				updateMask();
			}
			mCurrScrollPercent = Math.max(0, mCurrScrollPercent);
			mCurrScrollPercent = Math.min(1, mCurrScrollPercent);
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
			{
				mTarget.y = mCurrScrollPercent * mMaxScroll;
				mScrollBtn.y = mUpBtn.height + mMaxBarScroll * mCurrScrollPercent;
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				mTarget.x = mCurrScrollPercent * mMaxScroll;
				mScrollBtn.x = mUpBtn.width + mMaxBarScroll * mCurrScrollPercent;
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