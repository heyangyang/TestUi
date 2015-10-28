package ui
{
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import ui.base.SComponets;
	import ui.core.SUiConfig;

	public class SLabel extends SComponets
	{
		private var mNativeTextField : TextField;
		private var mTextFormat : TextFormat;
		private var mIsHtml : Boolean;
		private var mFontSize : int;
		private var mText : String;
		private var mColor : int;
		private var mAlign : String;

		public function SLabel(skin : DisplayObject = null)
		{
			super(skin);
		}

		override protected function init() : void
		{
			mNativeTextField = new TextField();
			mFontSize = 13;
			mAlign = "left";
			mColor = 0xffffff;
			mTextFormat = new TextFormat("SimSun", mFontSize, mColor, null, null, null, null, null, mAlign);
			mNativeTextField.filters = SUiConfig.blackFilter;
			addChild(mNativeTextField);
			selectable = false;
		}

		public function set align(value : String) : void
		{
			mAlign = value;
		}

		public function set color(value : int) : void
		{
			if (mColor == value)
				return;
			mColor = value;
			invalidate();
		}

		public function set fontSize(value : int) : void
		{
			if (mFontSize == value)
				return;
			mFontSize = value;
			invalidate();
		}

		public function set isHtml(value : Boolean) : void
		{
			if (mIsHtml == value)
				return;
			mIsHtml = value;
			invalidate();
		}

		public function set text(value : String) : void
		{
			mText = value;
			invalidate();
		}

		public function get text() : String
		{
			return mText;
		}

		public function set selectable(value : Boolean) : void
		{
			mNativeTextField.selectable = value;
		}

		override protected function validate() : void
		{
			mTextFormat.color = mColor;
			mTextFormat.size = mFontSize;
			mTextFormat.align = mAlign;
			mNativeTextField.defaultTextFormat = mTextFormat;
			if (mIsHtml)
				mNativeTextField.htmlText = mText;
			else
				mNativeTextField.text = mText;
			mNativeTextField.width = mNativeTextField.textWidth + 4;
			mNativeTextField.height = mNativeTextField.textHeight + 4;
		}
	}
}