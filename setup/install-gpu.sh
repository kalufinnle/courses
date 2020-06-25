# This script is designed to work with ubuntu 18.04 LTS

#Refresh pci. update the PCI hardware database that Linux maintains by entering update-pciids (generally found in /sbin) at the command line
$update-pciids
# Verify gpu is CUDA available
$lspci | grep -i nvidia
#The gcc compiler is required for development using the CUDA Toolkit.
$gcc --version
$sudo apt install gcc
#The version of the kernel your system is running can be found by running the following command: 
$ uname -r
#Verify the system has the correct kernel headers and development packages installed. The kernel headers and development packages for the currently running kernel can be installed with: 
$ sudo apt-get install linux-headers-$(uname -r)

# ensure system is updated and has basic build tools
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common
sudo apt-get --assume-yes install git

# download the linux nvidia driver
wget ""
chmod +x NVIDIA-Linux-x86_64-440.44.run
sudo sh NVIDIA-Linux-x86_64-440.44.run

# download and install GPU drivers  compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb "cuda-repo-ubuntu1804_10.0.130-1_amd64.deb"
wget "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb" -O "cuda-repo-ubuntu1804_10.0.130-1_amd64.deb"

sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo apt-get update
sudo apt-get -y install cuda
sudo modprobe nvidia
nvidia-smi

# install Anaconda for current user //mkdir downloads  Anaconda2-4.2.0-Linux-x86_64.sh 
cd Downloads
wget "https://repo.continuum.io/archive/Anaconda3-5.2.0-Linux-x86_64.sh" -O "Anaconda3-5.2.0-Linux-x86_64.sh"
bash "Anaconda3-5.2.0-Linux-x86_64.sh" -b

echo "export PATH=\"$HOME/anaconda2/bin:\$PATH\"" >> ~/.bashrc
export PATH="$HOME/anaconda2/bin:$PATH"
conda install -y bcolz
conda upgrade -y --all

# install and configure theano
pip install theano
echo "[global]
device = gpu
floatX = float32

[cuda]
root = /usr/local/cuda" > ~/.theanorc

# install and configure keras
pip install keras==1.2.2
mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

# install cudnn libraries
wget "http://files.fast.ai/files/cudnn.tgz" -O "cudnn.tgz"
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/
nvcc --version

# configure jupyter and prompt for password

#jupyter notebook --generate-config
#jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
#echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
#echo "c.NotebookApp.ip = '*'
#c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

# clone the fast.ai course repo and prompt to start notebook
#cd ~
#git clone https://github.com/fastai/courses.git
#echo "\"jupyter notebook\" will start Jupyter on port 8888"
#echo "If you get an error instead, try restarting your session so your $PATH is updated"
