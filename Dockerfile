#run with ubuntu
FROM ubuntu:14.04

#update indexes
RUN apt-get update

#SNPhylo Ubuntu install instructions here: 
#https://github.com/thlee/SNPhylo/blob/master/docs/install_on_linux.rst

#install R
RUN apt-get -y install r-base-dev r-cran-getopt r-cran-rgl

#install required R packages

RUN curl -O https://www.bioconductor.org/packages/release/bioc/src/contrib/gdsfmt_1.30.0.tar.gz

RUN R CMD INSTALL gdsfmt_1.30.0.tar.gz

RUN curl -O https://www.bioconductor.org/packages/release/bioc/src/contrib/SNPRelate_1.28.0.tar.gz

RUN R CMD INSTALL SNPRelate_1.28.0.tar.gz

RUN curl -O https://cran.r-project.org/src/contrib/getopt_1.20.3.tar.gz

RUN R CMD INSTALL getopt_1.20.3.tar.gz

RUN curl -O https://cran.r-project.org/src/contrib/Archive/ape/ape_3.1-4.tar.gz

RUN R CMD INSTALL ape_3.1-4.tar.gz

RUN curl -O https://cran.r-project.org/src/contrib/Archive/quadprog/quadprog_1.5-5.tar.gz

RUN R CMD INSTALL quadprog_1.5-5.tar.gz

RUN curl -O https://cran.r-project.org/src/contrib/Archive/igraph/igraph_0.7.1.tar.gz

RUN R CMD INSTALL igraph_0.7.1.tar.gz

RUN curl -O https://cran.r-project.org/src/contrib/Archive/fastmatch/fastmatch_1.0-4.tar.gz

RUN R CMD INSTALL fastmatch_1.0-4.tar.gz

RUN curl -O https://cran.r-project.org/src/contrib/Archive/phangorn/phangorn_1.99-11.tar.gz

RUN R CMD INSTALL phangorn_1.99-11.tar.gz

RUN mkdir -p /snphylo/bin

#install MUSCLE
RUN curl -O http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_i86linux64.tar.gz

RUN tar xvfz muscle3.8.31_i86linux64.tar.gz -C /snphylo/bin

RUN ln -sf /snphylo/bin/muscle3.8.31_i86linux64 /snphylo/bin/muscle

#install Phylip (v. 3.695)
RUN curl -O https://evolution.gs.washington.edu/phylip/download/phylip-3.697.tar.gz

RUN tar xvfz phylip-3.697.tar.gz -C /snphylo

RUN ln -sf /snphylo/phylip-3.697 /snphylo/phylip

RUN cp /snphylo/phylip/src/Makefile.unx /snphylo/phylip/src/Makefile

# WORKDIR replaces cd in Docker
WORKDIR /snphylo/phylip/src

RUN make install

WORKDIR /

#install SNPhylo

RUN yes | apt-get install git

RUN git clone https://github.com/thlee/SNPhylo.git

RUN mv SNPhylo /snphylo

WORKDIR /snphylo/SNPhylo

RUN printf "yyy/snphylo/bin/muscle\ny/snphylo/phylip/exe/dnaml\n" | bash setup.sh

RUN chmod -R 777 /snphylo

CMD ["/bin/bash"]
