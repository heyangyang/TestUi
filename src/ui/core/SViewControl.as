package ui.core
{
	import flash.display.Stage;
	import flash.events.Event;

	import ui.base.SComponets;
	import ui.namespaces.self;

	use namespace self;

	public class SViewControl
	{
		private static var instance : SViewControl;

		public static function getInstance() : SViewControl
		{
			if (instance == null)
				instance = new SViewControl();
			return instance;
		}

		private var mQueues : Vector.<SComponets> = new Vector.<SComponets>();
		private var mNmChildren : int;

		public function SViewControl()
		{
		}

		public function init(stage : Stage) : void
		{
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function addControl(child : SComponets) : void
		{
			if (mQueues.indexOf(child) != -1)
				return;
			mQueues.push(child);
			mNmChildren++;
		}

		public function removeControl(child : SComponets) : void
		{
			removeControlAt(mQueues.indexOf(child));
		}

		public function removeControlAt(index : int) : void
		{
			if (index < 0 || index >= mNmChildren)
				return;
			mQueues.splice(index, 1);
			mNmChildren--;
		}

		private function onEnterFrame(evt : Event) : void
		{
			if (mNmChildren == 0)
				return;
			var child : SComponets;
			for (var i : int = mNmChildren - 1; i >= 0; i--)
			{
				child = mQueues[i];
				removeControlAt(i);
				child.onEnterFrame();
			}
		}
	}
}