package ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import ui.base.SComponets;
	import ui.core.SUiConfig;

	public class STextInput extends SComponets
	{
		private var mNativeTextField : TextField;
		private var mTextFormat : TextFormat;
		private var mUpdateFormat : Boolean;
		private var mFontSize : int;
		private var mText : String;
		private var mColor : int;
		private var mAlign : String;
		private var mPassWrod : Boolean;
		private var mShowIndex : int;
		private var mShowDelay : int = 0;

		public function STextInput(skin : DisplayObject = null)
		{
			super(skin);
		}

		override protected function init() : void
		{
			mNativeTextField = new TextField();
			mFontSize = 13;
			mAlign = TextFieldAutoSize.LEFT;
			mColor = 0xffffff;
			mTextFormat = new TextFormat("SimSun", mFontSize, mColor, null, null, null, null, null, mAlign);
			mNativeTextField.filters = SUiConfig.blackFilter;
			mNativeTextField.type = TextFieldType.INPUT;
			mUpdateFormat = true;
			addChild(mNativeTextField);
		}

		override public function setSize(w : int, h : int) : void
		{
			mNativeTextField.width = w;
			mNativeTextField.height = h;
		}

		public function set align(value : String) : void
		{
			if (mAlign == value)
				return;
			mAlign = value;
			mUpdateFormat = true;
			invalidate();
		}

		public function set color(value : int) : void
		{
			if (mColor == value)
				return;
			mColor = value;
			mUpdateFormat = true;
			invalidate();
		}

		public function set fontSize(value : int) : void
		{
			if (mFontSize == value)
				return;
			mFontSize = value;
			mUpdateFormat = true;
			invalidate();
		}

		public function set text(value : String) : void
		{
			if (mText == value)
				return;
			mText = value;
			mShowIndex = mText.length;
			invalidate();
		}

		public function get text() : String
		{
			return mText;
		}


		public function set password(value : Boolean) : void
		{
			if (mPassWrod == value)
				return;
			mPassWrod = value;
			if (mPassWrod)
				addViewListener(this, Event.CHANGE, onChangeHandler);
			else
				removeViewListener(this, Event.CHANGE, onChangeHandler);
			invalidate();
		}

		public function get password() : Boolean
		{
			return mPassWrod;
		}

		private function onChangeHandler(evt : Event) : void
		{
			if (mPassWrod)
				mText = mText + mNativeTextField.text.substring(mNativeTextField.text.length - 1)
			else
				mText = mNativeTextField.text;
			invalidate();
		}

		override protected function validate() : void
		{
			if (mUpdateFormat)
			{
				mUpdateFormat = false;
				mTextFormat.color = mColor;
				mTextFormat.size = mFontSize;
				mTextFormat.align = mAlign;
				mNativeTextField.defaultTextFormat = mTextFormat;
			}
			if (mPassWrod)
			{
				mNativeTextField.text = getPassWord(mShowIndex) + mText.substring(mShowIndex);
				if (mShowIndex == mText.length)
					return;
				if (mShowDelay++ == 8 && mShowIndex != mText.length)
				{
					mShowDelay = 0;
					mShowIndex++;
				}
				invalidate();
			}
			else
				mNativeTextField.text = mText;
		}

		private function getPassWord(len : int) : String
		{
			var str : String = "";
			for (var i : int = 0; i < len; i++)
			{
				str += "*";
			}
			return str;
		}
	}
}