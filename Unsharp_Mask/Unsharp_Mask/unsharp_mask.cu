#include <chrono>
#include "unsharp_mask.cuh"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdlib.h>     
std::ofstream file;
int blurRadius;
const char *ofilename;
void writeToFile(std::string imagename, int blurRadius, double timeToComplete) // Write to file function for writing time and blur values to .csv
{
	file << imagename << "," << blurRadius << "," << timeToComplete << "\n";
}
int main(int argc, char *argv[])
{
	blurRadius = 5;//Standard blur radius of 5
	const char *ifilename = argc > 1 ? argv[1] : "Images/TESTGPU/GhostTown/ghost-town-8k.ppm";
	ofilename = argc > 2 ? argv[2] : "Images/TestGPU/GhostTown/out-ghost-town-8kBR8.ppm";
	const int blur_radius = argc > 3 ? std::atoi(argv[3]) : blurRadius;

	ppm img; // ppm object
	std::vector<unsigned char> data_in, data_sharp; //Data vectors of in and out image 
	std::string name = "TestDataGPU/GhostTown/GhostTownBR_" + std::to_string(blurRadius)+".csv"; // Not majorly OOP with file name, but does the trick
	file.open(name); // open the file

	std::cout << "Blur Radius..." << blurRadius << std::endl; // Testing, for user knowledge to show current blur radius

	std::cout << "Reading in image..." << std::endl; // Letting the user know that the image file is being read
	img.read(ifilename, data_in);

	std::cout << "Resizing..." << std::endl; // Letting the user know about resizing
	data_sharp.resize(img.w * img.h * img.nchannels);
	std::cout << "Image dimensions: " << img.w << "x" << img.h << std::endl;// Testing, for user knowledge to show image dimensions 

	std::cout << "Starting unsharp mask process..." << std::endl; // Telling the user unsharp process is starting 
	auto t1 = std::chrono::steady_clock::now(); // starting clock
	unsharp_mask(data_sharp.data(), data_in.data(), blur_radius, img.w, img.h, img.nchannels); // calling unsharp function (this handles the whole unsharp process)
	auto t2 = std::chrono::steady_clock::now(); // second clock start
	auto timeTaken = std::chrono::duration<double>(t2 - t1).count(); //subtracting the two times for total time taken.
	std::cout << timeTaken << " seconds.\n"; // Telling user total time taken

	std::cout << "Writing information to file..." << std::endl;
	writeToFile("Lena", blurRadius, timeTaken); // writing information to file for current test

	std::cout << "Writing complete image..." << std::endl;
	img.write(ofilename, data_sharp);// writing image file.

	file.close(); // close file safely.

	return 0;
}

