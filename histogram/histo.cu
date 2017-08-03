// Histogram Code as in the CUDA Book

#include <iostream>

#define SIZE (100*1024*1024)

const int threadsPerBlock = 256;

__global__ void histo_kernel( unsigned char *buffer,
                              long size,
                              unsigned int *histo ) {

// Shared memory for adding up histogram on each block
// define a shared vector in the shared memory
__shared__ unsigned int temp[threadsPerBlock];

temp[threadIdx.x] = 0;
__syncthreads(); // to make sure everything is initialized

// atomic add on shared memory

int i = threadIdx.x + blockIdx.x * blockDim.x ;
int offset = blockDim.x * gridDim.x ;

while (i < size) {
        atomicAdd ( &temp[buffer[i]], 1);
      i += offset;
}

__syncthreads();

// atomic add on global memory

atomicAdd( &(histo[threadIdx.x]), temp[threadIdx.x] );
}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
/* #include <book.h>   */

void* big_random_block( int size ) {
            unsigned char *data = (unsigned char*)malloc( size );
/* initialize random seed: */
srand ( time(NULL) );

for (int i=0; i<size; i++)
                data[i] = rand();

    return data;
}

int main( void ) {

unsigned char *buffer = (unsigned char*)big_random_block( SIZE );
unsigned char *dev_buffer;
unsigned int *dev_histo;
unsigned int histo[256];

cudaEvent_t	 start, stop;
cudaEventCreate( &start );
cudaEventCreate( &stop );
cudaEventRecord( start,0 );

cudaMalloc( (void**)&dev_buffer, SIZE );
cudaMalloc( (void**)&dev_histo, 256 * sizeof( long ) );

cudaMemcpy( dev_buffer, buffer, SIZE, cudaMemcpyHostToDevice);
cudaMemset( dev_histo, 0,  256 * sizeof( long ) );

cudaDeviceProp prop;

cudaGetDeviceProperties( &prop, 0 );
int blocks = prop.multiProcessorCount;

// launch histo() kernel with N parallel blocks
histo_kernel<<< blocks*2,256 >>>( dev_buffer, SIZE, dev_histo);
// copy device result back to host copy of d
cudaMemcpy( histo, dev_histo, 256*sizeof( int ) , cudaMemcpyDeviceToHost);


cudaEventRecord( stop,0 );
cudaEventSynchronize( stop );

float elapsedTime;

cudaEventElapsedTime( &elapsedTime, start, stop );

printf(" Time for histogram generation:  %3.1f ms\n", elapsedTime );

long histoCount = 0;
for (int i=0; i<256; i++) {
         histoCount += histo[i];
}
printf(" Histogram Sum: %1d\n", histoCount );

for(int i=0;i<256;printf("histo %i ",histo[i]), i+=256/8 );


cudaEventDestroy( start );
cudaEventDestroy( stop );

free( buffer );
cudaFree( dev_histo);
cudaFree( dev_buffer);


return 0;
}
