#include <string>
#include <iostream>
#include <vector>
#include <memory>
#include <iomanip>

#include "Model/Model_GPU/Model_GPU.hpp"

int main(int argc, char ** argv)
{
	const int max_n_particles = 81920;
	std::string  core         = "GPU";
	unsigned int n_particles  = 2000;

	// init model
	std::unique_ptr<Model> model;
	model = std::unique_ptr<Model>(new Model_GPU());

	bool done = false;

	model  ->step();

	return 0;
}
