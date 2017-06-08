import Noise

import MaxPNG

let viewer_size:Int = 1024

func rgba_from_argb32(_ argb32:[UInt32]) -> [UInt8]
{
    var rgba:[UInt8] = []
    rgba.reserveCapacity(argb32.count * 4)
    for argb in argb32
    {
        rgba.append(UInt8(extendingOrTruncating: argb >> 16))
        rgba.append(UInt8(extendingOrTruncating: argb >> 8 ))
        rgba.append(UInt8(extendingOrTruncating: argb      ))
        rgba.append(UInt8(extendingOrTruncating: argb >> 24))
    }
    return rgba
}

import func Glibc.clock



var pixbuf:[UInt8]
let png_properties:PNGProperties = PNGProperties(width: viewer_size, height: viewer_size, bit_depth: 8, color: .grayscale, interlaced: false)!

var t0:Int

var poisson = PoissonSampler(seed: 0)
t0 = clock()
pixbuf = [UInt8](repeating: 0, count: viewer_size * viewer_size)
for point:PoissonSampler.Point in poisson.generate(radius: 10, width: viewer_size, height: viewer_size)
{
    pixbuf[Int(point.y) * viewer_size + Int(point.x)] = 255
}
print(clock() - t0)
try png_encode(path: "poisson.png", raw_data: pixbuf, properties: png_properties)

let S:fBm<Simplex2D> = fBm<Simplex2D>(amplitude: 0.5*127.5, frequency: 0.001, octaves: 10)
t0 = clock()
pixbuf = S.sample_area_saturated_to_u8(width: viewer_size, height: viewer_size, offset: 127.5)
print(clock() - t0)
try png_encode(path: "simplex.png", raw_data: pixbuf, properties: png_properties)


let SS:fBm<SuperSimplex2D> = fBm<SuperSimplex2D>(amplitude: 0.5*127.5, frequency: 0.001, octaves: 10)
t0 = clock()
pixbuf = SS.sample_area_saturated_to_u8(width: viewer_size, height: viewer_size, offset: 127.5)
print(clock() - t0)
try png_encode(path: "super_simplex.png", raw_data: pixbuf, properties: png_properties)

let SS3D:fBm<SuperSimplex3D> = fBm<SuperSimplex3D>(amplitude: 0.5*127.5, frequency: 0.001, octaves: 10)
t0 = clock()
pixbuf = SS3D.sample_area_saturated_to_u8(width: viewer_size, height: viewer_size, offset: 127.5)
print(clock() - t0)
try png_encode(path: "super_simplex3D.png", raw_data: pixbuf, properties: png_properties)
