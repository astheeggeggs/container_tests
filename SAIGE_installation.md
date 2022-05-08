# Initial steps

First, clone this repository, so that you have access to the shell script to run all the tests and create md5sums.

```
src_branch=main
repo_src_url=https://github.com/astheeggeggs/container_tests
git clone --depth 1 -b $src_branch $repo_src_url
tests_dir=$(pwd)/container_tests
```

Second, clone the SAIGE github repository. This isn't explicity required for docker (because the test data can be accessed in docker), but it means that everyone's file structures will be equivalent and the test script will work for both singularity and docker containers.

```
src_branch=main
repo_src_url=https://github.com/saigegit/SAIGE
git clone --depth 1 -b $src_branch $repo_src_url
saige_github_extdata="$(pwd)/SAIGE/extdata"
```

# Docker

Be sure that you've run all the initial steps.

Install docker, you'll need sudo access to do this, so if it's not present on the HPC cluster (if you're using that) you'll need to consider the other alternatives, or contact the cluster admins. First, check if singularity is installed as this is also a straightforward way to get SAIGE up and running.

Next, pull the latest SAIGE docker.

```
version="1.0.7"
docker pull wzhou88/saige:${version}
```

replacing 1.0.5 with the latest and greatest version of SAIGE (if updated).

Run the docker, including the test and SAIGE extdata folders as volumes.

```
docker run -v ${saige_github_extdata}:${saige_github_extdata} -v ${tests_dir}:${tests_dir} -i -t wzhou88/saige:${version}
```

Now, run the bash script to run all the SAIGE examples, and create md5sums of the output files.

```
cd ${saige_github_extdata}
bash ${tests_dir}/saige/SAIGE_examples.sh 
```

# Singularity

This is very similar to docker in terms of installation and subsequent usage. But in singularity, we don't have access to files within the container, so will clone the SAIGE github respository in order to access the test data files.

Singularity is much more likely to be available on the cluster you're using.

First, be sure that you've run the initial steps.

Next, pull the SAIGE singularity container.

```
version="1.0.7"
mkdir saige_singularity
cd saige_singularity
saige_singularity_dir=$(pwd)
singularity pull saige.${version}.sif docker://wzhou88/saige:${version}
```

replacing 1.0.7 with the latest and greatest version of SAIGE (if updated).

Start a singularity shell, binding the test and SAIGE extdata folders.

```
singularity shell --bind ${saige_github_extdata},${tests_dir} ${saige_singularity_dir}/saige.${version}.sif
```

Now, run the bash script to run all the SAIGE examples, and create md5sums of the output files.

```
cd ${saige_github_extdata}
bash ${tests_dir}/SAIGE_examples.sh
```

If git is not available on your cluster, you will need to clone the repository locally and move the extdata and bash testing script folder up through scp or an airlock.

If neither singularity, nor docker is available in your compute environment, you will need to either consider using conda or installing from source.

Both of these are a little more involved, installing from source in particular can lead to difficulties due to conflicting dependencies which can arise, but these are less painful than in the stable https://github.com/weizhouUMICH/SAIGE release.

Please see https://saigegit.github.io//SAIGE-doc/docs/Installation_conda.html, and https://saigegit.github.io//SAIGE-doc/docs/Installation_sourcecode.html. 
