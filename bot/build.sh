#!/bin/bash

cpu_target_arch=$(echo ${CPU_TARGET} | cut -d/ -f1)
host_arch=$(uname -m)
eessi_arch=${cpu_target_arch:-${host_arch}}
eessi_os=linux
eessi_version=2023.02
eessi_repo=pilot.eessi-hpc.org
tar_topdir=/cvmfs/${eessi_repo}/versions

if [ "${eessi_arch}" != "${host_arch}" ]; then
  echo "Requested architecture (${eessi_arch}) is different from this machine's architecture ($(uname -m))!"
  exit 1
fi

./install_compatibility_layer.sh -a ${eessi_arch} -v ${eessi_version} -r ${eessi_repo} -c ~/compat.sif

# create tarball -> should go into a separate script when this is supported by the bot
target_tgz=eessi-${eessi_version}-compat-linux-${eessi_arch}-$(date +%s).tar.gz
if [ -d ${eessi_tmp}/${tar_topdir}/${eessi_version} ]; then
  echo ">> Creating tarball ${target_tgz} from ${eessi_tmp}/${tar_topdir}..."
  tar cfvz ${target_tgz} -C ${eessi_tmp}/${tar_topdir} ${eessi_version}/compat/${eessi_os}/${eessi_arch}
  echo ${target_tgz} created!
else
  echo "Directory ${tar_topdir}/${eessi_version} was not created, not creating tarball."
  exit 1
fi
