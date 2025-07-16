module Colors
export Color, convert_from_RGB888, convert_to_RGB888

mutable struct Color
    r::UInt8
    g::UInt8
    b::UInt8
    a::UInt8
end

function convert_to_RGB888(color::Color)::UInt32
    packed::UInt32 = 0
    packed |= (Int64(color.r) << 16) 
    packed |= (Int64(color.g) << 8) 
    packed |= (Int64(color.b) << 0)
    return packed
end

function convert_from_RGB888(color::UInt32)::Color
    bytes = reinterpret(UInt8, [color])
    a = UInt8(bytes[4])
    r = UInt8(bytes[3])
    g = UInt8(bytes[2])
    b = UInt8(bytes[1])
    return Color(r, g, b, a)
end

RED = Color(255,0,0,255)
GREEN = Color(0,255,0,255)
BLUE = Color(0,0,255,255)
BLACK = Color(0,0,0,255)
WHITE = Color(255,255,255,255)
end