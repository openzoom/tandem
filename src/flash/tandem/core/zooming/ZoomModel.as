////////////////////////////////////////////////////////////////////////////////
//
//  tandem. explore your world.
//  Copyright (c) 2007–2008 Daniel Gasienica (daniel@gasienica.ch)
//
//  The ZoomModel class is inspired by the work of
//  Rick Companje, http://www.companje.nl/
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
package tandem.core.zooming
{

import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

public class ZoomModel extends EventDispatcher implements IZoomModel
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  zoom
    //----------------------------------
    
    private var _zoom : Number = 1
    
    public function get zoom() : Number
    {
        return _zoom
    }    
    
    //----------------------------------
    //  minZoom
    //----------------------------------
    
    private var _minZoom : Number = 1
    
    public function get minZoom() : Number
    {
        return _minZoom
    }
    
    public function set minZoom( value : Number ) : void
    {
        _minZoom = value
        zoomTo( _zoom )
    }
    
    //----------------------------------
    //  maxZoom
    //----------------------------------
    
    private var _maxZoom : Number = 100
    
    public function get maxZoom() : Number
    {
        return _maxZoom
    }
    
    public function set maxZoom( value : Number ) : void
    {
        _maxZoom = value
        zoomTo( _zoom )
    }
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : Rectangle = new Rectangle()
    
    public function get viewport() : Rectangle
    {
        return _viewport.clone()
    }
      
    //----------------------------------
    //  viewAspectRatio
    //----------------------------------
    
    private var _viewAspectRatio : Number = 1
    
    public function get viewAspectRatio() : Number
    {
        return _viewAspectRatio
    }
    
    public function set viewAspectRatio( value : Number ) : void
    {
        _viewAspectRatio = value
        zoomTo( _zoom )
    }

    //----------------------------------
    //  viewportAspectRatio
    //----------------------------------
    
    private var _viewportAspectRatio : Number = 1
    
    public function get viewportAspectRatio() : Number
    {
        return _viewportAspectRatio
    }
    
    public function set viewportAspectRatio( value : Number ) : void
    {
        _viewportAspectRatio = value
        zoomTo( _zoom )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Zooming
    //
    //--------------------------------------------------------------------------
    
    public function zoomBy( value : Number = 1.5, originX : Number = 0.5,
                            originY : Number = 0.5  ) : void
    {
    	zoomTo( zoom * value, originX, originY )
    }
    
    public function zoomTo( value : Number, originX : Number = 0.5,
                            originY : Number = 0.5  ) : void
    {
        _zoom = value
        
        if ( _zoom < minZoom )
            _zoom = minZoom
            
        if ( _zoom > maxZoom)
            _zoom = maxZoom
            
        
        // remember old origin 
        var oldOrigin : Point = getViewportOrigin( originX, originY )
        
        // zoom
        var ratio : Number = viewAspectRatio / viewportAspectRatio
        
        if( ratio < 1 )
        {
        	// viewport.height < 1
            _viewport.width = 1 / _zoom
            _viewport.height =  ratio / _zoom
        }
        else
        {
            // viewport.width < 1
            _viewport.width =  1 / ratio / _zoom, 1
            _viewport.height = 1 / _zoom
        }

        // move new origin to old origin
        moveOriginTo( oldOrigin.x, oldOrigin.y, originX, originY )
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Panning
    //
    //--------------------------------------------------------------------------
    
    public function moveTo( x : Number, y : Number ) : void
    {        	
        _viewport.x = x
        _viewport.y = y
        

        if( _viewport.x < 0 )
        	_viewport.x = 0
        	
        if( _viewport.y < 0 )
        	_viewport.y = 0
        
        if( ( _viewport.x + _viewport.width ) > 1 )
        	_viewport.x = 1 - _viewport.width
        	
        if( ( _viewport.y + _viewport.height ) > 1 )
        	_viewport.y = 1 - _viewport.height            

        dispatchEvent( new ZoomModelEvent() )
    }
    
    public function moveBy( x : Number, y : Number ) : void
    {
        moveTo( _viewport.x + x, _viewport.y + y )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Helper
    //
    //--------------------------------------------------------------------------
    
    private function moveCenterTo( x : Number, y : Number ) : void
    {
        moveOriginTo( x, y, 0.5, 0.5 )
    }
    
    private function getViewportCenter() : Point
    {
        return getViewportOrigin( 0.5, 0.5 )
    }
    
    private function moveOriginTo( x : Number, y : Number,
                                   originX : Number, originY : Number ) : void
    {
        var newX : Number = x - _viewport.width * originX
        var newY : Number = y - _viewport.height * originY
                    
        moveTo( newX, newY )
    }
    
    private function getViewportOrigin( originX : Number,
                                        originY : Number ) : Point
    {
        var x : Number = _viewport.x + _viewport.width * originX
        var y : Number = _viewport.y + _viewport.height * originY
       
        return new Point( x, y )
    }
}

}