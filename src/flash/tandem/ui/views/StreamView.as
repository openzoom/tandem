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

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;

import tandem.core.IZoomable;
import tandem.core.ZoomModel;
import tandem.core.ZoomModelEvent;
import tandem.ui.views.renderers.PhotoRenderer;
import tandem.util.SystemUtil;


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
        createRenderers()
	}
	
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
	private static const RENDER_DELAY : Number = 125
	private static const ZOOM_THRESHOLD : Number = 3
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
	public var numRows : Number = 11
	public var numColumns : Number = 33
	
	private var spacing : Number = 180
	private var padding : Number = 1000
	
	private var loader : BulkLoader
	private var renderers : Array /* of PhotoRenderer */
	private var timer : Timer
	
	private var background : Sprite
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	
    //----------------------------------
    //  dataProvider
    //----------------------------------
    
	private var _dataProvider : Array /* of IDataRenderer */
	
	public function get dataProvider() : Array
    {
        return _dataProvider
    }
    
    public function set dataProvider( value : Array ) : void
    {
        _dataProvider = value
        populateRenderers()
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
        _model = value
        _model.addEventListener( ZoomModelEvent.CHANGE, modelChangeHandler )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    private function modelChangeHandler( event : ZoomModelEvent ) : void
    {
    	timer.reset()
    	timer.start()
    }
    
    private function timerCompleteHandler( event : TimerEvent ) : void
    {
		var vp : Rectangle = model.viewport
		
		var factorX : Number =  width / scaleX
		var factorY : Number =  height / scaleY
		var margin : Number = 0
		
		var window : Rectangle = new Rectangle( vp.x * factorX, vp.y * factorY,
		                            vp.width * factorX, vp.height * factorY )
		
		// TODO:
		// This is really inefficient =(
		// Implement some smart data structure (QuadTree) to quickly find all
		// visible renderers for dynamically loading a memory friendly resolution. 
		
		var numRenderers : uint = renderers.length
		
		for( var i : int = 0; i < numRenderers; i++ )
		{
			var renderer : PhotoRenderer = renderers[ i ]
			
			var bounds : Rectangle = renderer.getBounds( this )
                
			if( ( window.containsRect( bounds ) || bounds.containsRect( window ) )
			    && renderer.data )
			{
			   if( model.zoom >= ZOOM_THRESHOLD )
			       renderer.displayQuality = PhotoRenderer.MEDIUM
               else
                   renderer.displayQuality = PhotoRenderer.LOW
			}
		}
    }	
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	private function createRenderers() : void
	{
		renderers = []
		
		for( var column : uint = 0; column < numColumns; column++ )
		{
    		for( var row : uint = 0; row < numRows; row++ )
			{
				var renderer : PhotoRenderer = new PhotoRenderer()
				
					renderer.x = padding + column * ( PhotoRenderer.DEFAULT_WIDTH + spacing )
					renderer.y = padding + row * ( PhotoRenderer.DEFAULT_HEIGHT + spacing )

                    renderer.loader = loader
                    
			    renderers.push( renderer )
			    addChild( renderer )
			}
		}
	}
    
    private function populateRenderers() : void
    {
        renderers.forEach(
                function( item : *, index : int, array : Array ) : void
                {
                    var renderer : PhotoRenderer = PhotoRenderer( item )
                    
                    if( dataProvider[ index ] != null )
                    {
                       renderer.data = dataProvider[ index ]
                    }
                }                 
            )
        timerCompleteHandler( null )
    }
	
	private function createBackground() : void
	{
		background = new Sprite()
		
		var g : Graphics = background.graphics
		    g.beginFill( 0x222222, 0 )
		    g.drawRect(
		                0,
		                0,
		                numColumns * ( PhotoRenderer.DEFAULT_WIDTH  + spacing ) + 2 * padding,
		                numRows    * ( PhotoRenderer.DEFAULT_HEIGHT + spacing ) + 2 * padding
		              )
		              
		    g.endFill()
	  
	  addChild( background )
		
	}
	
    private function createTimer() : void
    {   
        timer = new Timer( RENDER_DELAY, 1 )
        timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler )
    }
    
    private function createLoader() : void
    {   
        loader = new BulkLoader( "photoLoader" + Math.random().toString() )
        
        // TODO
        loader.logLevel = BulkLoader.LOG_ERRORS
    }
}

}