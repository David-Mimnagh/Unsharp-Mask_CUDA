#include <climits>
#include "Common.h"
// Calculates the weighted sum of two arrays, in1 and in2 according
// to the formula: out(I) = saturate(in1(I)*alpha + in2(I)*beta + gamma)
template <typename T>
__global__ void add_weighted(unsigned char *out,
	const unsigned char *in1, const T alpha,
	const unsigned char *in2, const T  beta, const T gamma,
	const unsigned w, const unsigned h, const unsigned nchannels)
{
	int pixel_ROW = blockIdx.x * blockDim.x + threadIdx.x;
	int pixel_COLUMN = blockIdx.y * blockDim.y + threadIdx.y;

	if (pixel_ROW < w)
	{
		if (pixel_COLUMN < h)
		{
			unsigned byte_offset = (pixel_COLUMN * w + pixel_ROW) * nchannels;

			T tmp = in1[byte_offset + 0] * alpha + in2[byte_offset + 0] * beta + gamma;
			out[byte_offset + 0] = tmp < 0 ? 0 : tmp > UCHAR_MAX ? UCHAR_MAX : tmp;

			tmp = in1[byte_offset + 1] * alpha + in2[byte_offset + 1] * beta + gamma;
			out[byte_offset + 1] = tmp < 0 ? 0 : tmp > UCHAR_MAX ? UCHAR_MAX : tmp;

			tmp = in1[byte_offset + 2] * alpha + in2[byte_offset + 2] * beta + gamma;
			out[byte_offset + 2] = tmp < 0 ? 0 : tmp > UCHAR_MAX ? UCHAR_MAX : tmp;

		}
	}
}

