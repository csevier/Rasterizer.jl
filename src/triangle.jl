
module Triangles
using ..Vecs: Vec2, Vec3
export Face, Triangle, calculate_z_depth

mutable struct Face
  indexes::Tuple{Int, Int, Int}
end

mutable struct Triangle
  points::Tuple{Vec2, Vec2, Vec2}
  z_depth::Float64
  Triangle(points::Tuple{Vec2, Vec2, Vec2}) = new(round_points(points), 0.0)
  Triangle(points::Tuple{Vec2, Vec2, Vec2}, z::Float64) = new(round_points(points), z)
end

function round_points(points::Tuple{Vec2, Vec2, Vec2})
  return (Vec2(round(Int, points[1].x), round(Int, points[1].y)),
          Vec2(round(Int, points[2].x), round(Int, points[2].y)),
          Vec2(round(Int, points[3].x), round(Int, points[3].y)))
end


function calculate_z_depth(p1::Vec3, p2::Vec3, p3::Vec3)
  return (p1.z + p2.z + p3.z) / 3
end

end