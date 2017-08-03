// Simplified Histogram Program

#include <iostream>

#define SIZE (100*1024*1024)

__global__ void histo_kernel( unsigned char *buffer,
                              long size,
                              unsigned int *histo ) {

int i = threadIdx.x + blockIdx.x * blockDim.x ;
int offset = blockDim.x * gridDim.x ;

// atomic add on global memory

while  (i < size) {
atomicAdd( &(histo[buffer[i]]), 1 );
      i += offset;
}
}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <../book.h>

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
printf(" Histogram Sum: %1d\n%i", histoCount,histo );

cudaEventDestroy( start );
cudaEventDestroy( stop );


free( buffer );
cudaFree( dev_histo);
cudaFree( dev_buffer);

return 0;
}
