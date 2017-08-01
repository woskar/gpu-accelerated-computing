#include <iostream>

__global__ void add( int*a, int*b, int*c ) {
c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

int rand ( void );

#define N 512
int main( void ) {
cudaDeviceProp prop;

int *a, *b, *c; // host copies of a,b,c
int *dev_a, *dev_b, *dev_c; // device copies of a, b, c
int size = N *sizeof( int); // we need space for N integers

  int deviceCount;
    cudaGetDeviceCount( &deviceCount ) ;
    printf(" Device Count %i \n",deviceCount);
int i = 0;
for ( i = 0 ; i < deviceCount ; i++) {
cudaGetDeviceProperties(&prop,i);
printf("Name : %s\n", prop.name);
printf("totalGlobalMem : %u MB \n" , prop.totalGlobalMem / (1024 * 1024));
printf("sharedMemPerBlock : %u KB \n" , prop.sharedMemPerBlock / 1024 );
printf("regsPerBlock:%d \n", prop.regsPerBlock);
printf("warpSize : %d \n" , prop.warpSize);
printf("memPitch : %u \n", prop.memPitch);
printf("maxThreadPerBlock %d \n" , prop.maxThreadsPerBlock ) ;
printf("maxThreadsDim:x %d, y %d, z %d\n",prop.maxThreadsDim[0],prop.maxThreadsDim[1] , prop.maxThre$
printf("maxGridSize:x %d, y %d, z%d\n", prop.maxGridSize[0],prop.maxGridSize[0] , prop.maxGridSize[1$
printf("deviceOverlap:%d \n", prop.deviceOverlap);
printf("totalConstMem:%u\n" , prop.totalConstMem);
printf("major:%d\n",prop.major);
printf("minor:%d\n",prop.minor);
printf("clockRate:%d\n",prop.clockRate);
printf("textureAlignment:%u\n",prop.textureAlignment);
if ( prop.major >= 1 ) {
break;
}
}

// allocate device copies of a, b, c
cudaMalloc( (void**)&dev_a, size );
cudaMalloc( (void**)&dev_b, size );
cudaMalloc( (void**)&dev_c, size );

a = (int*)malloc( size );
b = (int*)malloc( size );
c = (int*)malloc( size );

for (int i=0; i<N; i++)
{ a[i] = rand() %100 + 1;
printf("a %i ",a[i]);
}
printf(" end of a \n\n");


for (int i=0; i<N; i++)
{ b[i] = rand() %100 + 1;
printf("b %i ",b[i]);
}
printf(" end of b \n\n");

// copy inputs to device
cudaMemcpy( dev_a, a, size, cudaMemcpyHostToDevice);
cudaMemcpy( dev_b, b, size, cudaMemcpyHostToDevice);
// launch add() kernel with N parallel blocks
add<<< N, 1 >>>( dev_a, dev_b, dev_c);
// copy device result back to host copy of c
cudaMemcpy( c, dev_c, size, cudaMemcpyDeviceToHost);
free( a ); free( b ); free( c );
cudaFree( dev_a);
cudaFree( dev_b);
cudaFree( dev_c);
for(int i=0;i<N;printf("c %i ",c[i]), i++);

return 0;
}

