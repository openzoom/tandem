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
package tandem.util
{

import com.adobe.webapis.flickr.Photo;
	
	
public class PhotoUtil
{	
	public static function getPhotoURL( photo : Photo,
	                                    dimension : String ) : String
	{
		var url : String
		
		if( dimension == PhotoDimension.ORIGINAL )
		{
            url = "http://farm" + photo.farmId + ".static.flickr.com/" 
                   + photo.server + "/" + photo.id + "_" + photo.originalSecret 
            	   + getPhotoDimensionSuffix( dimension ) + "."
            	   + photo.originalFormat
		}
		else
		{
		    url = "http://farm" + photo.farmId + ".static.flickr.com/" 
	                + photo.server + "/" + photo.id + "_" + photo.secret
	                + getPhotoDimensionSuffix( dimension ) + ".jpg"
		}
		
		return url 
	}
	
	public static function getPhotoDimensionSuffix( dimension : String ) : String
	{
		var suffix : String
		
		switch( dimension )
		{
            case PhotoDimension.SQUARE:
                 suffix = PhotoDimension.SQUARE_SUFFIX
                 break
                 
            case PhotoDimension.THUMBNAIL:
                 suffix = PhotoDimension.THUMBNAIL_SUFFIX
                 break
                 
            case PhotoDimension.SMALL:
                 suffix = PhotoDimension.SMALL_SUFFIX
                 break
                 
            case PhotoDimension.MEDIUM:
                 suffix = PhotoDimension.MEDIUM_SUFFIX
                 break
                 
            case PhotoDimension.LARGE:
                 suffix = PhotoDimension.LARGE_SUFFIX
                 break
                 
            case PhotoDimension.ORIGINAL:
                 suffix = PhotoDimension.ORIGINAL_SUFFIX
                 break
                 
            default:
                suffix = PhotoDimension.MEDIUM_SUFFIX
		}
		
		return suffix
	}
}
	
}