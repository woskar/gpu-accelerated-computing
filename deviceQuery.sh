
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
##module load openmpi-x86_64

omp_threads=1
export OMP_NUM_THREADS=$omp_threads

mpiprocs=$(($SLURM_NTASKS_PER_NODE * $SLURM_NNODES))

##mpirun -np $mpiprocs ./yourprogram
/opt/local/cuda50/samples/bin/linux/release/deviceQuery

exit