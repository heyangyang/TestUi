package ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ui.base.SComponets;
	import ui.layout.SLayoutBase;
	import ui.layout.SVerticalLayout;

	public class SList extends SComponets
	{
		private static function sDefauleRender() : SListRender
		{
			return new SListRender();
		}

		private var mDefaultRender : Function = sDefauleRender;
		private var mList : Vector.<SListRender> = new Vector.<SListRender>();
		private var mContainer : Sprite = new Sprite();
		private var mMask : Shape = new Shape();
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

		public function SList()
		{
		}

		override protected function init() : void
		{
			addChild(mContainer);
			addChild(mMask);
			mContainer.mask = mMask;
		}

		override protected function addListenerHandler() : void
		{
			addViewListener(this, MouseEvent.ROLL_OVER, onRollOverHandler);
			addViewListener(this, MouseEvent.ROLL_OUT, onRollOutHandler);
		}

		private function onRollOverHandler(evt : MouseEvent) : void
		{
			stage.focus = stage;
			addViewListener(stage, MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}

		private function onRollOutHandler(evt : MouseEvent) : void
		{
			removeViewListener(stage, MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}

		protected function onMouseWheelHandler(event : MouseEvent) : void
		{
			mLayout.scrollPosition += event.delta * 2;
			invalidate();
		}

		/**
		 * 设置大小
		 * @param w
		 * @param h
		 *
		 */
		override public function setSize(w : int, h : int) : void
		{
			mWidth = w;
			mHeight = h;
			mResize = true;
			invalidate();
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
			if (mCurrScrollIndex != -1)
			{
				layout.scrollItemIndex(mCurrScrollIndex);
				mCurrScrollIndex = -1;
			}
			if (mResize)
			{
				mResize = false;
				updateMask();
				var render : SListRender = mDefaultRender();
				mLayout.setSize(mWidth, mHeight);
				mLayout.itemWidth = render.width;
				mLayout.itemHeight = render.height;

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
			var point : Point = mLayout.sort(mList, mDataProvider);
			mContainer.x = point.x + mPaddingLeft;
			mContainer.y = point.y + mPaddingTop;
		}

		protected function onItemClick(event : MouseEvent) : void
		{
			if (mSelectedItem)
				mSelectedItem.isSelected = false;
			mSelectedItem = event.currentTarget as SListRender;
			mSelectedItem.isSelected = true;
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