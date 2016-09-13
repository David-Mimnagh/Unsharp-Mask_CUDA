//#ifndef _UNSHARP_MASK_HPP_
//#define _UNSHARP_MASK_HPP_
//
//#include "blur.cuh"
//#include "add_weighted.cuh"
//#include "ppm.hpp"
//
//void unsharp_mask(unsigned char *out, const unsigned char *in,
//                  const int blur_radius,
//                  const unsigned w, const unsigned h, const unsigned nchannels)
//{
//  std::vector<unsigned char> blur1, blur2, blur3;
//
//  blur1.resize(w * h * nchannels);
//  blur2.resize(w * h * nchannels);
//  blur3.resize(w * h * nchannels);
//
//  float gridDimX = ceil(w / 32.0f); float gridDimY = ceil(h / 32.0f);
//  dim3 blockSize(32, 32);
//  dim3 gridSize(gridDimX, gridDimY);
//
//  blur<<<gridSize, blockSize>>>(blur1.data(),   in,           blur_radius, w, h, nchannels);
//  blur<<<gridSize, blockSize>>>(blur2.data(), blur1.data(), blur_radius, w, h, nchannels);
//  blur<<<gridSize, blockSize>>>(blur3.data(), blur2.data(), blur_radius, w, h, nchannels);
//  add_weighted << <gridSize, blockSize >> >(out, in, 1.5f, blur3.data(), -0.5f, 0.0f, w, h, nchannels);
//}
//
//#endif // _UNSHARP_MASK_HPP_
