#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include <iostream>

__global__ void kernel( void ) {
}
int main( void ) {
kernel<<<1,1>>>();

int deviceCount;
cudaGetDeviceCount(&deviceCount);
printf(" Device Count %i \n",deviceCount);

int device;
for (device = 0; device < deviceCount; ++device) {

cudaDeviceProp prop;
cudaGetDeviceProperties(&prop,device);
printf("Name : %s\n", prop.name);
printf("Device %d has compute capability %d.%d.\n",
           device, prop.major, prop.minor);
printf("totalGlobalMem : %u MB \n" , prop.totalGlobalMem / (1024 * 1024));
printf("sharedMemPerBlock : %u KB \n" , prop.sharedMemPerBlock / 1024 );
printf("regsPerBlock:%d \n", prop.regsPerBlock);
printf("warpSize : %d \n" , prop.warpSize);
printf("memPitch : %u \n", prop.memPitch);
printf("maxThreadPerBlock %d \n" , prop.maxThreadsPerBlock ) ;
printf("maxThreadsDim:x %d, y %d, z %d\n",prop.maxThreadsDim[0],prop.maxThreadsDim[1] , prop.maxThr$
printf("maxGridSize:x %d, y %d, z%d\n", prop.maxGridSize[0],prop.maxGridSize[0] , prop.maxGridSize[$
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
return 0;
}