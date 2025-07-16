
module Triangles
using ..Vecs: Vec2
export Face, Triangle

mutable struct Face
  indexes::Tuple{Int, Int, Int}
end

mutable struct Triangle
  points::Tuple{Vec2, Vec2, Vec2}
end

end