
module Triangles
using ..Vecs: Vec2
export Face, Triangle

mutable struct Face
  indexes::Tuple{Int, Int, Int}
end

mutable struct Triangle
  points::Tuple{Vec2, Vec2, Vec2}
  Triangle(points) = new((Vec2(round(Int, points[1].x), round(Int, points[1].y)),
                          Vec2(round(Int, points[2].x), round(Int, points[2].y)),
                          Vec2(round(Int, points[3].x), round(Int, points[3].y))))
end

end