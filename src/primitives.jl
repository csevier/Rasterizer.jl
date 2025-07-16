module Primitives
using ..Meshs: Mesh
using ..Vecs: Vec3
using ..Triangles: Face
export make_cube

function make_cube()::Mesh
    vertices = [Vec3(-1.0, -1.0, 1.0),
                Vec3(1.0, -1.0, 1.0), 
                Vec3(-1.0, 1.0, 1.0), 
                Vec3(1.0, 1.0, 1.0), 
                Vec3(-1.0, 1.0, -1.0), 
                Vec3(1.0, 1.0, -1.0), 
                Vec3(-1.0, -1.0, -1.0), 
                Vec3(1.0, -1.0, -1.0)]
    faces = [Face((1,2,3)),
             Face((3,2,4)),
             Face((3,4,5)),
             Face((5,4,6)),
             Face((5,6,7)),
             Face((7,6,8)),
             Face((7,8,1)),
             Face((1,8,2)),
             Face((2,8,4)),
             Face((4,8,6)),
             Face((7,1,5)),
             Face((5,1,3))
    ]
    return Mesh(vertices, faces, Vec3(0.0, 0.0, 0.0))
end
end