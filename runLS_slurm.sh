#!/bin/bash

#SBATCH --job-name runLS_august
#SBATCH --account=esm_5554
#SBATCH --partition=normal_q
#SBATCH --cpus-per-task=96
#SBATCH -t 96:00:00
#SBATCH --output=output_%j.out
#SBATCH --error=error_%j.err

#SBATCH --mail-type=all          
#SBATCH --mail-user=nimmala@vt.edu

module reset
module load tinkercliffs-rome/matlab/R2021a
matlab -batch runLS_launch

exit 0
