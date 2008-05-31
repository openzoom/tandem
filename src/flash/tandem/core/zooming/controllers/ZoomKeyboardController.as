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

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;
	
public class ZoomKeyboardController extends AbstractZoomController
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
    * Constructor.
    */
    public function ZoomKeyboardController() : void
    {
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods: View
    //
    //--------------------------------------------------------------------------
    
    override protected function view_addedToStageHandler( event : Event ) : void
    {
    	keyboardTimer = new Timer( KEYBOARD_REFRESH_DELAY )
        keyboardTimer.start()
        keyboardTimer.addEventListener( TimerEvent.TIMER, keyboardTimerHandler, false, 0, true )
        
        view.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true )
        view.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true )
    }
    
    override protected function view_removedFromStageHandler( event : Event ) : void
    {
        keyboardTimer.removeEventListener( TimerEvent.TIMER, keyboardTimerHandler )
        keyboardTimer.stop()
        keyboardTimer = null
        
        view.stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler )
        view.stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandler )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers: Keyboard
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

    private var pageUpActivated : Boolean
    private var pageDownActivated : Boolean
    private var homeActivated : Boolean
    private var endActivated : Boolean

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
                
                
            case Keyboard.PAGE_UP:
                pageUpActivated = value
                break
                
            case Keyboard.PAGE_DOWN:
                pageDownActivated = value
                break
                
            case Keyboard.HOME:
                homeActivated = value
                break
                
            case Keyboard.END:
                endActivated = value
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
        
        
        if( pageUpActivated )
            model.moveTo( model.viewport.x, 0 )
        
        if( pageDownActivated )
            model.moveTo( model.viewport.x, 1 )
        
        if( homeActivated )
            model.moveTo( 0, model.viewport.y )
        
        if( endActivated )
            model.moveTo( 1, model.viewport.y )
        
        
        if( zoomInActivated )
            model.zoomBy( 11/7 )
        
        if( zoomOutActivated )
            model.zoomBy( 7/9 )
    }    
}

}