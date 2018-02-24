--[[
Simple clock, written using imlib. Edited by Etles_Team (2016)
Make sure you've installed "imlib2" application in your system if this script doesn't work :) 

To use this script in Conky, Add this command in conkyrc file before (TEXT), Example :

lua_load ~/.conky/Conky-Name/imlib_clock.lua
lua_draw_hook_pre imlib_clock theme

OR you can add this other command to load script in conkyrc after (TEXT), Example :

${lua imlib_clock theme-name 120 100 100}

]]
---------------------------------------------------------------------------------------------------------

require 'imlib2'

image_path = os.getenv ('HOME')..'/.config/conky/images/'

function fFreeImage (image)
	imlib_context_set_image(image)
--	imlib_free_image ()
end

function fRotateImage (image, arc)
	imlib_context_set_image(image)
	return imlib_create_rotated_image(arc)
end

function fGetImageSize(image)
	imlib_context_set_image(image)
	return imlib_image_get_width(), imlib_image_get_height()
end

function create_clock(theme, arc_s, arc_m, arc_h)

local imgFace =  imlib_load_image(image_path..theme..'/face.png')
local w_img, h_img = fGetImageSize(imgFace)

local imgH =  imlib_load_image(image_path..theme..'/h.png')
local imgHR = fRotateImage (imgH, arc_h)
local w_imgH, h_imgH = fGetImageSize(imgHR)

local imgM =  imlib_load_image(image_path..theme..'/m.png')
local imgMR = fRotateImage (imgM, arc_m)
local w_imgM, h_imgM = fGetImageSize(imgMR)

local imgS =  imlib_load_image(image_path..theme..'/s.png')
local imgSR = fRotateImage (imgS, arc_s)
local w_imgS, h_imgS = fGetImageSize(imgSR)

local imgGlass =  imlib_load_image(image_path..theme..'/glass.png')

local buffer = imlib_create_image(w_img, h_img)
	imlib_context_set_image(buffer)
	imlib_image_set_has_alpha(1)
	imlib_image_clear()

imlib_blend_image_onto_image(imgFace, 1, 0, 0, w_img, h_img, 0, 0, w_img, h_img )

imlib_blend_image_onto_image(imgHR, 1, 0, 0, w_imgH, h_imgH, w_img/2-w_imgH/2, h_img/2-h_imgH/2, w_imgH, h_imgH )

imlib_blend_image_onto_image(imgMR, 1, 0, 0, w_imgM, h_imgM, w_img/2-w_imgM/2, h_img/2-h_imgM/2, w_imgM, h_imgM )

imlib_blend_image_onto_image(imgSR, 1, 0, 0, w_imgS, h_imgS, w_img/2-w_imgS/2-1, h_img/2-h_imgS/2-1, w_imgS, h_imgS )

--imlib_blend_image_onto_image(imgGlass, 1, 70, 70, w_img, h_img, 0, 0, w_img, h_img )

	fFreeImage (imgFace)
	fFreeImage (imgH)
	fFreeImage (imgHR)
	fFreeImage (imgM)
	fFreeImage (imgMR)
	fFreeImage (imgS)
	fFreeImage (imgSR)
	fFreeImage (imgGlass)

	return buffer

end

function conky_imlib_clock(theme,w,x,y,z)

	if conky_window==nil then return ' ' end

	local w = w or 200
	local x = x or conky_window.width / 2
	local y = y or conky_window.height / 2

	local arc_s = (2 * math.pi / 60) * os.date("%S")
	local arc_m = (2 * math.pi / 60) * os.date("%M") + arc_s / 60
	local arc_h = (2 * math.pi / 12) * os.date("%I") + arc_m / 12

	local buffer = create_clock(theme, arc_s, arc_m, arc_h)
	imlib_context_set_image(buffer)

	imlib_render_image_on_drawable_at_size(
		x-w/2, y-w/2, w, w)

	fFreeImage (buffer)

	return ' '
end
--======================== Regards, Etles_Team ===========================--
