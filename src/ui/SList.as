package ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import ui.layout.SLayoutBase;
	import ui.layout.SVerticalLayout;

	public class SList extends SScroller
	{
		private static function sDefauleRender() : SListRender
		{
			return new SListRender();
		}

		private var mDefaultRender : Function = sDefauleRender;
		private var mList : Vector.<SListRender> = new Vector.<SListRender>();
		private var mContainer : Sprite = new Sprite();
		/**
		 * 源数据
		 */
		private var mDataProvider : *;
		/**
		 * 排列方式
		 */
		private var mLayout : SLayoutBase;

		protected var mPaddingLeft : int;
		protected var mPaddingTop : int;
		/**
		 * 选中的原件
		 */
		private var mSelectedItem : SListRender;

		private var mCurrScrollIndex : int = -1;

		private var mTargetSize : int;

		public function SList()
		{
		}

		override protected function init() : void
		{
			setTarget(mContainer);
		}

		/**
		 * 设置渲染元素
		 * @param fun
		 *
		 */
		public function setListRender(fun : Function) : void
		{
			mDefaultRender = fun;
			mResize = true;
		}

		public function get dataProvider() : *
		{
			return this.mDataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value : *) : void
		{
			mDataProvider = value;
			invalidate();
		}

		/**
		 * 滚动到某一行
		 * @param value
		 *
		 */
		public function scrollItemIndex(value : int) : void
		{
			mCurrScrollIndex = value;
			invalidate();
		}


		override protected function validate() : void
		{
			if (mLayout == null)
				layout = new SVerticalLayout();
			if (mResize)
			{
				var render : SListRender = mDefaultRender();
				mLayout.itemWidth = render.width;
				mLayout.itemHeight = render.height;

				if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
				{
					mLayout.setSize(mWidth - (mSkin ? mSkin.width : 0), mHeight);
					mTargetSize = mLayout.itemHeight * Math.ceil(mDataProvider.length / mLayout.totalCols) - mLayout.gap;
				}
				else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
				{
					mLayout.setSize(mWidth, mHeight -(mSkin ? mSkin.height : 0));
					mTargetSize = mLayout.itemWidth * Math.ceil(mDataProvider.length / mLayout.totalRows) - mLayout.gap;
				}

				var len : int = mLayout.showItemNum + mLayout.differenceValue * 2;
				for (var i : int = 0; i < len; i++)
				{
					if (mList.length > i)
						break;
					render = mDefaultRender();
					addViewListener(render, MouseEvent.CLICK, onItemClick);
					mContainer.addChild(render);
					mList.push(render);
				}
				while (mContainer.numChildren > len)
				{
					render = mContainer.removeChildAt(len) as SListRender;
					render.dispose();
				}
			}
			super.validate();
			layout.scrollItemIndex(mCurrScrollIndex);
			if (mVerticalScrollPolicy == SCROLL_POLICY_ON)
			{
				mLayout.scrollPosition = mContainer.y;
			}
			else if (mHorizontalScrollPolicy == SCROLL_POLICY_ON)
			{
				mLayout.scrollPosition = mContainer.x;
			}
			mLayout.sort(mList, mDataProvider);
			if (mCurrScrollIndex != -1)
			{
				mCurrScrollPercent = mLayout.getScrollPercent();
				super.validate();
				mCurrScrollIndex = -1;
			}
		}

		override protected function get targetSize() : int
		{
			return mTargetSize;
		}

		protected function onItemClick(event : MouseEvent) : void
		{
			if (mSelectedItem)
				mSelectedItem.isSelected = false;
			mSelectedItem = event.currentTarget as SListRender;
			mSelectedItem.isSelected = true;
		}

		public function set layout(value : SLayoutBase) : void
		{
			if (!value)
				return;
			mLayout = value;
			value.setSize(mWidth, mHeight);
			mResize = true;
			invalidate();
		}

		public function get layout() : SLayoutBase
		{
			if (mLayout == null)
				layout = new SVerticalLayout();
			return mLayout;
		}

		public function get paddingLeft() : int
		{
			return mPaddingLeft;
		}

		public function set paddingLeft(value : int) : void
		{
			mPaddingLeft = value;
		}

		public function get PaddingTop() : int
		{
			return mPaddingTop;
		}

		public function set PaddingTop(value : int) : void
		{
			mPaddingTop = value;
		}

		override public function dispose() : void
		{
			super.dispose();
			mSelectedItem = null;
		}
	}
}