This repository contains the files for the Strasbourg demonstrator.

The .i file contains the reference to the mesh, the boundary conditions, the material properties, the equations to be solved and the definition of the output files.

The .csv file contains information about the fluid density and viscosity which are temperature dependent.

You must have Moose and Golem:

Moose intalation:
1. Write
in the terminal:

conda activate base
conda env remove -n moose
This removed the environment I had created from Moose. This is equivalent to uninstalling Moose

2. Update the base Conda environment,
in the terminal:

conda update --all --yes

3. Create a single conda environment for MOOSE, named moose, and install the MOOSE dependency packages:
in the terminal:

conda create -n moose moose-dev=2024.03.05

Warning, this step took me a long time, I tried to do it with mamba:

mamba create -n moose moose-dev=2024.03.05

And it takes about 1 minute. If you don't have mamba, you need to install it with:

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh

4. Activate the moose environment:
conda activate moose

5. Clone Moose:
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/idaholab/moose.git
cd moose
git checkout master
So we've created a projects directory, cloned Moose into this directory, and we're aligned with the master branch.

6. Compile and test Moose:

cd ~/projects/moose/test
make -j 6
and to test:

cd ~/projects/moose/test
./run_tests -j 6
If all the tests pass, this means that Moose is installed correctly. Some tests may fail, but the important thing is that the maximum number of failed tests is not reached.

Golem instalation

1. Clone Golem in the same directory as the one where we installed Moose:

cd ~/projects
git clone https://git.gfz-potsdam.de/moose/golem
cd ~/projects/golem
git checkout devel
and go to the "devel" branch, which is the branch where all the tests are approved, i.e. the most stable branch.

2. Compile Golem:
cd ~/projects/golem 
make -j4

4. Test Golem
cd ~/projects/golem
./run_tests -j2
The same applies to Moose, the important thing being that the maximum number of failed tests is not reached. Once this stage had been completed, we installed Golem.

Install the content of this repository in the Golem repository





