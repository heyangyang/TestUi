package
{
	import flash.display.Shape;
	import flash.display.Sprite;

	public class TestSkin extends Sprite
	{
		public var btn_up : Shape;
		public var btn_down : Shape;
		public var btn_bar : Shape;
		public var bg : Shape;

		public function TestSkin()
		{
			bg = createShape(20, 20, 0x999999);
			addChild(bg);
			btn_up = createShape(20, 20, 0xff0000);
			addChild(btn_up);
			btn_down = createShape(20, 20);
			addChild(btn_down);
			btn_bar = createShape(20, 20, 0x0000ff);
			addChild(btn_bar);
		}

		private function createShape(w : int, h : int, color : int = 0x00ff00) : Shape
		{
			var shape : Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
			return shape;
		}
	}
}