////////////////////////////////////////////////////////////////////////////////
//
//  tandem. explore your world.
//  Copyright (c) 2007–2008 Daniel Gasienica (daniel@gasienica.ch)
//
//  tandem is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  tandem is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with tandem. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package tandem.core.zooming.controllers
{

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

public class ZoomMouseController extends AbstractZoomController
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */	
	public function ZoomMouseController()
	{
	}
	
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods: View
    //
    //--------------------------------------------------------------------------
    
	override protected function view_addedToStageHandler( event : Event ) : void
	{
		view.stage.addEventListener( MouseEvent.MOUSE_WHEEL, view_mouseWheelHandler, false, 0, true )
        
        view.stage.addEventListener( MouseEvent.MOUSE_DOWN, view_mouseDownHandler, false, 0, true )
        view.stage.addEventListener( MouseEvent.MOUSE_UP, view_mouseUpHandler, false, 0, true )
        view.stage.addEventListener( Event.MOUSE_LEAVE, view_mouseLeaveHandler, false, 0, true )
	}
	
	override protected function view_removedFromStageHandler( event : Event ) : void
	{
		view.stage.removeEventListener( MouseEvent.MOUSE_WHEEL, view_mouseWheelHandler )
        
        view.stage.removeEventListener( MouseEvent.MOUSE_DOWN, view_mouseDownHandler )
        view.stage.removeEventListener( MouseEvent.MOUSE_UP, view_mouseUpHandler )
        view.stage.removeEventListener( Event.MOUSE_LEAVE, view_mouseLeaveHandler )
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Mouse Navigation
    //
    //--------------------------------------------------------------------------
    
    private var stageDragVector : Rectangle = new Rectangle()
    private var modelViewportDragVector : Rectangle = new Rectangle()
        
    private function view_mouseDownHandler( event : MouseEvent ) : void
    {
        if( !isMouseWithinViewport( event ) )
           return
        
        stageDragVector.topLeft = new Point( event.stageX, event.stageY )
        modelViewportDragVector.topLeft = new Point( model.viewport.x, model.viewport.y )
        
        view.stage.addEventListener( MouseEvent.MOUSE_MOVE, view_mouseMoveHandler, false, 0, true )   
    }
    
    private function view_mouseMoveHandler( event : MouseEvent ) : void
    {
        if( !isMouseWithinViewport( event ) )
            view_mouseUpHandler( null )
        
        stageDragVector.bottomRight = new Point( event.stageX, event.stageY )
        
        model.moveTo( modelViewportDragVector.x - stageDragVector.width / view.width, 
                      modelViewportDragVector.y - stageDragVector.height / view.height )
    }
    
    private function view_mouseUpHandler( event : MouseEvent ) : void
    {
        view.stage.removeEventListener( MouseEvent.MOUSE_MOVE, view_mouseMoveHandler )
    }
    
    private function view_mouseLeaveHandler( event : Event ) : void
    {
        view_mouseUpHandler( null )
    } 
    
    private function view_mouseWheelHandler( event : MouseEvent ) : void
    {
        if( !isMouseWithinViewport( event ) )
            return
            
        var factor : Number
            factor = 1 + event.delta / 40

        var originX : Number = ( view.stage.mouseX - viewport.x ) / viewport.width
        var originY : Number = ( view.stage.mouseY - viewport.y ) / viewport.height

        if( viewport.width > view.width )
            originX = 0.5
        
        if( viewport.height > view.height )
            originY = 0.5

        model.zoomBy(
                      factor,
                      originX,
                      originY
                    )
    }
    
    private function isMouseWithinViewport( event : MouseEvent ) : Boolean
    {
        var view : DisplayObject = DisplayObject( event.currentTarget )
        return viewport.contains( view.mouseX, view.mouseY )
    }
}

}