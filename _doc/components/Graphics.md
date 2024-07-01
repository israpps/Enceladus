---
title: Graphic functions
sections:
  - Primitive shapes
  - Images
  - Screen
  - 3D
  - Fonts
---

--------
### Primitive shapes
Draw the most basic shapes on screen

#### Graphics.drawPixel(x, y, color)
Sets a screen pixel on a given color
##### Parameters:
`x` & `y`: Screen coordinates for drawing the pixel  
`color`: the color of the pixel, in GS RGBA (see `Color.new()`)
#### Graphics.drawRect(x, y, width, height, color)
Draws a rectangle
##### Parameters:
`x` & `y`: Screen coordinates for the top left edge of the rectangle.  
`width` & `height`: width and height of the rectangle.
`color`: the color of the pixel, in GS RGBA (see `Color.new()`)
#### Graphics.drawLine(x, y, x2, y2, color)
Draws a line
##### Parameters:
`x` & `y`: Screen coordinates for line begining.  
`x2` & `y2`: Screen coordinates for line ending.  
`color`: the color of the pixel, in GS RGBA (see `Color.new()`)
#### Graphics.drawCircle(x, y, radius, color, filled)
Draws a circle
##### Parameters:
`x` & `y`: Screen coordinates for circle center.  
`radius`: Circle radius.  
`color`: the color of the pixel, in GS RGBA (see `Color.new()`)
`filled`: if the whole circle surface is drawn or only the permiter. **This parameter is not mandatory**
#### Graphics.drawTriangle(x, y, x2, y2, x3, y3, color, color2, color3) 
color2 and color3 parameters are not mandatory
#### Graphics.drawQuad(x, y, x2, y2, x3, y3, x4, y4 color, color2, color3, color4) 
color2, color3 and color4 parameters are not mandatory

--------
### Images
Load and display images on screen


#### image = Graphics.loadImage(path) 
Loads an image and uploads it to the GS VRAM. Supports __BMP__, __JPG__ and __PNG__.

> small tip: to avoid wasting VRAM. make sure the images width and height are ALWAYS a power of 2  
> eg: a `120x120` (120 not power of 2) image will eat the same VRAM than a `128x128` image (notice 128 is a power of 2), but with less quality

##### Parameters:
`path`: relative or absolute path to the image to be loaded.    
if something fails, it returns nil.   
#### Graphics.drawImage(image, x, y, color)
Draws an image on the screen.
##### Parameters:
`image`: the desired image to be displayed. (the return value of `Graphics.loadImage(path)`)  
`x` & `y`: screen coordinates for the top left corner of the image  
`color`: color mask for altering the image color **This parameter is not mandatory**  
#### Graphics.drawRotateImage(image, x, y, angle, color)
##### Parameters:
same than `Graphics.drawImage()`.  
`angle`: indicates the image rotation
#### Graphics.drawScaleImage(image, x, y, witdh, height, color)
Draws an image on the screen, but with custom witdh and height.
##### Parameters:
`image`: the desired image to be displayed. (the return value of `Graphics.loadImage(path)`)  
`x` & `y`: screen coordinates for the top left corner of the image  
`witdh` & `height`: on-screen witdh and height for the image.  
`color`: color mask for altering the image color **This parameter is not mandatory**  
#### Graphics.drawPartialImage(image, x, y, start_x, start_y, width, height, color)
##### Parameters:
`image`: the desired image to be displayed. (the return value of `Graphics.loadImage(path)`)  
`x` & `y`: screen coordinates for the top left corner of the image  
`start_x` & `start_y`: coordinates inside the image for the portion to be drawn  
`witdh` & `height`: width and height of the image portion to be drawn.  
`color`: color mask for altering the image color **This parameter is not mandatory**  
#### Graphics.drawImageExtended(image, x, y, start_x, start_y, width, height, scale_x, scale_y, angle, color)
same than `Graphics.drawPartialImage()` but with parameters for rotation and altering the image portion width and height on screen
##### Parameters:
`scale_x` & `scale_y`: on-screen width and height for the image portion drawn  
`angle`: rotation of the image portion
#### Graphics.setImageFilters(image, filter)
Applies a filter to the image when drawing.
##### Parameters:
`image`: the desired image to apply the filter into. (the return value of `Graphics.loadImage(path)`)  
`filter`: filter type:
- `NEAREST`
- `LINEAR`
#### width = Graphics.getImageWidth(image)
obtain the width of an image
##### Parameters:
`image`: the desired image to obtain Width from. (the return value of `Graphics.loadImage(path)`)  
#### height = Graphics.getImageHeight(image)
obtain the Height of an image
##### Parameters:
`image`: the desired image to obtain Height from. (the return value of `Graphics.loadImage(path)`)  
#### Graphics.freeImage(image)
Frees the image from both the RAM and VRAM. use this when the image will no longer be used. of it you need to make space on VRAM
##### Parameters:
`image`: the desired image to be freed. (the return value of `Graphics.loadImage(path)`)  


--------
### Screen
Screen related functions
#### Screen.clear(color) 
Clears the screen from any drawn object
##### Parameters:
`color`: Color of the background, generated with `Color.new()`. **this parameter isn't mandatory, defaults to Black**
#### Screen.flip()
Performs the screen drawing.
#### freevram = Screen.getFreeVRAM()
Returns the ammount of free VRAM from the GS chip (in kbytes)
#### fps = Screen.getFPS(frame_interval)
Measure FPS based on frame interval
#### Screen.setVSync(bool)
Set Vertical Sync
#### Screen.waitVblankStart()

#### Screen.setMode(mode, width, height, colormode, interlace, field, zbuffering, zbuf_colormode)
Sets the video mode, screen size and other parameters  

