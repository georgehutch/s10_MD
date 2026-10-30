#!/bin/bash
#SBATCH --job-name=Amber_cMD
#SBATCH --nodes=1
#SBATCH --cpus-per-gpu=1
#SBATCH --gpus-per-task=1
#SBATCH --partition=far-gpu,defq-gpu
#SBATCH --gpus=1
#SBATCH --gres=gpu:1
#SBATCH --distribution=cyclic
#SBATCH --time=30:00:00

module load amber/22
echo "--------- Starting ------------"
echo $(date)
#
# 2. Set directories

export MYDIR="$HOME/MD/RNA_binding/V1"
export MYEXE="pmemd.cuda_SPFP"

cd $MYDIR
pwd

mkdir MD
cp ./* ./MD
cd MD

export PROTEIN="s10_peptide"
echo $PROTEIN
echo "Starting minsolv"
#read user1
pmemd.cuda_SPFP -O -i minsolv.i -o minsolv.log -p $PROTEIN.prmtop -c $PROTEIN.inpcrd -ref $PROTEIN.inpcrd -r minsolv.rst
old=minsolv

pmemd.cuda_SPFP -O -i mdsolvpmemd.i -o mdsolvpmemd.log -p $PROTEIN.prmtop -c $old.rst -ref $PROTEIN.inpcrd -x mdsolvpmemd.nc -r mdsolvpmemd.rst
old=mdsolvpmemd


MYEXE="pmemd.cuda_SPFP"
for name in min heat eq_npt; do
        echo "Starting $name"
        if [ $name = min ] ; then
                MYEXE="pmemd.cuda_SPFP"
        fi

	$MYEXE -O -i $name.i -o $name.log -p $PROTEIN.prmtop -c $old.rst -ref $PROTEIN.inpcrd -x $name.nc -r $name.rst
        old=$name
        MYEXE="pmemd.cuda_SPFP"
done

old="eq_npt" ##
x0=0


ln -s $old.rst md$x0.rst

int=10
x=`expr $x0 + $int`
X=50
for x in `seq $x $int $X`; do
        pmemd.cuda_SPFP -O -i md.i -o md$x.log -p $PROTEIN.prmtop -c md$x0.rst -x md$x.nc -r md$x.rst
        x0=$x
done
