package ui.layout
{
	import flash.geom.Point;
	import ui.SListRender;

	/**
	 * 横向排序
	 * @author hyy
	 *
	 */
	public class SHorizontalLayout extends SLayoutBase
	{
		public function SHorizontalLayout()
		{
		}

		override public function sort(items : Vector.<SListRender>, dataProvider : *) : Point
		{
			update(items, dataProvider, mTotalRows, mTotalCols, mItemWidth);
			mPoint.x = mScrollPosition;
			return mPoint;
		}

		override public function sortRender(render : SListRender, index : int) : void
		{
			render.x = int(index / mTotalRows) * mItemWidth;
			render.y = index % mTotalRows * mItemHeight;
		}

		/**
		 * 间隔
		 * 只影响宽度
		 * @param value
		 *
		 */
		override public function set gap(value : int) : void
		{
			super.gap = value;
			mItemWidth = value + mGap;
		}

		/**
		 * @private
		 */
		override public function set itemWidth(value : int) : void
		{
			mItemWidth = value + mGap;
		}

		override protected function updateSize() : void
		{
			mTotalCols = Math.ceil(mWidth / mItemWidth);
			mTotalRows = Math.floor(mHeight / mItemHeight);
			mShowItemNum = mTotalCols * mTotalRows;
			mDifferenceValue = mTotalRows;
		}
	}
}