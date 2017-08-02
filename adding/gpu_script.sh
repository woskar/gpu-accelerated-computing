#!/bin/bash
#SBATCH -J GPU_student_job
#SBATCH -p GPU
##SBATCH -p Student_GPU
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
##Maximum runtime <= 72:00:00
#SBATCH --time=00:05:00
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

module load cuda/5.0

##./add-index
./add-parallel

exit
