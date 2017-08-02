#include <iostream>

__global__ void add( int*a, int*b, int*c ) {
int index = threadIdx.x + blockIdx.x * blockDim.x;
c[index] = a[index] + b[index];
}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#define N (1024*1024*16)
#define THREADS_PER_BLOCK 1024
int main( void ) {

int *a, *b, *c; // host copies of a,b,c
int *dev_a, *dev_b, *dev_c; // device copies of a, b, c
int size = N *sizeof( int); // we need space for N integers

// allocate device copies of a, b, c
cudaMalloc( (void**)&dev_a, size );
cudaMalloc( (void**)&dev_b, size );
cudaMalloc( (void**)&dev_c, size );

a = (int*)malloc( size );
b = (int*)malloc( size );
c = (int*)malloc( size );

/* initialize random seed: */
srand ( time(NULL) );

for (int i=0; i<N; i ++)
{ a[i] = rand() %100 + 1;
  b[i] = rand() %100 + 1;
};

for (int i=0; i<N; i +=N/100)
{
printf("a %i; ",a[i]);
}
printf(" end of a \n\n");

for (int i=0; i<N; i +=N/100)
{
printf("b %i; ",b[i]);
}
printf(" end of b \n\n");

// copy inputs to device
cudaMemcpy( dev_a, a, size, cudaMemcpyHostToDevice);
cudaMemcpy( dev_b, b, size, cudaMemcpyHostToDevice);

// launch add() kernel with N parallel blocks
add<<< N/THREADS_PER_BLOCK, THREADS_PER_BLOCK >>>( dev_a, dev_b, dev_c);

// copy device result back to host copy of c
cudaMemcpy( c, dev_c, size, cudaMemcpyDeviceToHost);

for (int i=0; i<N; i +=N/100)
{
printf("c %i; ",c[i]);
}
printf(" end of c \n");

free( a ); free( b ); free( c );
cudaFree( dev_a);
cudaFree( dev_b);
cudaFree( dev_c);


return 0;
}