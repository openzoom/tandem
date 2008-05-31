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
package tandem.ui.views
{

import br.com.stimuli.loading.BulkLoader;

import caurina.transitions.Tweener;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;

import tandem.core.zooming.IZoomModel;
import tandem.core.zooming.IZoomable;
import tandem.core.zooming.ZoomModelEvent;
import tandem.ui.views.renderers.PhotoRenderer;

public class StreamView extends Sprite implements IZoomable
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
    * Constructor.
    */
	public function StreamView()
	{
		createLoader()
		createTimer()
		createBackground()
	}
	
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
	private static const RENDER_DELAY : Number = 180
	private static const ZOOM_IN_THRESHOLD : Number = 3
	private static const ZOOM_OUT_THRESHOLD : Number = 3.6
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
	public var numRows : Number = 11
	public var numColumns : Number = 100
	
	private var spacing : Number = 200
	private var padding : Number = 1500
	
	private var loader : BulkLoader
	private var renderers : Array /* of PhotoRenderer */ = []
	private var timer : Timer
	
	private var background : Shape
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  model
    //----------------------------------
    
    private var _model : IZoomModel
    
    public function get model() : IZoomModel
    {
        return _model
    }
    
    public function set model( value : IZoomModel ) : void
    {
        _model = value
        _model.addEventListener( ZoomModelEvent.CHANGE, model_changeHandler )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    public function addItem( item : * ) : void
    {    	
    	addRenderer( item )
    	model_changeHandler( null )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function model_changeHandler( event : ZoomModelEvent ) : void
    {
    	timer.reset()
    	timer.start()
    }
    
    private function timer_completeHandler( event : TimerEvent ) : void
    {
		var vp : Rectangle = model.viewport
		
		var factorX : Number =  width / scaleX
		var factorY : Number =  height / scaleY
		
		var window : Rectangle = new Rectangle( vp.x * factorX, vp.y * factorY,
		                            vp.width * factorX, vp.height * factorY )
		
		// TODO:
		// This is really inefficient =(
		// Implement some smart data structure (QuadTree) to quickly find all
		// visible renderers for dynamically loading a memory friendly resolution. 
		
		var numRenderers : uint = renderers.length
		
		for( var i : int = numRenderers - 1; i >= 0; i-- )
		{
			var renderer : PhotoRenderer = renderers[ i ]
			
			var bounds : Rectangle = renderer.getBounds( this )
                
			if( ( window.containsRect( bounds ) || bounds.containsRect( window ) )
			    && renderer.data )
			{
			   if( model.zoom > ZOOM_IN_THRESHOLD )
			   {
			       renderer.displayQuality = PhotoRenderer.MEDIUM			   	
			   }
               else if( model.zoom < ZOOM_OUT_THRESHOLD )
               {
                   renderer.displayQuality = PhotoRenderer.LOW               	
               }
			}
		}
    }	
	
    //--------------------------------------------------------------------------
    //
    //  Methods: Internal
    //
    //--------------------------------------------------------------------------
    
    private function addRenderer( data : * ) : void
    {
        var renderer : PhotoRenderer = new PhotoRenderer()
            renderers.push( renderer )
        
        var index : int = renderers.length - 1
        
        var row : uint = index % numRows
        var column : uint = Math.floor( index / numRows )
        
            renderer.x = padding + column * ( PhotoRenderer.DEFAULT_WIDTH + spacing )
            renderer.y = padding + row * ( PhotoRenderer.DEFAULT_HEIGHT + spacing )
            
            renderer.data = data
            renderer.loader = loader
            
            renderer.alpha = 0
            addChild( renderer )
            
            var newWidth : Number =  Math.min( column + 1, numColumns ) * ( PhotoRenderer.DEFAULT_WIDTH  + spacing ) + 2 * padding
            var newHeight : Number = Math.max( row, numRows ) * ( PhotoRenderer.DEFAULT_HEIGHT + spacing ) + 2 * padding
            
            resizeBackground( newWidth, newHeight )
            
			Tweener.addTween(
	                            renderer,
	                            {
	                                alpha: 1,
	                                time: 2,
	                                delay: index / 100 
	                            }
                            )
    }
    
	private function createBackground() : void
	{
		background = new Shape()
		resizeBackground( 100, 100 )
        addChild( background )
	}
	
	private function resizeBackground( width : Number, height : Number ) : void
	{
        var g : Graphics = background.graphics
        
            g.clear()
            g.beginFill( 0x333333, 0 )
            g.drawRect( 0, 0, width, height )
            g.endFill()
            
       dispatchEvent( new Event( "resize" ) )            
	}
	
    private function createTimer() : void
    {   
        timer = new Timer( RENDER_DELAY, 1 )
        timer.addEventListener( TimerEvent.TIMER_COMPLETE, timer_completeHandler )
    }
    
    private function createLoader() : void
    {   
        loader = new BulkLoader( "photoLoader" + Math.random().toString() )
        
        // TODO
        loader.logLevel = BulkLoader.LOG_ERRORS
    }
}

}