> Default NTSC mode(3D disabled): `Screen.setMode(NTSC, 640, 448, CT24, INTERLACED, FIELD)`  
> Default NTSC mode(3D enabled): `Screen.setMode(NTSC, 640, 448, CT24, INTERLACED, FIELD, true, Z16S)`  
> Default PAL mode(3D disabled): `Screen.setMode(PAL, 640, 512, CT24, INTERLACED, FIELD)`  
> Default PAL mode(3D enabled): `Screen.setMode(PAL, 640, 512, CT24, INTERLACED, FIELD, true, Z16S)`  
`mode`: `NTSC`, `_480p`, `PAL`, `_576p`, `_720p`, `_1080i`  
`width`: screen width  
`height` screen height  
`colormode`: `CT16`, `CT16S`, `CT24`, `CT32`  
`interlace`: `INTERLACED`, `NONINTERLACED`  
`field`: `FIELD`, `FRAME`  
`zbuffering`: bool **This parameter is not mandatory**, defaults to `false`
`zbuf_colormode`: `Z16`, `Z16S`, `Z24`, `Z32` **This parameter is not mandatory**  
#### modetable = Screen.getMode()
returns currently set video mode parameters
##### Return value
Table:
- `modetable.mode`
- `modetable.interlace`
- `modetable.field`
- `modetable.dithering`
- `modetable.doubleBuffering`
- `modetable.zBuffering`
- `modetable.width`
- `modetable.height`
- `modetable.aspect`
- `modetable.colormode`

--------
### 3D
- Remember to enable zbuffering on screen mode

#### Render.init(aspect)
Initializes the render aspect ratio.
##### Parameters:
`aspect`: render aspect ratio. `4/3` for default, `16/9` for widescreen.
#### model = Render.loadOBJ(path, texture)
##### Parameters:
`path`: location of the wavefront OBJ file to load. either relative or absolute path.
`texture`: path to the texture for the 3D model. (the return value of `Graphics.loadImage(path)`) **This parameter is not mandatory**
##### Return value
The loaded 3D model, to be used later.
#### Render.drawOBJ(model, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z)
Draws the 3D model.
##### Parameters:
`model`: the 3D model to draw. (the return value of `Render.loadOBJ()`)
`pos_x`, `pos_y`, `pos_z`: __X__, __Y__ and __Z__ axis position of the model on-screen
`rot_x`, `rot_y`, `rot_z`: __X__, __Y__ and __Z__ axis rotation of the model on-screen
#### Render.freeOBJ(model)
Free a 3d model from the EE RAM
##### Parameters:
`model`: the 3D model to free. (the return value of `Render.loadOBJ()`)

> Camera functions:

#### Camera.position(x, y, z)
Sets the camera position on the 3D space
#### Camera.rotation(x, y, z)
Set the camera rotation on its current position
> Lights functions:

#### Lights.create(count)
##### Parameters:
`count`: ammount of lights to be created.
#### Lights.set(light, dir_x, dir_y, dir_z, r, g, b, type)
`light`: the light index
`dir_x`, `dir_y`, `dir_z`: light positions on the 3D space.
`r`, `g`, `b`: red, green and blue colors of the light. integer 0-255
`type`: `AMBIENT`, `DIRECTIONAL` 

--------
### Fonts
Font drawing. splitted into 3 categories, image font, ROM Font and Freetype fonts

> Freetype fonts:
#### Font.ftInit()
Initialize the Freetype font system
#### font = Font.ftLoad(font)
loads a font into EE RAM
#### Parameters:
`font`: path to a TTF or OTF font file to be loaded.
#### Return value:
if font is successfully loaded, a font ID number will be returned, for using on the font drawing functions. if an error ocurrs a negative number is returned
#### Font.ftPrint(font, x, y, align, width, height, text, color)
Print on screen with the font
##### Parameters:
`font`: the Font ID to be used (return value of `Font.ftLoad()`)
`x`, `y`: screen coordinates for the text
`align`: alignment mode:
  - `0`: left aligned text
  - `8`: centered text (has issues handling multiline text)
`text`: text to write
`color`: Color generated by `Color.new()` **This parameter is not mandatory**
#### Font.ftSetPixelSize(font, width, height)
Changes the font size
#### Font.ftUnload(font)
Unloads the font from EE side.
#### Font.ftEnd()
De-inits the font system
> Image font functions:
#### font = Font.load(font)
Loads a font from an image. expects format to be __FNT__, __PNG__ or __BMP__
##### Parameters:
`font`: path to the image to load as font
##### Return value:
Font ID for further use.
#### Font.print(font, x, y, scale, text, color)
Print text with an image font
##### Parameters:
`font`: ID of the image font
`x`, `y`: coordinates of the text position
`scale`: general scale of the font size
`text`: text to be written
`color`: text color generated by `Color.new()`. **This parameter is not Mandatory**
#### Font.unload(font)
Unloads the Image font linked to that font ID
#### Parameters:
`font`: the font ID returned by `Font.load()`

> ROM Font Functions

the following functions are related to the PlayStation2 Builtin font: `rom0:FONTM`. this file is not present on some special PS2 variants such as PSX-DESR models. so keep it in mind.

#### Font.fmLoad()
Initializes the ROM Font system, reading and preparing the `rom0:FONTM` file
#### Font.fmPrint(x, y, scale, text, color) color isn't mandatory
Prints text with the console builtin font
`x`, `y`: coordinates of the text position
`scale`: general scale of the font size (can be a float number)
`text`: text to be written
`color`: text color generated by `Color.new()`. **This parameter is not Mandatory**
#### Font.fmUnload()
Unload the `rom0:FONTM` font from EE RAM
