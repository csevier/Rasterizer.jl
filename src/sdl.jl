module SDL
using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
export draw_framebuffer!

function draw_framebuffer!(framebuffer::Matrix{UInt32}, surface_pointer::Ptr{SDL_Surface})
    surface = unsafe_load(surface_pointer)
    pixels = Base.unsafe_convert(Ptr{UInt32}, surface.pixels)
    for x in range(1, 320)
        for y in range(1, 240)
            color = framebuffer[x, y]
            sdl_x = x 
            sdl_y = y - 1
            #println("x:$sdl_x, y:$sdl_y")
            screen_index = (sdl_y * 320) + sdl_x
            unsafe_store!(pixels, color, screen_index)
        end
    end
end
end