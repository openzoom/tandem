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

import flash.display.GradientType;
import flash.display.Loader;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.net.URLRequest;

public class CollectionsView extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
        
    public function CollectionsView()
    {
        var matrix : Matrix = new Matrix()
            matrix.createGradientBox( 1000, 200, Math.PI / 4 )
            
        graphics.beginGradientFill( GradientType.RADIAL, [ 0x444444, 0xCCCCCC ],
                                    [ 1, 1 ], [ 0, 1000 ], matrix )
        graphics.drawRect( 0, 0, 2806, 1910 )
        graphics.endFill()
        
        loader = new Loader()
        loader.load( new URLRequest( "http://farm3.static.flickr.com/2244/1515174917_821d43b5cf_o.jpg" ) )
        addChild( loader )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Children
    //
    //--------------------------------------------------------------------------
    
    private var loader : Loader
    
}
    
}