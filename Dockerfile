FROM jupyter/scipy-notebook


USER root
RUN apt-get update && \
    apt install vim git zsh tmux wget curl mosh build-essential htop gfortran libatlas-base-dev python3-dev python3-pip silversearcher-ag fd-find -y 
USER jovyan
WORKDIR $HOME

RUN wget -q https://gitlab.nrp-nautilus.io/zxy/software_files/-/raw/main/ILOG_COS_20.10_CPLEX_LINUX_X86_64.bin
RUN echo -ne "2\n\n\n\n\n\n1\n/home/jovyan/.local/CPLEX\nY\n2\n\n\n\n2\n2\n2\n2\n2\n2\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" | bash ./ILOG_COS_20.10_CPLEX_LINUX_X86_64.bin
RUN python3.8 /home/jovyan/.local/CPLEX/python/setup.py install --user

RUN python3.8 -m pip install cvxopt cvxpy

RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended

RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime && \
    sh ~/.vim_runtime/install_awesome_vimrc.sh

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --all

RUN git clone https://github.com/gpakosz/.tmux.git && \
    ln -s -f .tmux/.tmux.conf && \
    cp .tmux/.tmux.conf.local .  

RUN python3.8 -m pip install -U torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113 && \
    python3.8 -m pip install awscli ninja black fire autopep8 absl-py flake8 tensorboardX smart-open wheel tensorboard jstyleson pytorch-gan-metrics imageio  opencv-python range-key-dict DingtalkChatbot  scikit-learn jupyterlab && \
    python3.8 -m  ipykernel install --name "python3.8" --user && \
    pip install awscli ninja && \
    python3.8 -m pip install numpy matplotlib pudb PyYAML tqdm protobuf bpython ipdb h5py coloredlogs web-pdb runstats

RUN python3.8 -m pip install numba seaborn networkx "holoviews[recommended]" ipywidgets

RUN python3.8 -m pip install git+https://github.com/mlzxy/visjs2jupyter@main 

RUN MAKEFLAGS="-j4" python3.8 -m pip install scipy==1.1.0

RUN wget https://github.com/prasmussen/gdrive/releases/download/2.1.1/gdrive_2.1.1_linux_386.tar.gz && \
    tar xvf gdrive_2.1.1_linux_386.tar.gz
    

RUN wget https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-gnu && \
    mv sd-v0.7.6-x86_64-unknown-linux-gnu sd && \
    chmod +x ./sd 
    

RUN wget https://github.com/owenthereal/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz && \
    tar xvf ./linux-amd64-1.1.0.tar.gz
    
USER root
RUN mv ./gdrive /usr/local/bin 
RUN mv ./sd /usr/local/bin
RUN cp ./linux-amd64-1.1.0/ccat /usr/local/bin
RUN curl -fsSL https://code-server.dev/install.sh | sh
USER jovyan

RUN code-server --install-extension ms-python.python
RUN code-server --install-extension gengjiawen.vim
RUN code-server --install-extension tabnine.tabnine-vscode
RUN code-server --install-extension oderwat.indent-rainbow
RUN code-server --install-extension christian-kohler.path-intellisense

RUN npm install -g cloudcmd gritty

USER root
RUN apt install screen -y 
USER jovyan

RUN pip install ps-mem
RUN python3.8 -m pip install xlsxwriter
RUN code-server --install-extension cweijan.vscode-office

RUN python3.8 -m pip install tinydb torchinfo hvplot

USER root
RUN apt install texlive-latex-extra texlive-fonts-recommended dvipng cm-super -y 
USER jovyan


RUN code-server --install-extension aaron-bond.better-comments
RUN  python3.8 -m pip install protobuf==3.20.1
RUN python3.8 -m pip install dominate


USER root
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN  apt install caffe-cpu -y
USER jovyan

RUN npm install pm2@latest -g


