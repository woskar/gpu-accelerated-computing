# GPU Computing

Here you’ll find notes on accelerating computing with graphics processing units. I attended a [course](http://wwwstaff.ari.uni-heidelberg.de/mitarbeiter/spurzem/lehre/SS17/cuda/cuda.php.en) given by Rainer Spurzem at Heidelberg University in August 2017. A good resource is [„CUDA by example“](https://developer.nvidia.com/cuda-example) by Jason Sanders and Edward Kandrot. While CUDA (used in the course) is proprietary software from NVIDIA, there is the OpenSource alternative OpenCL. There’s also a [nice free course on parallel computing with CUDA by NVIDIA on UDACITY](https://www.udacity.com/course/intro-to-parallel-programming--cs344), make sure to check it out :D

![cuda](https://user-images.githubusercontent.com/16541141/28874333-b6a001d8-7791-11e7-8652-068bf8bff845.jpg)

### How to run CUDA on Kepler

Kepler is a Supercomputer with 12 Nodes, 2500 Cores each. 
There are two steps to get onto kepler:
1. Log onto the gateway cassiopeia: `ssh -l username welcome.ari.uni-heidelberg.de`
2. From there, log onto kepler: `ssh -l username kepler`

Logged into your account you can get your tasks done: 
1. Save your CUDA Code in a code.cu file.
2. Load the right Cuda module `module load cuda/7.5`
3. Compile your code with `nvcc -o code code.cu`
4. Run the sbatch-script with `sbatch gpu_script.sh`

Note, that the gpu_script.sh has to include 
- the right version of the cuda module
- the name of your compiled program
