//#ifndef _BLUR_HPP_
//#define _BLUR_HPP_
//
//// Averages the nsamples pixels within blur_radius of (x,y). Pixels which
//// would be outside the image, replicate the value at the image border.
//__device__ void pixel_average(unsigned char *out,
//                   const unsigned char *in,
//                   const int x, const int y, const int blur_radius,
//                   const unsigned w, const unsigned h, const unsigned nchannels)
//{
//  float red_total = 0, green_total = 0, blue_total = 0;
//  const unsigned nsamples = (blur_radius*2-1) * (blur_radius*2-1);
//  int ROW = y - blur_radius + 1;
//
//  if (ROW < y+blur_radius)
//  {
//	  int COLUMN = x - blur_radius + 1;
//    if (COLUMN < x+blur_radius)
//	{
//      const unsigned r_i = COLUMN < 0 ? 0 : COLUMN >= w ? w-1 : COLUMN;
//      const unsigned r_j = ROW < 0 ? 0 : ROW >= h ? h-1 : ROW;
//      unsigned byte_offset = (r_j*w+r_i)*nchannels;
//      red_total   += in[byte_offset+0];
//      green_total += in[byte_offset+1];
//      blue_total  += in[byte_offset+2];
//    }
//  }
//
//  unsigned byte_offset = (y*w+x)*nchannels;
//  out[byte_offset+0] =   red_total/nsamples;
//  out[byte_offset+1] = green_total/nsamples;
//  out[byte_offset+2] =  blue_total/nsamples;
//}
//
//__global__ void blur(unsigned char *out, const unsigned char *in,
//          const int blur_radius,
//          const unsigned w, const unsigned h, const unsigned nchannels)
//{
//	int ROW = blockIdx.x * blockDim.x + threadIdx.x;
//	int COLUMN = blockIdx.y * blockDim.y + theadIdx.y;
//  if (ROW < h) 
//  {
//    if (COLUMN < w) 
//	{
//      pixel_average(out,in,COLUMN, ROW,blur_radius,w,h,nchannels);
//    }
//  }
//}
//
//#endif // _BLUR_HPP_
