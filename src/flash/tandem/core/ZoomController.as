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
package tandem.core
{

import caurina.transitions.Tweener;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.Timer;

public class ZoomController
{
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------	
	
	private const TRANSITION_DURATION : Number = 0.4
	private const TRANSITION_TYPE : String = "easeOutSine"
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
	public function ZoomController() : void
	{
	}
		
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  view
    //----------------------------------
    
    private var _view : DisplayObject
    
	public function get view() : DisplayObject
	{
		return _view
	}
	
	public function set view( value : DisplayObject ) : void
	{
		_view = value
		
		if( view != null )
		{
            view.addEventListener( Event.ADDED_TO_STAGE, view_addedToStageHandler, false, 0, true )
            view.addEventListener( Event.REMOVED_FROM_STAGE, view_removedFromStageHandler, false, 0, true )
		}
        
        if( view && view.stage )
            registerListeners()			
        
        model.viewAspectRatio = view.width / view.height
	}
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : Rectangle = new Rectangle( 0, 0, 100, 100 )
    
    public function get viewport() : Rectangle
    {
    	return _viewport.clone()
    }
        
    public function set viewport( value : Rectangle ) : void
    {
        _viewport = value
        
        if( model )
            model.viewportAspectRatio = _viewport.width / _viewport.height
    }
    
    //----------------------------------
    //  model
    //----------------------------------
    
    private var _model : ZoomModel
    
	public function get model() : ZoomModel
	{
		return _model
	}
	
	public function set model( value : ZoomModel ) : void
	{
		if( _model && value == null )
            _model.removeEventListener( ZoomModelEvent.CHANGE, modelChangeHandler )
		 
		_model = value
		
		if( model )
            model.addEventListener( ZoomModelEvent.CHANGE, modelChangeHandler, false, 0, true )
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function view_addedToStageHandler( event : Event ) : void
    {
        registerListeners()
    }
    
    private function view_removedFromStageHandler( event : Event ) : void
    {
        unregisterListeners()
    }
    
    private function registerListeners() : void
    {
    	keyboardTimer = new Timer( KEYBOARD_REFRESH_DELAY )
        keyboardTimer.start()
        keyboardTimer.addEventListener( TimerEvent.TIMER, keyboardTimerHandler, false, 0, true )
        
        view.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true )
        view.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true )
        
        view.stage.addEventListener( MouseEvent.MOUSE_WHEEL, view_mouseWheelHandler, false, 0, true )
        
        view.stage.addEventListener( MouseEvent.MOUSE_DOWN, view_mouseDownHandler, false, 0, true )
        view.stage.addEventListener( MouseEvent.MOUSE_UP, view_mouseUpHandler, false, 0, true )
        view.stage.addEventListener( Event.MOUSE_LEAVE, view_mouseLeaveHandler, false, 0, true )
    }
	
	private function unregisterListeners() : void
	{
        keyboardTimer.removeEventListener( TimerEvent.TIMER, keyboardTimerHandler )
        keyboardTimer.stop()
        keyboardTimer = null
        
        view.stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler )
        view.stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandler )
        
        view.stage.removeEventListener( MouseEvent.MOUSE_WHEEL, view_mouseWheelHandler )
        
        view.stage.removeEventListener( MouseEvent.MOUSE_DOWN, view_mouseDownHandler )
        view.stage.removeEventListener( MouseEvent.MOUSE_UP, view_mouseUpHandler )
        view.stage.removeEventListener( Event.MOUSE_LEAVE, view_mouseLeaveHandler )		
	}
    
    //--------------------------------------------------------------------------
    //
    //  Keyboard Navigation
    //
    //--------------------------------------------------------------------------
    
    private const KEYBOARD_REFRESH_DELAY : Number = 60
    private var keyboardTimer : Timer
    
    private const BOOST_FACTOR : Number = 7
    private var boosterActivated : Boolean
   
    private const STEP_RATIO : Number = 1 / 15
    
    private var upActivated : Boolean
    private var downActivated : Boolean
    private var leftActivated : Boolean
    private var rightActivated : Boolean

    private var zoomInActivated : Boolean
    private var zoomOutActivated : Boolean
    
    
    private function keyDownHandler( event : KeyboardEvent ) : void
    {
        enableNavigationTriggers( event, true )
    }
    
    private function keyUpHandler( event : KeyboardEvent ) : void
    {
        enableNavigationTriggers( event, false )
    }
    
    private function enableNavigationTriggers( event : KeyboardEvent,
                                               value : Boolean = true ) : void
    {
        switch( event.keyCode )
        {
            case Keyboard.SHIFT:
                boosterActivated = value
                break
                
            case Keyboard.UP:
            case 87: // W
                upActivated = value
                break
                
            case Keyboard.DOWN:
            case 83: // S
                downActivated = value
                break
                
            case Keyboard.LEFT:
            case 65: // A
                leftActivated = value
                break
                
            case Keyboard.RIGHT:
            case 68: // D
                rightActivated = value
                break
                
            case Keyboard.NUMPAD_ADD:
            case 73: // I
                zoomInActivated = value
                break
                
            case Keyboard.NUMPAD_SUBTRACT:
            case 79: // O
                zoomOutActivated = value
                break
        }
    }
    
    private function keyboardTimerHandler( event : TimerEvent ) : void
    {
        var horizontalStep : Number = model.viewport.width * STEP_RATIO
        var verticalStep : Number = model.viewport.height * STEP_RATIO
        
        if( boosterActivated )
        {
            horizontalStep *= BOOST_FACTOR
            verticalStep *= BOOST_FACTOR
        }
        
    	if( upActivated )
            model.moveBy( 0, -verticalStep )
        
        if( downActivated )
            model.moveBy( 0, verticalStep )
        
        if( leftActivated )
            model.moveBy( -horizontalStep, 0 )
        
        if( rightActivated )
            model.moveBy( horizontalStep, 0 )
        
        if( zoomInActivated )
            model.zoomBy( 11/7 )
        
        if( zoomOutActivated )
            model.zoomBy( 7/9 )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Mouse Navigation
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

        var originX : Number = ( view.stage.mouseX - _viewport.x ) / _viewport.width
        var originY : Number = ( view.stage.mouseY - _viewport.y ) / _viewport.height

        if( _viewport.width > view.width )
            originX = 0.5
        
        if( _viewport.height > view.height )
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
    	return _viewport.contains( view.mouseX, view.mouseY )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handler: Model
    //
    //--------------------------------------------------------------------------
    
    private function modelChangeHandler( event : ZoomModelEvent = null ) : void
    {
    	if( view )
    	{
            var modelViewport : Rectangle = model.viewport
            
            var newWidth : Number = _viewport.width / modelViewport.width
            var newHeight : Number = _viewport.height / modelViewport.height
            var newX : Number = _viewport.x - modelViewport.x * newWidth
            var newY : Number = _viewport.y - modelViewport.y * newHeight

            if( newX - _viewport.x > 0 )
                newX = _viewport.x + ( _viewport.width - newWidth ) / 2
            
            if( newY - _viewport.y > 0 )
                newY = _viewport.y + ( _viewport.height - newHeight ) / 2

            Tweener.addTween(
                               view,
                               {
                                    width: newWidth,
                                    height: newHeight,
                                    x: newX,
                                    y: newY,
                                    time: TRANSITION_DURATION,
                                    transition: TRANSITION_TYPE
                               }
                            )
    	}
    }
}

}