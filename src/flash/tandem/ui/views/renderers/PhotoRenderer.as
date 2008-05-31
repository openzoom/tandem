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
package tandem.ui.views.renderers
{
	
import br.com.stimuli.loading.BulkLoader;

import caurina.transitions.Tweener;

import com.adobe.webapis.flickr.Photo;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import tandem.core.IDataRenderer;
import tandem.events.TandemEvent;
import tandem.model.ApplicationModel;
import tandem.util.PhotoDimension;
import tandem.util.PhotoUtil;

public class PhotoRenderer extends Sprite implements IDataRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     */
	public function PhotoRenderer()
	{
		interactive = false
		createBackground()
	}
	
    //--------------------------------------------------------------------------
    //
    //  Class Constants
    //
    //--------------------------------------------------------------------------
    
	public static const DEFAULT_WIDTH : Number = 1000
	public static const DEFAULT_HEIGHT : Number = 1000
	public static const BORDER_THICKNESS : Number = 24
	
	public static const NONE : String = "none"
	public static const LOW : String = "low"
	public static const MEDIUM : String = "medium"
	public static const HIGH : String = "high"

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
	private var background : Shape
	private var backgroundColor : uint
	
	private var url : String
	
	private var image : Bitmap
	private var imageHolder : Bitmap
	
    private static var priority : uint = 1000
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  displayQuality
    //----------------------------------
    
    private var _displayQuality : String
    
    public function get displayQuality() : String
    {
        return _displayQuality
    }
    
    public function set displayQuality( value : String ) : void
    {
    	if( _displayQuality == value )
    	   return
    	   
        _displayQuality = value
        
        switch( displayQuality )
        {
        	case LOW:
				load( PhotoDimension.THUMBNAIL )
                break        		
        	
            case MEDIUM:
                load( PhotoDimension.MEDIUM )
                break
               
            case HIGH:
               load( PhotoDimension.LARGE )
               break
               
            case NONE:
               unload()
               break
        }
    }
    
    //----------------------------------
    //  data
    //----------------------------------
    
    private var _data : Photo
    
    public function get data() : Object
    {
        return _data
    }
    
    public function set data( value : Object ) : void
    {
        _data = Photo( value )
        dispatchEvent( new TandemEvent( TandemEvent.DATA_CHANGE ) )
    }
    
    //----------------------------------
    //  loader
    //----------------------------------
    
    public var loader : BulkLoader
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    private function load( dimension : String = PhotoDimension.MEDIUM ) : void
    {
        url = PhotoUtil.getPhotoURL( Photo( data ), dimension ) 
        loader.add( url, { priority: priority++ } )
        loader.get( url ).addEventListener( Event.COMPLETE, loadCompleteHandler, false, 0, true )
        loader.start()
    }
    
    private function unload() : void
    {    	
        if( image && contains( image ) )
            removeChild( image )
    	
        if( image )
            image = null
       
        Tweener.addTween(
						    background,
						    {
                                _color: backgroundColor,
                                time: 0
						    }
		                )             
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
	private function loadCompleteHandler( event : Event ) : void
	{		
		if( loader.get( url ) )
            loader.get( url ).removeEventListener( Event.COMPLETE, loadCompleteHandler )
            
        if( image )			
		    imageHolder = image

	    image = loader.getBitmap( url, true )
		
		
		// FIXME: NPE prevention
		if( !image )
            return
		
        if( displayQuality == LOW || displayQuality == NONE )
            image.smoothing = false
	    else
            image.smoothing = true    
		
		var scale : Number = Math.min( DEFAULT_WIDTH / image.width,
                                       DEFAULT_HEIGHT / image.height )
                                       
        image.scaleX  = image.scaleY = scale
        
        image.x = ( DEFAULT_WIDTH - image.width ) / 2
        image.y = ( DEFAULT_HEIGHT - image.height ) / 2
        
        image.alpha = 0
        
    	addChild( image )
    	
        
        // background      
        Tweener.addTween(
                           background,
                           {
                               _color: 0xFFFFFF,
                               x: image.x - BORDER_THICKNESS,
                               y: image.y - BORDER_THICKNESS,
                               width: image.width + 2 * BORDER_THICKNESS,
                               height: image.height + 2 * BORDER_THICKNESS,
                               time: 0.8
                           }
                        )
                        
        // image
        Tweener.addTween(
                           image,
                           {
                               alpha: 1,
                               time: 2,
                               onComplete: removeImageHolder
                           }
                        )
                        
        // Create link to orignal photo on Flickr
        if( displayQuality != LOW && displayQuality != NONE )
        {
            interactive = true
        	addEventListener( MouseEvent.DOUBLE_CLICK, doubleClickHandler )
        }
        else
        {
            if( hasEventListener( MouseEvent.DOUBLE_CLICK ) )
                removeEventListener( MouseEvent.DOUBLE_CLICK, doubleClickHandler )        	
        }                  
 	}
 	
 	private function doubleClickHandler( event : MouseEvent ) : void
 	{
 		// TODO: Clean up
 		var model : ApplicationModel = ApplicationModel.getInstance()
 		
 		var url : String
 		var photo : Photo = Photo( data )
 		
 		if( model.user.url )
            url = model.user.url + photo.id
        else
            url = "http://flickr.com/photos/" + model.user.nsid + "/" + photo.id
 		
 		var request : URLRequest = new URLRequest( url )
 		navigateToURL( request, "_blank" )
 	}
 	
    //--------------------------------------------------------------------------
    //
    //  Methods: Helper
    //
    //--------------------------------------------------------------------------
	
	private function createBackground() : void
	{
        background = new Shape()
        
        var g : Graphics = background.graphics
        
        var seed : Number = 0.2 + ( Math.random() * 0.6 )
        backgroundColor = seed * 0xFF << 16 | seed * 0xFF << 8 | seed * 0xFF
        
        g.beginFill( backgroundColor )
        
        if( Math.random() > 0.5 )
        {
            g.drawRect( 0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT * 0.75 )
            background.y = DEFAULT_HEIGHT * 0.125
        }
        else
        {
            g.drawRect( 0, 0, DEFAULT_WIDTH * 0.75, DEFAULT_HEIGHT )
            background.x = DEFAULT_WIDTH * 0.125
        }

        g.endFill()
        
        addChildAt( background, 0 )
	}
	
    private function removeImageHolder() : void
    {
        if( imageHolder && contains( imageHolder ) )
        {
            removeChild( imageHolder )
            imageHolder = null
        }
    }
	
	private function get interactive() : Boolean
	{
		return mouseChildren
	}
	
	private function set interactive( value : Boolean ) : void
	{
        //buttonMode = value
        mouseChildren = !value
        doubleClickEnabled = value
	}
}

}