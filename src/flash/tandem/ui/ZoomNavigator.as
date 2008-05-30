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
package tandem.ui
{
	
import caurina.transitions.Tweener;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

import tandem.core.ZoomModel;
import tandem.core.ZoomModelEvent;


public class ZoomNavigator extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     */
	public function ZoomNavigator()
	{
		addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true )
		addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true )
		
		createBackground()
		createThumb()
		
	}
	
    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------	
	
	private var background : Shape
	private var thumb : Sprite
	
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
	private var explicitWidth : Number = 250
	
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
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
		_model = value
		model.addEventListener( ZoomModelEvent.CHANGE, modelChangeHandler )
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event Handler: Model
    //
    //--------------------------------------------------------------------------
    
	private function modelChangeHandler( event : ZoomModelEvent = null ) : void
	{
		var vp : Rectangle = model.viewport
		
        Tweener.addTween(
                            background,
                            {
                                width: explicitWidth,
                                height: explicitWidth / model.viewAspectRatio,
                                time: 0.4,
                                transition: "easeOutSine"
                            }
                        )
		
		Tweener.addTween(
                            thumb,
                            {
                                width: Math.min( vp.width, 1 ) * explicitWidth,
                                height: Math.min( vp.height, 1 ) * explicitWidth / model.viewAspectRatio,
                                x: Math.max( vp.x, 0 ) * background.width,
                                y: Math.max( vp.y, 0 ) * background.height,
                                time: 0.4,
                                transition: "easeOutSine"
                            }
                        )
	}
    
    //--------------------------------------------------------------------------
    //
    //  Event Handler: Stage
    //
    //--------------------------------------------------------------------------
    
    private function addedToStageHandler( event : Event ) : void
    {
        stage.addEventListener( Event.RESIZE, resizeHandler, false, 0, true )
        resizeHandler()
    }
    
    private function removedFromStageHandler( event : Event ) : void
    {
        stage.removeEventListener( Event.RESIZE, resizeHandler )
    }
	
	private function resizeHandler( event : Event = null ) : void
	{
		modelChangeHandler()
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Children
    //
    //--------------------------------------------------------------------------
    
	private function createBackground() : void
	{
		background = new Shape()
		
		var g : Graphics = background.graphics
		
			g.beginFill( 0x000000, 0.6 )
			g.drawRect( 0, 0, explicitWidth, explicitWidth )
			g.endFill()
			
		addChild( background )
	}
	
	private function createThumb() : void
	{
		thumb = new Sprite()
		thumb.alpha = 0.8
		
		var g : Graphics = thumb.graphics
		
			g.beginFill( 0xFF0000, 0.2 )
			g.lineStyle( 0, 0xFF0000 )
			g.drawRect( 0, 0, 20, 20 )
			g.endFill()
			
		addChild( thumb )
	}
}

}