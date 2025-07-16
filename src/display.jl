module Display
using ..Vecs: Vec2, Vec3, rotate_x, rotate_y, normalize, cross, dot
using ..Triangles: Triangle
using ..Colors: Color, convert_to_RGB888
using ..Meshs: Mesh
export draw_pixel, draw_rectangle, draw_line, draw_wireframe_triangle, clear_framebuffer, draw_mesh, draw_filled_triangle

function draw_pixel(framebuffer::Matrix{UInt32}, x::Int, y::Int, color::Color)
    if x <= 320 && y <= 240 && x > 0 && y > 0
        framebuffer[x, y] = convert_to_RGB888(color)
    end
end

function draw_rectangle(framebuffer::Matrix{UInt32}, x::Int, y::Int, width::Int, height::Int, color::Color)
    for x in range(x, point.x + width)
        for y in range(y, y + height)
            if x<= 320 && y <= 240 && x > 0 && y > 0
                framebuffer[x, y] = convert_to_RGB888(color)
            end
        end
    end
end

function draw_line(framebuffer::Matrix{UInt32}, x1::Int, y1::Int, x2::Int, y2::Int, color::Color)
    delta_x = x2 - x1
    delta_y = y2 - y1

    longest_side_length = (abs(delta_x) >= abs(delta_y)) ? abs(delta_x) : abs(delta_y)

    x_increment = delta_x / longest_side_length
    y_increment = delta_y / longest_side_length
    current_x = x1;
    current_y = y1;
    for i in range(0, longest_side_length)
        draw_pixel(framebuffer, round(Int,current_x), round(Int, current_y), color)
        current_x += x_increment
        current_y += y_increment
    end
end

function draw_wireframe_triangle(framebuffer::Matrix{UInt32}, tri::Triangle, color::Color)
    draw_line(framebuffer, round(Int, tri.points[1].x), round(Int,tri.points[1].y), round(Int,tri.points[2].x), round(Int,tri.points[2].y), color)
    draw_line(framebuffer, round(Int, tri.points[2].x), round(Int,tri.points[2].y), round(Int,tri.points[3].x), round(Int,tri.points[3].y), color)
    draw_line(framebuffer, round(Int, tri.points[3].x), round(Int,tri.points[3].y), round(Int,tri.points[1].x), round(Int,tri.points[1].y), color)
end

function draw_filled_triangle(framebuffer::Matrix{UInt32}, tri::Triangle, color::Color)
    y_sorted = sort([tri.points[1], tri.points[2], tri.points[3]], by= point -> point.y)

    if isapprox(y_sorted[2].y,y_sorted[3].y)
        draw_flat_bottom(framebuffer, Triangle((y_sorted[1], y_sorted[2], y_sorted[3])),color)
    elseif isapprox(y_sorted[2].y, y_sorted[1].y)
        draw_flat_top(framebuffer, Triangle((y_sorted[1], y_sorted[2], y_sorted[3])), Color(0,255,0,255))
    else
        my = y_sorted[2].y
        println("should end half triangle writes at $my")
        mx = (((y_sorted[3].x - y_sorted[1].x) * (y_sorted[2].y - y_sorted[1].y)) / (y_sorted[3].y - y_sorted[1].y)) + y_sorted[1].x
        m = Vec2(mx, my)
        draw_flat_bottom(framebuffer, Triangle((y_sorted[1], y_sorted[2], m)),color)
        draw_flat_top(framebuffer, Triangle((y_sorted[2], m, y_sorted[3])), Color(0,255,0,255))
    end
end

function draw_flat_bottom(framebuffer::Matrix{UInt32}, tri::Triangle, color::Color)
    inv_slope_1 = (tri.points[2].x - tri.points[1].x) / (tri.points[2].y - tri.points[1].y)
    inv_slope_2 = (tri.points[3].x - tri.points[1].x) / (tri.points[3].y - tri.points[1].y)
    x_start = tri.points[1].x
    x_end = tri.points[1].x
    y_end = 0
    for y in range(tri.points[1].y, tri.points[3].y)
        draw_line(framebuffer, round(Int, x_start), round(Int, y), round(Int, x_end), round(Int,y), color)
        x_start += inv_slope_1
        x_end += inv_slope_2
        y_end = y
    end
    println("but flat bottom ended at $(y_end)")
end

function draw_flat_top(framebuffer::Matrix{UInt32}, tri::Triangle, color::Color)
    r3y = round(Int, tri.points[3].y)
    r1y = round(Int,tri.points[1].y)
    r2y = round(Int,tri.points[2].y)
    inv_slope_1 = (tri.points[3].x - tri.points[1].x) / (r3y - r1y)
    inv_slope_2 = (tri.points[3].x - tri.points[2].x) / (r3y - r2y)

    x_start = tri.points[3].x
    x_end = tri.points[3].x
    y_end =0
    for y in r3y:-1:r1y
        draw_line(framebuffer, round(Int, x_start), round(Int, y), round(Int, x_end), round(Int,y), color)
        x_start -= inv_slope_1
        x_end -= inv_slope_2
        y_end = y
    end
    println("and flat top ended at $(y_end)")
end

function draw_textured_triangle(framebuffer::Matrix{UInt32}, tri::Triangle) #uv coord.
end

function make_framebuffer()
   return zeros(UInt32, 320, 240)
end

function clear_framebuffer(framebuffer::Matrix{UInt32}, color::Color)
    fill!(framebuffer, convert_to_RGB888(color))
end

function draw_mesh(framebuffer, mesh::Mesh)
    mesh.rotation.x += .01
    for face in mesh.faces
        p1 = mesh.vertices[face.indexes[1]]
        cp1 = copy(p1)
        p2 = mesh.vertices[face.indexes[2]]
        cp2 = copy(p2)
        p3 = mesh.vertices[face.indexes[3]]
        cp3 = copy(p3)
        cp1 = rotate_x(cp1, mesh.rotation.x)
        cp2 = rotate_x(cp2, mesh.rotation.x)
        cp3 = rotate_x(cp3, mesh.rotation.x)
        cp1.z += 5
        cp2.z += 5
        cp3.z += 5

        if should_cull(cp1,cp2, cp3)
            continue
        end

        projected_p1 = project_perspective(cp1)
        projected_p2 = project_perspective(cp2)
        projected_p3 = project_perspective(cp3)

        projected_p1.x += (320 / 2);
        projected_p1.y += (240 / 2);
        projected_p2.x += (320 / 2);
        projected_p2.y += (240 / 2);
        projected_p3.x += (320 / 2);
        projected_p3.y += (240 / 2);
        draw_filled_triangle(framebuffer, Triangle((projected_p1,projected_p2,projected_p3)), Color(255,0,0,255))
        #draw_wireframe_triangle(framebuffer, Triangle((projected_p1,projected_p2,projected_p3)), Color(255,255,255,255))
    end
end

function project_orth(vec::Vec3)::Vec2
    return Vec2(vec.x, vec.y)
end

function project_perspective(vec::Vec3)::Vec2
    fov_factor::Int = 320;
    return Vec2( (fov_factor * vec.x) / vec.z, (fov_factor * vec.y) / vec.z)
end

function should_cull(a, b, c)
        ab = b-a
        ac = c-a
        ab = normalize(ab)
        ac = normalize(ac)

        normal = cross(ab, ac)
        normal = normalize(normal)

        #todo, there will be a camera in the future, its 0, 0 ,0 fr now
        origin_cam = Vec3(0.0, 0.0, 0.0)
        cam_ray = origin_cam - a
        dot_normal = dot(normal, cam_ray)

        return dot_normal < 0 # facing camera if positive
end

end