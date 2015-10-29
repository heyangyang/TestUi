package ui.layout
{
	import flash.geom.Point;

	import ui.SListRender;
	import ui.namespaces.self;

	use namespace self;

	public class SLayoutBase
	{
		protected var mItemWidth : int;
		protected var mItemHeight : int;
		protected var mWidth : int;
		protected var mHeight : int;
		protected var mGap : int;
		protected var mTotalRows : int;
		protected var mTotalCols : int;
		protected var mDifferenceValue : int;
		protected var mShowItemNum : int;

		/**
		 * 最大滚动的值  单位像素
		 */
		protected var mMaxScrollPosition : int;
		/**
		 * 最大滚动到索引
		 */
		protected var mMaxScrollIndex : int;
		/**
		 * 滚动到某个索引
		 */
		protected var mCurrScrollIndex : int = -1;
		/**
		 * 当前滚动位置，像素
		 */
		protected var mScrollPosition : int;
		/**
		 * 百分比
		 */
		protected var mCurrScrollPercent : Number;

		private var mLastStartIndex : int = -1;
		private var mLastDataLength : int;
		private var mLastDataProvider : *;

		public function SLayoutBase()
		{
		}

		public function setSize(w : int, h : int) : void
		{
			mWidth = w;
			mHeight = h;
			updateSize();
		}

		/**
		 * 设置滚动位置，取值0-1
		 * @param value
		 *
		 */
		public function setScrollPercent(value : Number) : void
		{
			mCurrScrollPercent = value;
		}

		public function getScrollPercent() : Number
		{
			return mCurrScrollPercent;
		}

		public function sort(items : Vector.<SListRender>, dataProvider : *) : void
		{
		}

		protected function update(items : Vector.<SListRender>, dataProvider : *, row : int, col : int, size : int) : void
		{
			var datalength : int = dataProvider.length;
			//不相同则移动到0
			if (mLastDataProvider == null || mLastDataProvider != dataProvider)
			{
				mLastDataProvider = dataProvider;
				mCurrScrollPercent = 0;
				mLastDataLength = -1;
			}
			//长度不同，还原位置
			if (datalength != mLastDataLength)
			{
				var maxScrollPosition : Number = Math.ceil(datalength / row - col) * size;
				var maxScrollIndex : int = datalength - mShowItemNum - row;
				mCurrScrollPercent = Math.min(1, mCurrScrollPercent * mMaxScrollPosition / maxScrollPosition);
				mCurrScrollPercent = Math.max(mCurrScrollPercent, 0);
				if (maxScrollIndex > mMaxScrollIndex && mLastStartIndex >= mMaxScrollIndex)
					mLastStartIndex = -1;
				mMaxScrollPosition = Math.max(maxScrollPosition, 0);
				mMaxScrollIndex = Math.max(maxScrollIndex, 0);
				mLastDataLength = datalength;
			}

			//指定滚动到索引
			if (mCurrScrollIndex != -1)
			{
				mCurrScrollIndex = Math.floor(mCurrScrollIndex / row) * row;
				//如果在以后一页，则需要更新
				if (mCurrScrollIndex >= 0 && mCurrScrollIndex <= datalength)
				{
					mCurrScrollPercent = mCurrScrollIndex / row * size / mMaxScrollPosition;
					mCurrScrollPercent = Math.min(mCurrScrollPercent, 1);
				}
				mCurrScrollIndex = -1
			}
			mScrollPosition = -mCurrScrollPercent * mMaxScrollPosition;
			var startIndex : int = Math.round(mCurrScrollPercent * mMaxScrollPosition / size) * row;
			startIndex = Math.min(startIndex, mMaxScrollIndex);
			startIndex = Math.max(startIndex, 0);
			var render : SListRender;
			var renderIndex : int = 0, i : int;
			var itemCount : int = items.length;

			if (mLastStartIndex != -1)
			{
				var startVector : Vector.<SListRender>;
				if (startIndex > mLastStartIndex)
				{
					startVector = items.splice(0, row);
					for (i = 0; i < row; i++)
					{
						items.push(startVector[i]);
					}
				}
				else if (startIndex < mLastStartIndex)
				{
					startVector = items.splice(items.length - row, row);
					for (i = 0; i < row; i++)
					{
						items.splice(0, 0, startVector[i]);
					}
				}
				else
					return;
			}
			mLastStartIndex = startIndex;
			for (i = startIndex - mDifferenceValue; i < startIndex + mShowItemNum + mDifferenceValue; i++)
			{
				render = items[renderIndex++];
				if (i < 0 || i >= datalength)
				{
					render.setData(null);
					continue;
				}
				render.mIndex = i;
				render.setData(dataProvider[i]);
				sortRender(render, i);
			}
		}

		public function sortRender(render : SListRender, index : int) : void
		{

		}

		public function set scrollPosition(value : int) : void
		{
			mScrollPosition = value;
			if (mScrollPosition < -mMaxScrollPosition)
				mScrollPosition = -mMaxScrollPosition;
			else if (mScrollPosition > 0)
				mScrollPosition = 0;
			mCurrScrollPercent = Math.max(0, mScrollPosition / -mMaxScrollPosition);
		}

		public function get scrollPosition() : int
		{
			return mScrollPosition;
		}

		public function scrollItemIndex(value : int) : void
		{
			mCurrScrollIndex = value;
		}

		public function set gap(value : int) : void
		{
			mGap = value;
			updateSize();
		}

		public function get gap() : int
		{
			return mGap;
		}

		public function set itemWidth(value : int) : void
		{
			mItemWidth = value;
			updateSize();
		}

		public function get itemWidth() : int
		{
			return mItemWidth;
		}

		public function set itemHeight(value : int) : void
		{
			mItemHeight = value;
			updateSize();
		}

		public function get itemHeight() : int
		{
			return mItemHeight;
		}

		/**
		 * 每行显示原件数量
		 */
		public function get totalRows() : int
		{
			return mTotalRows;
		}

		/**
		 * 每列显示原件数量
		 */
		public function get totalCols() : int
		{
			return mTotalCols;
		}

		/**
		 * 差值
		 */
		public function get differenceValue() : int
		{
			return mDifferenceValue;
		}

		/**
		 * 每页显示原件数
		 */
		public function get showItemNum() : int
		{
			return mShowItemNum;
		}

		protected function updateSize() : void
		{
			mTotalCols = Math.ceil(mWidth / itemWidth);
			mTotalRows = Math.ceil(mHeight / itemHeight);
			mShowItemNum = mTotalCols * mTotalRows;
			mDifferenceValue = 1;
		}

		public function dispose() : void
		{
			mLastDataProvider = null;
		}
	}
}