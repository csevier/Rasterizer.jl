module Vecs
using LinearAlgebra
export Vec2, Vec3, dot, normalize, norm, magnitude, length, cross, rotate, rotate_x, rotate_y, rotate_z

mutable struct Vec2
    x::Float64
    y::Float64
end

Base.:+(v1::Vec2, v2::Vec2) = Vec2(([v1.x, v1.y]+[v2.x, v2.y])...)
Base.:-(v1::Vec2, v2::Vec2) = Vec2(([v1.x, v1.y]-[v2.x, v2.y])...)
Base.:*(v1::Vec2, scalar::Float64) = Vec2(([v1.x, v1.y] * scalar)...)
Base.:*(v1::Vec2, scalar::Int) = Vec2(([v1.x, v1.y] * scalar)...)
Base.:/(v1::Vec2, scalar::Float64) = Vec2(([v1.x, v1.y] / scalar)...)
Base.:/(v1::Vec2, scalar::Int) = Vec2(([v1.x, v1.y] / scalar)...)
Base.copy(vec::Vec2) = Vec2(vec.x, vec.y)
dot(vec::Vec2, vec2::Vec2) = LinearAlgebra.dot([vec.x, vec.y],[vec2.x, vec2.y])
normalize(vec::Vec2) = Vec2(LinearAlgebra.normalize([vec.x, vec.y])...)
norm(vec::Vec2) = LinearAlgebra.norm([vec.x, vec.y])
magnitude(vec::Vec2) = norm(vec)
length(vec::Vec2) = norm(vec)
rotate(vec::Vec2, angle::Float64) = Vec2(vec.x * cos(angle) - vec.y * sin(angle), 
                                         vec.x * sin(angle) + vec.y * cos(angle))

mutable struct Vec3
    x::Float64
    y::Float64
    z::Float64
end

Base.:+(v1::Vec3, v2::Vec3) = Vec3(([v1.x, v1.y, v1.z] + [v2.x, v2.y, v2.z])...)
Base.:-(v1::Vec3, v2::Vec3) = Vec3(([v1.x, v1.y, v1.z] - [v2.x, v2.y, v2.z])...)
Base.:*(v1::Vec3, scalar::Float64) = Vec3(([v1.x, v1.y, v1.z] * scalar)...)
Base.:*(v1::Vec3, scalar::Int) = Vec3(([v1.x, v1.y, v1.z] * scalar)...)
Base.:/(v1::Vec3, scalar::Float64) = Vec3(([v1.x, v1.y, v1.z] / scalar)...)
Base.:/(v1::Vec3, scalar::Int) = Vec3(([v1.x, v1.y, v1.z] / scalar)...)
Base.copy(vec::Vec3) = Vec3(vec.x, vec.y, vec.z)
dot(vec::Vec3, vec2::Vec3) = LinearAlgebra.dot([vec.x, vec.y, vec.z],[vec2.x, vec2.y, vec2.z])
normalize(vec::Vec3) = Vec3(LinearAlgebra.normalize([vec.x, vec.y, vec.z])...)
norm(vec::Vec3) = LinearAlgebra.norm([vec.x, vec.y, vec.z])
magnitude(vec::Vec3) = norm(vec)
length(vec::Vec3) = norm(vec)
cross(vec1::Vec3, vec2::Vec3) = Vec3(LinearAlgebra.cross([vec1.x, vec1.y, vec1.z], [vec2.x,vec2.y, vec2.z])...)
rotate_x(vec::Vec3, angle::Float64) = Vec3(vec.x, 
                                           vec.y * cos(angle) -vec.z * sin(angle), 
                                           vec.y * sin(angle) + vec.z * cos(angle))

rotate_y(vec::Vec3, angle::Float64) = Vec3(vec.x * cos(angle) -vec.z * sin(angle), 
                                           vec.y, 
                                           vec.x * sin(angle) + vec.z * cos(angle))

rotate_z(vec::Vec3, angle::Float64) = Vec3(vec.x * cos(angle) - vec.y * sin(angle), 
                                           vec.x * sin(angle) + vec.y * cos(angle), 
                                           vec.z)

end



