#include "blur.cuh"
#include "add_weighted.cuh"
#include "ppm.hpp"
#include "Common.h"
void unsharp_mask(unsigned char *out, const unsigned char *in,
	const int blur_radius,
	const unsigned w, const unsigned h, const unsigned nchannels)
{
	unsigned char *Gout, *Gin;
	unsigned char *Gblur1, *Gblur2, *Gblur3; // GPU blur variables

	int maxThreadsX, maxThreadsY;
	cudaDeviceGetAttribute(&maxThreadsX, cudaDevAttrMaxGridDimX, 0);
	cudaDeviceGetAttribute(&maxThreadsY, cudaDevAttrMaxGridDimY, 0);
	
	//Set block size and grid size to size of the image. 
	int maxnThreads = 32;

	float XSize = ceil(w / 32.0f); 
	float YSize = ceil(h / 32.0f);

	if (XSize > maxThreadsX)
		XSize = maxThreadsX;
	if (YSize > maxThreadsY)
		YSize = maxThreadsY;

	dim3 nBlocks(XSize, YSize);
	std::cout << " nBlocks: " << "X: " << nBlocks.x << " Y: " << nBlocks.y << std::endl;
	dim3 nThreads(maxnThreads, maxnThreads);

	
	int size = ((w * h) * nchannels); // size of the image

	//Allocating memory
	cudaMalloc((void**)&Gblur1, size);
	cudaMalloc((void**)&Gblur2, size);
	cudaMalloc((void**)&Gblur3, size);
	cudaMalloc((void**)&Gin, size);
	cudaMalloc((void**)&Gout, size);

	//copy to device
	cudaMemcpy(Gin, in, size, cudaMemcpyHostToDevice);

	//run/launch kernals
	std::cout << "Starting Blur process..." << std::endl;
	blur << <nBlocks, nThreads >> >(Gblur1, Gin, blur_radius, w, h, nchannels);
	blur << <nBlocks, nThreads >> >(Gblur2, Gblur1, blur_radius, w, h, nchannels);
	blur << <nBlocks, nThreads >> >(Gblur3, Gblur2, blur_radius, w, h, nchannels);
	std::cout << "Starting Addition process..." << std::endl;
	add_weighted << <nBlocks, nThreads >> >(Gout, Gin, 1.5f, Gblur3, -0.5f, 0.0f, w, h, nchannels);
	cudaMemcpy(out, Gout, size, cudaMemcpyDeviceToHost); // copy back to host

}

