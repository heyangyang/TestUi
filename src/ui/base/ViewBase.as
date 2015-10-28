package ui.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ViewBase extends Sprite
	{
		private var mEventMap : EventMap;

		public function ViewBase()
		{
			super();
			initListener();
			init();
		}

		/**
		 * 初始化
		 *
		 */
		protected function init() : void
		{

		}

		private function initListener() : void
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removeToStageHandler, false, 0, true);
		}

		private function addToStageHandler(event : Event) : void
		{
			addListenerHandler();
			show();
		}

		/**
		 * 移除出舞台
		 *
		 */
		private function removeToStageHandler(event : Event) : void
		{
			mEventMap && mEventMap.unmapListeners();
			hide();
		}

		private function get eventMap() : EventMap
		{
			if (mEventMap == null)
				mEventMap = new EventMap();
			return mEventMap;
		}

		/**
		 * 添加事件
		 *
		 */
		protected function addListenerHandler() : void
		{

		}

		/**
		 * 添加到舞台调用
		 *
		 */
		protected function show() : void
		{

		}

		/**
		 * 移出舞台调用
		 *
		 */
		protected function hide() : void
		{

		}

		/**
		 * 添加组件事件
		 * @param dispatcher
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function addViewListener(dispatcher : EventDispatcher, eventString : String, listener : Function, eventClass : Class = null) : void
		{
			if (dispatcher)
				eventMap.mapListener(dispatcher, eventString, listener, eventClass);
		}

		/**
		 * 移除组件事件
		 * @param dispatcher
		 * @param eventString
		 * @param listener
		 * @param eventClass
		 *
		 */
		protected function removeViewListener(dispatcher : EventDispatcher, eventString : String, listener : Function, eventClass : Class = null) : void
		{
			eventMap.unmapListener(dispatcher, eventString, listener, eventClass);
		}

		public function dispose() : void
		{
			removeToStageHandler(null);
			mEventMap = null;
		}
	}
}