#include "cuda.h"
#include "kernel.cuh"
#define DIFF_T (0.1f)
#define EPS (1.0f)

__global__ void compute_acc(float3 * positionsGPU, float3 * velocitiesGPU, float3 * accelerationsGPU, float* massesGPU, int n_particles)
{
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

	for (int j = i+1; j < n_particles; j++)
	{
		float3 diff;
		diff.x = positionsGPU[j].x - positionsGPU[i].x;
		diff.y = positionsGPU[j].y - positionsGPU[i].y;
		diff.z = positionsGPU[j].z - positionsGPU[i].z;

		float dij = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;

		if (dij < 1.f)
		{
			dij = 10.f;
		}
		else
		{
			dij = rsqrt(dij);
			dij = 10.f * (dij * dij * dij);
		}

		accelerationsGPU[i].x += diff.x * dij * massesGPU[j];
		accelerationsGPU[i].y += diff.y * dij * massesGPU[j];
		accelerationsGPU[i].z += diff.z * dij * massesGPU[j];
		accelerationsGPU[j].x -= diff.x * dij * massesGPU[i];
		accelerationsGPU[j].y -= diff.y * dij * massesGPU[i];
		accelerationsGPU[j].z -= diff.z * dij * massesGPU[i];
	}
}

__global__ void maj_pos(float3 * positionsGPU, float3 * velocitiesGPU, float3 * accelerationsGPU)
{
	unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

	velocitiesGPU[i].x += accelerationsGPU[i].x * 2.f;
	velocitiesGPU[i].y += accelerationsGPU[i].y * 2.f;
	velocitiesGPU[i].z += accelerationsGPU[i].z * 2.f;
	positionsGPU[i].x  += velocitiesGPU[i].x * DIFF_T;
	positionsGPU[i].y  += velocitiesGPU[i].y * DIFF_T;
	positionsGPU[i].z  += velocitiesGPU[i].z * DIFF_T;
}

void update_position_cu(float3* positionsGPU, float3* velocitiesGPU, float3* accelerationsGPU, float* massesGPU, int n_particles)
{
	int nthreads = 128;
	int nblocks =  (n_particles + (nthreads -1)) / nthreads;

	compute_acc<<<nblocks, nthreads>>>(positionsGPU, velocitiesGPU, accelerationsGPU, massesGPU, n_particles);
	maj_pos    <<<nblocks, nthreads>>>(positionsGPU, velocitiesGPU, accelerationsGPU);
}
