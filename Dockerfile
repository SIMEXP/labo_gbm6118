FROM ubuntu:17.10
MAINTAINER P-O Quirion <poq@criugm.qc.ca>

# Update repository list
RUN apt-get update

RUN apt-get install -y octave octave-image octave-statistics python3-pip


# Build octave configure file
RUN echo more off >> /etc/octave.conf
RUN echo save_default_options\(\'-7\'\)\; >> /etc/octave.conf
RUN echo graphics_toolkit gnuplot >> /etc/octave.conf
# This should be set in the minc-toolkit layer !


# jupyter install
RUN pip3 install notebook
# octave_kernel install
RUN pip3 install octave_kernel
RUN pip3 install ipywidgets
# start jupyter then head to the adress http://localhost:8888/
EXPOSE 8080
RUN mkdir /nonexistent && chown nobody /nonexistent && mkdir /exo
USER nobody
WORKDIR /exo
ADD *.m  ./
ADD GBM6118_qualite_images_labo_2018.ipynb .
#ENTRYPOINT ["jupyter", "notebook", "--no-browser"]

#CMD ["--port", "8080", "--ip=*"]



 #Command for build
# docker build --no-cache -t="simexp/tp_signal" .

