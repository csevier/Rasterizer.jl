module Meshs
using ..Vecs: Vec3
using ..Triangles: Face
export Mesh, load_obj
mutable struct Mesh
    vertices::Vector{Vec3}
    faces::Vector{Face}
    rotation::Vec3
end

function load_obj(file::String)::Mesh
    verts = []
    faces =[]
    lines = readlines(file) # change to eachline for big files
    for line in lines
        sections = split(line, " ")
        linetype = sections[1]

        if linetype == "v"
            x = sections[2]
            y = sections[3]
            z = sections[4]
            push!(verts, Vec3(parse(Float64, x), parse(Float64, y),parse(Float64, z)))
        elseif linetype == "f"
            p1 = sections[2]
            p1_data = split(p1, "/")
            p1_index = p1_data[1]
            p1_texture_index = p1_data[2]
            p1_normal_index = p1_data[3]
            p2 = sections[3]
            p2_data = split(p2, "/")
            p2_index = p2_data[1]
            p2_texture_index = p2_data[2]
            p2_normal_index = p2_data[3]
            p3 = sections[4]
            p3_data = split(p3, "/")
            p3_index = p3_data[1]
            p3_texture_index = p3_data[2]
            p3_normal_index = p3_data[3]
            push!(faces, Face((parse(Int64, p1_index), parse(Int64, p2_index),parse(Int64, p3_index))))
        end

    end
    return Mesh(verts, faces, Vec3(0.0,0.0,0.0))
end
end