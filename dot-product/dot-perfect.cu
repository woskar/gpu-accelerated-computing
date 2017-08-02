// dot-perfect is our best version of a dot product of vectors
// fat threads: more than one vector elemnent per thread
// tree-based: reduction of scalar product
// summation of c[i] on the host

const int N = 2048 * 2048;

const int threadsPerBlock = 1024;

__global__ void dot( int *a, int *b, int *c ) {

__shared__ int temp[threadsPerBlock];

int index = threadIdx.x + blockIdx.x *  blockDim.x;
int tempindex = threadIdx.x;

int tempthread = 0;

while (index < N) {
      tempthread += a[index] * b[index];
      index += blockDim.x * gridDim.x;
}

// set the temp value

temp[tempindex] = tempthread;

__syncthreads();

// now reduction, need threadsPerBlock to be power of 2

int i = blockDim.x/2;

while (i != 0) {
    if(tempindex < i)
       temp[tempindex] += temp[tempindex + i];
    __syncthreads();
    i /= 2;
}

if (tempindex == 0)
    c[blockIdx.x] = temp[0];
}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <iostream>
/*  #include <book.h> */

#define imin(a,b) (a<b?a:b)

int main( void ) {

int *a, *b,  c, *partial_c ; // host copies of a,b,c,partial_c
int *dev_a, *dev_b, *dev_partial_c; // device copies of a, b, partial_c
int size = N *sizeof( int); // we need space for N integers

cudaDeviceProp prop;

cudaGetDeviceProperties( &prop, 0 );
int blocks = prop.multiProcessorCount;

const int blocksPerGrid =
       imin( blocks, (N+threadsPerBlock-1) / threadsPerBlock );

// allocate device copies of a, b, c
cudaMalloc( (void**)&dev_a, size );
cudaMalloc( (void**)&dev_b, size );
cudaMalloc( (void**)&dev_partial_c, blocksPerGrid*sizeof(int) );

a = (int*)malloc( size );
b = (int*)malloc( size );
partial_c = (int*)malloc( blocksPerGrid*sizeof(int) );

for (int i=0; i<N; i++)
{ a[i] = 1;
};

for (int i=0; i<N; i++)
{ b[i] = 1;
};

// copy inputs to device
cudaMemcpy( dev_a, a, size, cudaMemcpyHostToDevice);
cudaMemcpy( dev_b, b, size, cudaMemcpyHostToDevice);


// launch dot() kernel with N parallel blocks
dot<<< blocksPerGrid, threadsPerBlock >>>( dev_a, dev_b, dev_partial_c);

// copy device result back to host copy of d
cudaMemcpy( partial_c, dev_partial_c, blocksPerGrid*sizeof(int) , cudaMemcpyDeviceToHost);

// finish on the CPU side
c = 0;
for (int i=0; i<blocksPerGrid; i++) {
    c += partial_c[i];
}

printf("a %i b %i ; d %i; \n ",a[0],b[0],c);

free( a ); free( b ); free (partial_c );
cudaFree( dev_a);
cudaFree( dev_b);
cudaFree( dev_partial_c);

return 0;
}
