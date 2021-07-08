#!/bin/bash
#SBATCH -a 0-81:5
#SBATCH -p gpu
#SBATCH -t 23:00:00
#SBATCH -G gtx1080:1
#Sbatch -c 2
#SBATCH --mail-type=END
#SBATCH --mail-user=serce@neuro.mpg.de
#SBATCH -o job_array_analyse_videos_%A_%a.out

module purge
module load cuda/11.1.0
module load cudnn/8.0.4.30-11.1-linux-x64

source "$HOME"/.bashrc
source activate DLC-GPU

videofolder=/scratch/onur.serce/outputs_week1
shuffleindex=${1?Error: no shuffleindex given}
snapshotindex=${2?Error: no snapshotindex given}
gputouse=$CUDA_VISIBLE_DEVICES

nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits

# $SLURM_ARRAY_TASK_ID will be used as an index to a python script
python eMotion/worker_scripts/dlc_analyse_videos_jobarray.py "$shuffleindex" "$snapshotindex" "$videofolder" "$SLURM_ARRAY_TASK_ID" "$gputouse"

#Manually edit:
#slurm parameters: -a -t
#varibles: videofolder
