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
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.geom.Matrix;

public class SetsView extends Sprite
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
    * Constructor.
    */
    public function SetsView()
    {
    	var matrix : Matrix = new Matrix()
    	    matrix.createGradientBox( 100000, 20000, Math.PI / 4 )
    	    
    	graphics.beginGradientFill( GradientType.LINEAR, [ 0xFF6600, 0xFF0000 ],
    	                            [ 1, 1 ], [ 0, 255 ], matrix, SpreadMethod.REFLECT )
        graphics.drawRect( 0, 0, 100000, 20000 )
        graphics.endFill()
    }
    
}
    
}