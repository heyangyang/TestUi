package ui
{
	import flash.text.TextField;

	import ui.base.ViewBase;
	import ui.namespaces.self;

	public class SListRender extends ViewBase
	{
		private var mTxt : TextField;
		private var mData : *;
		self var mIndex : int;

		public function SListRender()
		{
			super();
			mTxt = new TextField();
			mTxt.width = 100;
			mTxt.height = 25;
			mTxt.background = true;
			mTxt.border=true;
			mTxt.selectable = false;
			addChild(mTxt);
		}

		self function setData(value : *) : void
		{
			if (value == mData)
				return;
			data = value;
		}

		public function set data(value : *) : void
		{
			mData = value;
			mTxt.text = value ? value : "";
		}

		public function set isSelected(value : Boolean) : void
		{

		}
	}
}