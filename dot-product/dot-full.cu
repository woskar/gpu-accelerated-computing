#include <iostream>

#define N (32768)
#define THREADS_PER_BLOCK 1024

__global__ void dot( int *a, int *b, int *d ) {

// Shared memory for results of multiplication

__shared__ int temp[THREADS_PER_BLOCK];
__shared__ int sum;

int index = threadIdx.x + blockIdx.x*blockDim.x ;

temp[threadIdx.x] = a[index] * b[index];
__syncthreads();

// Thread 0 sums the pairwiseproducts
if( 0 == threadIdx.x ) {
sum = 0;
for( int i = 0; i < THREADS_PER_BLOCK ; i++ )
{
sum += temp[i];
};

atomicAdd ( d , sum );
   }
}


#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main( void ) {

int *a, *b, *d ; // host copies of a,b,c
int *dev_a, *dev_b, *dev_d; // device copies of a, b, c
int size = N *sizeof( int); // we need space for N integers

// allocate device copies of a, b, c
cudaMalloc( (void**)&dev_a, size );
cudaMalloc( (void**)&dev_b, size );
cudaMalloc( (void**)&dev_d, sizeof(int) );

a = (int*)malloc( size );
b = (int*)malloc( size );
d = (int*)malloc( sizeof(int) );

for (int i=0; i<N; i++)
{ a[i] = 1;
};

for (int i=0; i<N; i++)
{ b[i] = 1;
};

*d = 0;

// copy inputs to device
cudaMemcpy( dev_a, a, size, cudaMemcpyHostToDevice);
cudaMemcpy( dev_b, b, size, cudaMemcpyHostToDevice);
cudaMemcpy( dev_d, d, sizeof(int), cudaMemcpyHostToDevice);
// launch dot() kernel with N parallel blocks
dot<<< N/THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>( dev_a, dev_b, dev_d);
// copy device result back to host copy of d
cudaMemcpy( d, dev_d, sizeof(int) , cudaMemcpyDeviceToHost);

printf("a  %i b  %i ; d  %i; \n ",a[0],b[0],*d);

free( a ); free( b ); free (d );
cudaFree( dev_a);
cudaFree( dev_b);
cudaFree( dev_d);

return 0;
}
