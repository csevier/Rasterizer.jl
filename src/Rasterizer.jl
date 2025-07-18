module Rasterizer
include("vec.jl")
include("triangle.jl")
include("mesh.jl")
include("primitives.jl")
include("colors.jl")
include("display.jl")
include("sdl.jl")
using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2
using .Display: make_framebuffer, 
                draw_pixel, 
                draw_rectangle, 
                draw_line, 
                draw_wireframe_triangle, 
                clear_framebuffer, 
                draw_mesh, 
                draw_filled_triangle, 
                set_rendermode, 
                RenderModes, 
                filled,
                wireframe,
                both,
                enable_culling,
                disable_culling

using .SDL: draw_framebuffer!
using .Colors: Color, RED
using .Vecs: Vec2
using .Triangles: Triangle
using .Primitives: make_cube
using .Meshs: load_obj


function init_sdl()
    @assert SDL_Init(SDL_INIT_EVERYTHING) == 0 "error initializing SDL: $(unsafe_string(SDL_GetError()))"
    window = SDL_CreateWindow("Rasterizer Renderer", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 640,  480, SDL_WINDOW_SHOWN)
    screen = SDL_CreateRGBSurface(0,320,240, 32, 0, 0, 0, 0)
    return window, screen
end

function handle_sdl_events(close)
    event_ref = Ref{SDL_Event}()
    while Bool(SDL_PollEvent(event_ref))
        evt = event_ref[]
        evt_ty = evt.type
        if evt_ty == SDL_QUIT
            close = true
        elseif evt_ty == SDL_KEYDOWN
            scan_code = evt.key.keysym.scancode
            if scan_code == SDL_SCANCODE_Q 
                close = true
            end
            if scan_code == SDL_SCANCODE_1 
                set_rendermode(filled)
            end
            if scan_code == SDL_SCANCODE_2
                println("setting to wirefram")
                set_rendermode(wireframe)
            end
            if scan_code == SDL_SCANCODE_3
                set_rendermode(both)
            end
            if scan_code == SDL_SCANCODE_4
                disable_culling()
            end
            if scan_code == SDL_SCANCODE_5
                enable_culling()
            end
        end
    end
    return close
end

function setup()
    window, screen = init_sdl()
    framebuffer = make_framebuffer()
    return framebuffer, window, screen
end

function main()
    framebuffer, window, screen = setup()
    close::Bool = false
    cube = make_cube()
    cube = load_obj("f22_z.obj")
    #cube = load_obj("train.obj")
    try
        last_frame = 0
        now = SDL_GetPerformanceCounter();
        dt::Float64 = 0
        last_ticks = SDL_GetTicks()
        while !close
            start = SDL_GetTicks()
            if (SDL_GetTicks() - last_ticks < 1000/60) 
                # its likely we have a moment right here to invoke the garbage collector
                GC.safepoint()
                continue
            end
            last_ticks = SDL_GetTicks()
            
            last_frame = now
            now = SDL_GetPerformanceCounter()
            dt = (now - last_frame) * 1000 / SDL_GetPerformanceFrequency();
        
            close = handle_sdl_events(close)
            update()
            draw(framebuffer, window, screen, cube)
        end
    finally
        teardown(window)
    end
end
    
function update()
end

function draw(framebuffer, window, screen, cube)
    win_surf = SDL_GetWindowSurface(window)
    width = Ref{Int32}()
    height = Ref{Int32}()
    SDL_GetWindowSize(window, width, height)
    window_rect = SDL_Rect(0,0, width.x, height.x)
    SDL_FillRect(win_surf, Ref(window_rect), 0)
    clear_framebuffer(framebuffer, Color(0,0,0,255))
    draw_mesh(framebuffer, cube)
    draw_line(framebuffer,1,1, 320,1, RED)
    draw_line(framebuffer,1,1, 1,240, RED)
    draw_line(framebuffer,1,240, 320,240, RED)
    draw_line(framebuffer,320,1, 320,240, RED)
    draw_framebuffer!(framebuffer, screen)
    SDL_BlitScaled(screen, C_NULL, win_surf, Ref(window_rect))
    SDL_UpdateWindowSurface(window)
end

function teardown(window)
    SDL_DestroyWindow(window)
    SDL_Quit()
end
end # module Rasterizer
