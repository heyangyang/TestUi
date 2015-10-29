package ui.layout
{
	import ui.SListRender;

	/**
	 * 纵向排序
	 * @author hyy
	 *
	 */
	public class SVerticalLayout extends SLayoutBase
	{
		public function SVerticalLayout()
		{
		}

		override public function sort(items : Vector.<SListRender>, dataProvider : *) : void
		{
			update(items, dataProvider, mTotalCols, mTotalRows, mItemHeight);
		}

		override public function sortRender(render : SListRender, index : int) : void
		{
			render.x = index % mTotalCols * mItemWidth;
			render.y = int(index / mTotalCols) * mItemHeight;
		}

		/**
		 * 间隔
		 * 只影响高度
		 * @param value
		 *
		 */
		override public function set gap(value : int) : void
		{
			super.gap = value;
			mItemHeight = value + mGap;
		}

		/**
		 * 原件高度
		 * @private
		 */
		override public function set itemHeight(value : int) : void
		{
			mItemHeight = value + mGap;
		}

		override protected function updateSize() : void
		{
			mTotalCols = Math.floor(mWidth / mItemWidth);
			mTotalRows = Math.ceil(mHeight / mItemHeight);
			mShowItemNum = mTotalCols * mTotalRows;
			mDifferenceValue = mTotalCols;
		}
	}
}