package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;

	import ui.SButton;
	import ui.SList;
	import ui.SScroller;
	import ui.STextInput;
	import ui.core.SViewControl;
	import ui.layout.SHorizontalLayout;

	public class TestUi extends Sprite
	{
		private var list : SList;
		private var array : Array;

		public function TestUi()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			SViewControl.getInstance().init(stage);
			list = new SList();
			list.setSize(200, 200);
			array = [];
			for (var i : int = 0; i < 500; i++)
			{
				array.push(i + "," + int(Math.random() * 10000000));
			}
//			list.layout = new SHorizontalLayout();
//			list.horizontalScrollPolicy = SScroller.SCROLL_POLICY_ON;
			list.setSKin(new TestScrollSkin());
			list.layout.gap = 20;
//			list.scrollItemIndex(90)
			list.dataProvider = array;
			list.x = list.y = 150;
			label = new STextInput();
			label.password = true;
			addChild(label);
			label.text = "电风扇水电费";
			var button : SButton = new SButton();
			addChild(button);
			addChild(list);
			button.setSKin(createShape(100, 30));
			button.x = 200;
			button.lable = "水电费GV";

//			var scrollBar : SScroller = new SScroller(new TestScrollSkin());
//			addChild(scrollBar);
//			scrollBar.x = 400;
//			var shape : Sprite = new TestBg(200, 500);
//			var shape : Sprite = new TestBg1(500, 200);
//			scrollBar.horizontalScrollPolicy = SScroller.SCROLL_POLICY_ON;
//			scrollBar.setTarget(shape);
//			scrollBar.setSize(200, 200);
//			stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function createShape(w : int, h : int, color : int = 0xffffff) : Shape
		{
			var shape : Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
			return shape;
		}

		private var label : STextInput;

		protected function onClick(event : MouseEvent) : void
		{
			label.password = !label.password;
			//			var len : int = array.length + 100;
			//			for (var i : int = array.length; i < len; i++)
			//			{
			//				array.push(i + "," + int(Math.random() * 10000000));
			//			}
			//			array.length -= 100;
			//			list.dataProvider = array;
			trace(11111)
		}
	}
}