// Dot product

#include <iostream>

#define N 1024

__global__ void dot( int*a, int*b, int*c ) {

__shared__ int temp[N];

temp[threadIdx.x] = a[threadIdx.x] * b[threadIdx.x];

__syncthreads();

// Thread 0 sums the pairwiseproducts
if( 0 == threadIdx.x ) {
int sum = 0;
for( int i = N-1; i >= 0 ; i-- )
sum += temp[i];
c[0] = sum;
   }
}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int main( void ) {

int *a, *b, *c ; // host copies of a,b,c
int *dev_a, *dev_b, *dev_c; // device copies of a, b, c
int size = N *sizeof( int); // we need space for N integers

// allocate device copies of a, b, c
cudaMalloc( (void**)&dev_a, size );
cudaMalloc( (void**)&dev_b, size );
cudaMalloc( (void**)&dev_c, size );

a = (int*)malloc( size );
b = (int*)malloc( size );
c = (int*)malloc( size );

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
dot<<< 1,N >>>( dev_a, dev_b, dev_c);
// copy device result back to host copy of c
cudaMemcpy( c, dev_c, size , cudaMemcpyDeviceToHost);

printf("a %i b %i ; c %i; \n ",a[0],b[0],c[0]);

free( a ); free( b ); free( c );
cudaFree( dev_a);
cudaFree( dev_b);
cudaFree( dev_c);


return 0;
}