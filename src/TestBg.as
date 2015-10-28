package
{
	import flash.display.Shape;
	import flash.display.Sprite;

	public class TestBg extends Sprite
	{
		public function TestBg(w : int, h : int)
		{
			super();
			var len : int = Math.ceil(h / 20);
			var shape : Shape;
			for (var i : int = 0; i < len; i++)
			{
				shape = createShape(w, 20, 0xffffff * Math.random());
				addChild(shape);
				shape.y = i * 20;
			}
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