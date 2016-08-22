From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Mon, 22 Aug 2016 12:13:23 -0600
Message-ID: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Everyone,

Here is the patch series for the consolidation. This is based on the special
merge commit created by the buildlib/make-merge.py script. See my prior
message (http://www.spinics.net/lists/linux-rdma/msg39026.html) for details.

The first 7 patches change/fix various things in the original packages to
build consistently, patch 8 has cmake and all the auto* co-exist, and can be
used to do build compares (see buildlib/compare-build.py)

The next batch of patches removes the old build stuff, packaging, merges
COPYING files and lightly simplifies the directory structure.

https://github.com/jgunthorpe/rdma-plumbing

This has been rebased since my last posting with feedback from Steve.

The following 15 repositories were pulled together.

      libcxgb3 git://git.openfabrics.org/~swise/libcxgb3.git 0de0392268af3a657b329874b63b6ee827109508
      libcxgb4 git://git.openfabrics.org/~swise/libcxgb4.git 15d3253dc814da28e2b93ed02a8e9a96d97f20ae
      libhfi1verbs https://github.com/01org/opa-libhfi1verbs.git 377b68888a0b885fc2a44ddf7a2ec33f2fcf217b
      libi40iw git://git.openfabrics.org/~tnikolova/libi40iw/.git 9d35609f79d6a235e23182e9ceadf3605b2682da
      libibcm git://git.openfabrics.org/~shefty/libibcm.git b04920e8bfe0689a2fe67815321dcf646fd48a7e
      libibumad git://git.openfabrics.org/~halr/libibumad.git ecda3a56b18c6a2845f3d966f8b8061941f5d447
      libibverbs git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git 0be978ea2bfaf203c35334b090bddb280de62611
      libipathverbs https://github.com/01org/libipathverbs.git 8291d485f3a5544b43974e7be88f3646f35ae07c
      libmlx4 git://git.openfabrics.org/~yishaih/libmlx4.git 162f948c4e04753a15cfb7afcdf6219dbe0bc31e
      libmlx5 git://git.openfabrics.org/~yishaih/libmlx5.git f23f9aa7b9033cd8ebbd58d67d65e9b81d0525fa
      libmthca git://git.kernel.org/pub/scm/libs/infiniband/libmthca.git 6f4dd7451ddef120247e13fa6cb8e1df69c3ddf9
      libnes git://git.openfabrics.org/~tnikolova/libnes/.git 7dc7cf2474612ec909bff251096ca2aefa9cddf1
      libocrdma git://git.openfabrics.org/~emulex/libocrdma.git 41f6bbb3fe8129678c233da439d872b3fe9f75dc
      librdmacm git://git.openfabrics.org/~shefty/librdmacm.git 032bbe60ad32d59004447e03061a9f6d632cc55f
      librxe https://github.com/SoftRoCE/librxe-dev.git 227e3c49b6e423c066e1e1887fe30c8261f63cbd

Steve suggests that iwpm be included as well, which makes sense..

My hope is that Doug will step up as the unified maintainer, with a process
similar to the kernel. Most of the libraries are unchanging/unmaintained/dead.

Jason Gunthorpe (15):
  Fix bogus executable file permissions
  umad: Include umad.h in the canonical way
  rdmacm: Control symbol export from librspreload
  ibcm: Actually use the version script when linking
  Include pthreads in the provider libraries
  Be explicit about _GNU_SOURCE
  hfi/ipath: Use the name of the provider for the .driver file
  Unified CMake build system
  Support obsolete cmake from 2013
  Remove the auto* based build systems
  Remove the ChangeLog files
  Combine COPYING files
  Consolidate the .gitignore files
  Move providers into providers/
  Add a MAINTAINERS file

 .gitignore                                         |    29 +
 CMakeLists.txt                                     |   230 +
 COPYING                                            |     6 +
 COPYING.BSD                                        |    26 +
 libnes/gpl-2.0.txt => COPYING.GPL2                 |    14 +-
 MAINTAINERS                                        |    81 +
 README.md                                          |    69 +
 buildlib/FindLDSymVer.cmake                        |    41 +
 buildlib/RDMA_BuildType.cmake                      |    31 +
 buildlib/RDMA_DoFixup.cmake                        |    25 +
 buildlib/RDMA_EnableCStd.cmake                     |    23 +
 buildlib/config.h.in                               |    29 +
 buildlib/fixup-include/rdma-rdma_user_rxe.h        |   144 +
 buildlib/fixup-include/valgrind-memcheck.h         |     5 +
 buildlib/provider.map                              |     6 +
 buildlib/publish_headers.cmake                     |    20 +
 buildlib/rdma_functions.cmake                      |   243 +
 libcxgb3/ChangeLog                                 |   791 -
 libcxgb3/Makefile.am                               |    27 -
 libcxgb3/autogen.sh                                |     8 -
 libcxgb3/config/.gitignore                         |     0
 libcxgb3/configure.in                              |    67 -
 libcxgb3/cxgb3.driver                              |     1 -
 libcxgb3/libcxgb3.spec.in                          |    55 -
 libcxgb3/src/iwch.map                              |     6 -
 libcxgb4/COPYING                                   |    29 -
 libcxgb4/ChangeLog                                 |  1133 --
 libcxgb4/Makefile.am                               |    27 -
 libcxgb4/autogen.sh                                |     8 -
 libcxgb4/config/config.guess                       |  1439 --
 libcxgb4/config/config.sub                         |  1811 ---
 libcxgb4/config/depcomp                            |   530 -
 libcxgb4/config/install-sh                         |   323 -
 libcxgb4/configure.in                              |    67 -
 libcxgb4/cxgb4.driver                              |     1 -
 libcxgb4/libcxgb4.spec.in                          |    55 -
 libcxgb4/src/cxgb4.map                             |     6 -
 libhfi1verbs/.gitignore                            |    18 -
 libhfi1verbs/Makefile.am                           |    83 -
 libhfi1verbs/autogen.sh                            |    64 -
 libhfi1verbs/configure.in                          |   124 -
 libhfi1verbs/hfi1.driver                           |     1 -
 libhfi1verbs/libhfi1verbs.spec.in                  |   111 -
 libhfi1verbs/makefile                              |    93 -
 libhfi1verbs/makesrpm.sh                           |    15 -
 libhfi1verbs/src/hfiverbs.map                      |     4 -
 libi40iw/COPYING                                   |   372 -
 libi40iw/Makefile.am                               |    26 -
 libi40iw/configure.ac                              |    72 -
 libi40iw/i40iw.driver                              |     1 -
 libi40iw/libi40iw.spec.in                          |    72 -
 libi40iw/src/i40iw.map                             |    39 -
 libibcm/COPYING                                    |   378 -
 libibcm/ChangeLog                                  |     0
 libibcm/Makefile.am                                |    35 -
 libibcm/autogen.sh                                 |     9 -
 libibcm/configure.in                               |    72 -
 libibcm/examples/CMakeLists.txt                    |     2 +
 libibcm/src/CMakeLists.txt                         |     9 +
 libibcm/src/cm.c                                   |     2 +-
 libibumad/COPYING                                  |   377 -
 libibumad/ChangeLog                                |    94 -
 libibumad/Makefile.am                              |    75 -
 libibumad/autogen.sh                               |    11 -
 libibumad/configure.in                             |    72 -
 libibumad/man/CMakeLists.txt                       |    42 +
 libibumad/src/CMakeLists.txt                       |    14 +
 libibumad/src/sysfs.c                              |     3 -
 libibumad/src/umad.c                               |     2 +-
 libibumad/tests/CMakeLists.txt                     |     5 +
 libibumad/tests/umad_reg2_compat.c                 |     2 +-
 libibumad/tests/umad_register2.c                   |     2 +-
 libibverbs/.gitignore                              |    24 -
 libibverbs/COPYING                                 |   378 -
 libibverbs/ChangeLog                               |   583 -
 libibverbs/Makefile.am                             |   126 -
 libibverbs/autogen.sh                              |     4 -
 libibverbs/config/.gitignore                       |     8 -
 libibverbs/configure.ac                            |   125 -
 libibverbs/examples/.gitignore                     |    10 -
 libibverbs/examples/CMakeLists.txt                 |    29 +
 libibverbs/examples/asyncwatch.c                   |     2 +-
 libibverbs/examples/rc_pingpong.c                  |     2 +-
 libibverbs/examples/srq_pingpong.c                 |     2 +-
 libibverbs/examples/uc_pingpong.c                  |     2 +-
 libibverbs/examples/ud_pingpong.c                  |     2 +-
 libibverbs/examples/xsrq_pingpong.c                |     2 +-
 libibverbs/man/CMakeLists.txt                      |    78 +
 libibverbs/src/.gitignore                          |     3 -
 libibverbs/src/CMakeLists.txt                      |    34 +
 libibverbs/src/device.c                            |     2 +-
 libibverbs/src/init.c                              |     2 +-
 libibverbs/src/sysfs.c                             |     2 +-
 libipathverbs/.gitignore                           |    22 -
 libipathverbs/Makefile.am                          |    79 -
 libipathverbs/autogen.sh                           |    43 -
 libipathverbs/configure.in                         |   118 -
 libipathverbs/ipath.driver                         |     1 -
 libipathverbs/libipathverbs.spec.in                |   104 -
 libipathverbs/src/ipathverbs.map                   |     4 -
 libmlx4/.gitignore                                 |    17 -
 libmlx4/COPYING                                    |   378 -
 libmlx4/Makefile.am                                |    19 -
 libmlx4/autogen.sh                                 |     4 -
 libmlx4/config/.gitignore                          |     8 -
 libmlx4/configure.ac                               |    94 -
 libmlx4/debian/changelog                           |    73 -
 libmlx4/debian/compat                              |     1 -
 libmlx4/debian/control                             |    47 -
 libmlx4/debian/copyright                           |    43 -
 libmlx4/debian/libmlx4-1.install                   |     2 -
 libmlx4/debian/libmlx4-dev.install                 |     1 -
 .../debian/patches/driver-plugin-directory.patch   |    10 -
 libmlx4/debian/patches/series                      |     1 -
 libmlx4/debian/rules                               |    10 -
 libmlx4/debian/source/format                       |     1 -
 libmlx4/debian/watch                               |     3 -
 libmlx4/libmlx4.spec.in                            |    90 -
 libmlx4/mlx4.driver                                |     1 -
 libmlx4/src/.gitignore                             |     3 -
 libmlx4/src/mlx4.map                               |     5 -
 libmlx5/.gitignore                                 |    33 -
 libmlx5/COPYING                                    |   378 -
 libmlx5/Makefile.am                                |    27 -
 libmlx5/autogen.sh                                 |     7 -
 libmlx5/config/.gitignore                          |     8 -
 libmlx5/configure.ac                               |   105 -
 libmlx5/debian/changelog                           |    18 -
 libmlx5/debian/compat                              |     1 -
 libmlx5/debian/control                             |    47 -
 libmlx5/debian/copyright                           |    43 -
 libmlx5/debian/libmlx5-1.install                   |     2 -
 libmlx5/debian/libmlx5-dev.install                 |     1 -
 .../debian/patches/driver-plugin-directory.patch   |    10 -
 libmlx5/debian/patches/series                      |     1 -
 libmlx5/debian/rules                               |    10 -
 libmlx5/debian/source/format                       |     1 -
 libmlx5/debian/watch                               |     3 -
 libmlx5/libmlx5.spec.in                            |    60 -
 libmlx5/m4/ax_gcc_func_attribute.m4                |   223 -
 libmlx5/mlx5.driver                                |     1 -
 libmlx5/src/.gitignore                             |     3 -
 libmlx5/src/mlx5.map                               |     5 -
 libmthca/.gitignore                                |    17 -
 libmthca/COPYING                                   |   378 -
 libmthca/ChangeLog                                 |   378 -
 libmthca/Makefile.am                               |    29 -
 libmthca/autogen.sh                                |     8 -
 libmthca/config/.gitignore                         |     8 -
 libmthca/configure.in                              |    80 -
 libmthca/debian/changelog                          |    73 -
 libmthca/debian/compat                             |     1 -
 libmthca/debian/control                            |    48 -
 libmthca/debian/copyright                          |    44 -
 libmthca/debian/libmthca-dev.install               |     1 -
 libmthca/debian/libmthca1.install                  |     2 -
 .../debian/patches/driver-plugin-directory.patch   |    10 -
 libmthca/debian/patches/series                     |     1 -
 libmthca/debian/rules                              |    10 -
 libmthca/debian/source/format                      |     1 -
 libmthca/debian/watch                              |     3 -
 libmthca/libmthca.spec.in                          |    97 -
 libmthca/mthca.driver                              |     1 -
 libmthca/src/.gitignore                            |     3 -
 libmthca/src/mthca.map                             |     5 -
 libnes/Makefile.am                                 |    26 -
 libnes/autogen.sh                                  |    12 -
 libnes/config/.gitignore                           |     0
 libnes/configure.in                                |    72 -
 libnes/libnes.spec.in                              |   107 -
 libnes/nes.driver                                  |     1 -
 libnes/src/nes.map                                 |     5 -
 libocrdma/COPYING                                  |   317 -
 libocrdma/Makefile.am                              |    23 -
 libocrdma/autogen.sh                               |     8 -
 libocrdma/config/.gitignore                        |     8 -
 libocrdma/configure.in                             |    68 -
 libocrdma/libocrdma.spec.in                        |    71 -
 libocrdma/ocrdma.driver                            |     1 -
 libocrdma/src/ocrdma.map                           |     5 -
 librdmacm/.gitignore                               |    64 -
 librdmacm/COPYING                                  |   378 -
 librdmacm/ChangeLog                                |     0
 librdmacm/Makefile.am                              |   138 -
 librdmacm/autogen.sh                               |     5 -
 librdmacm/configure.ac                             |   108 -
 librdmacm/examples/.gitignore                      |    23 -
 librdmacm/examples/CMakeLists.txt                  |    43 +
 librdmacm/examples/rping.c                         |     2 +-
 librdmacm/man/CMakeLists.txt                       |    65 +
 librdmacm/src/.gitignore                           |     9 -
 librdmacm/src/CMakeLists.txt                       |    39 +
 librdmacm/src/librspreload.map                     |    33 +
 librdmacm/src/preload.c                            |     6 +-
 librdmacm/src/rsocket.c                            |     2 +-
 librxe/AUTHORS                                     |     0
 librxe/COPYING                                     |     0
 librxe/ChangeLog                                   |     0
 librxe/INSTALL                                     |     0
 librxe/Makefile.am                                 |    36 -
 librxe/Makefile.in                                 |   939 --
 librxe/NEWS                                        |     0
 librxe/README                                      |     0
 librxe/aclocal.m4                                  |  9390 ------------
 librxe/config.h.in                                 |    89 -
 librxe/config/config.guess                         |  1526 --
 librxe/config/config.sub                           |  1658 ---
 librxe/config/depcomp                              |   530 -
 librxe/config/install-sh                           |   519 -
 librxe/config/ltmain.sh                            |  9636 ------------
 librxe/config/missing                              |   360 -
 librxe/configure                                   | 14728 -------------------
 librxe/configure.in                                |    75 -
 librxe/librxe.spec                                 |    55 -
 librxe/librxe.spec.in                              |    55 -
 librxe/rxe.driver                                  |     1 -
 librxe/src/rxe.map                                 |     5 -
 {libcxgb4 => providers/cxgb3}/AUTHORS              |     0
 providers/cxgb3/CMakeLists.txt                     |     6 +
 {libcxgb3 => providers/cxgb3}/COPYING              |     0
 {libcxgb3 => providers/cxgb3}/README               |     0
 {libcxgb3/src => providers/cxgb3}/cq.c             |     0
 {libcxgb3/src => providers/cxgb3}/cxio_wr.h        |     0
 .../src => providers/cxgb3}/firmware_exports.h     |     0
 {libcxgb3/src => providers/cxgb3}/iwch-abi.h       |     0
 {libcxgb3/src => providers/cxgb3}/iwch.c           |     0
 {libcxgb3/src => providers/cxgb3}/iwch.h           |     0
 {libcxgb3/src => providers/cxgb3}/qp.c             |     0
 {libcxgb3/src => providers/cxgb3}/verbs.c          |     0
 {libcxgb3 => providers/cxgb4}/AUTHORS              |     0
 providers/cxgb4/CMakeLists.txt                     |     6 +
 {libcxgb4 => providers/cxgb4}/README               |     0
 {libcxgb4/src => providers/cxgb4}/cq.c             |     0
 {libcxgb4/src => providers/cxgb4}/cxgb4-abi.h      |     0
 {libcxgb4/src => providers/cxgb4}/dev.c            |     0
 {libcxgb4/src => providers/cxgb4}/libcxgb4.h       |     0
 {libcxgb4/src => providers/cxgb4}/qp.c             |     0
 {libcxgb4/src => providers/cxgb4}/queue.h          |     0
 {libcxgb4/src => providers/cxgb4}/t4.h             |     0
 {libcxgb4/src => providers/cxgb4}/t4_chip_type.h   |     0
 {libcxgb4/src => providers/cxgb4}/t4_pci_id_tbl.h  |     0
 {libcxgb4/src => providers/cxgb4}/t4_regs.h        |     0
 {libcxgb4/src => providers/cxgb4}/t4fw_interface.h |     0
 {libcxgb4/src => providers/cxgb4}/verbs.c          |     0
 {libhfi1verbs => providers/hfi1verbs}/AUTHORS      |     0
 providers/hfi1verbs/CMakeLists.txt                 |     4 +
 {libhfi1verbs => providers/hfi1verbs}/COPYING      |     0
 {libhfi1verbs => providers/hfi1verbs}/README       |     0
 .../src => providers/hfi1verbs}/hfi-abi.h          |     0
 .../src => providers/hfi1verbs}/hfiverbs.c         |     0
 .../src => providers/hfi1verbs}/hfiverbs.h         |     0
 {libhfi1verbs/src => providers/hfi1verbs}/verbs.c  |     0
 {libnes => providers/i40iw}/AUTHORS                |     0
 providers/i40iw/CMakeLists.txt                     |     5 +
 {libi40iw/src => providers/i40iw}/i40e_devids.h    |     0
 {libi40iw/src => providers/i40iw}/i40iw-abi.h      |     0
 {libi40iw/src => providers/i40iw}/i40iw_d.h        |     0
 {libi40iw/src => providers/i40iw}/i40iw_osdep.h    |     0
 {libi40iw/src => providers/i40iw}/i40iw_register.h |     0
 {libi40iw/src => providers/i40iw}/i40iw_status.h   |     0
 {libi40iw/src => providers/i40iw}/i40iw_uk.c       |     0
 {libi40iw/src => providers/i40iw}/i40iw_umain.c    |     0
 {libi40iw/src => providers/i40iw}/i40iw_umain.h    |     0
 {libi40iw/src => providers/i40iw}/i40iw_user.h     |     0
 {libi40iw/src => providers/i40iw}/i40iw_uverbs.c   |     0
 {libipathverbs => providers/ipathverbs}/AUTHORS    |     0
 providers/ipathverbs/CMakeLists.txt                |     8 +
 {libipathverbs => providers/ipathverbs}/COPYING    |     0
 {libipathverbs => providers/ipathverbs}/README     |     0
 .../ipathverbs}/dracut_check                       |     0
 .../ipathverbs}/dracut_install                     |     0
 .../ipathverbs}/dracut_kmod                        |     0
 .../src => providers/ipathverbs}/ipath-abi.h       |     0
 .../src => providers/ipathverbs}/ipathverbs.c      |     0
 .../src => providers/ipathverbs}/ipathverbs.h      |     0
 .../ipathverbs}/truescale-serdes.cmds              |     0
 .../ipathverbs}/truescale.conf                     |     0
 .../src => providers/ipathverbs}/verbs.c           |     0
 {libmlx4 => providers/mlx4}/AUTHORS                |     0
 providers/mlx4/CMakeLists.txt                      |     9 +
 {libmlx4 => providers/mlx4}/README                 |     0
 {libmlx4/src => providers/mlx4}/buf.c              |     0
 {libmlx4/src => providers/mlx4}/cq.c               |     0
 {libmlx4/src => providers/mlx4}/dbrec.c            |     2 +-
 {libmlx4/src => providers/mlx4}/doorbell.h         |     0
 {libmlx4/src => providers/mlx4}/mlx4-abi.h         |     0
 {libmlx4/src => providers/mlx4}/mlx4.c             |     0
 {libmlx4/src => providers/mlx4}/mlx4.h             |     0
 {libmlx4/src => providers/mlx4}/mmio.h             |     0
 {libmlx4/src => providers/mlx4}/qp.c               |     0
 {libmlx4/src => providers/mlx4}/srq.c              |     0
 {libmlx4/src => providers/mlx4}/verbs.c            |     0
 {libmlx4/src => providers/mlx4}/wqe.h              |     0
 {libmlx5 => providers/mlx5}/AUTHORS                |     0
 providers/mlx5/CMakeLists.txt                      |     9 +
 {libmlx5 => providers/mlx5}/README                 |     0
 {libmlx5/src => providers/mlx5}/bitmap.h           |     0
 {libmlx5/src => providers/mlx5}/buf.c              |     0
 {libmlx5/src => providers/mlx5}/cq.c               |     0
 {libmlx5/src => providers/mlx5}/dbrec.c            |     3 +-
 {libmlx5/src => providers/mlx5}/doorbell.h         |     0
 {libmlx5/src => providers/mlx5}/list.h             |     0
 {libmlx5/src => providers/mlx5}/mlx5-abi.h         |     0
 {libmlx5/src => providers/mlx5}/mlx5.c             |     3 +-
 {libmlx5/src => providers/mlx5}/mlx5.h             |     0
 {libmlx5/src => providers/mlx5}/qp.c               |     0
 {libmlx5/src => providers/mlx5}/srq.c              |     0
 {libmlx5/src => providers/mlx5}/verbs.c            |     0
 {libmlx5/src => providers/mlx5}/wqe.h              |     0
 {libmthca => providers/mthca}/AUTHORS              |     0
 providers/mthca/CMakeLists.txt                     |    10 +
 {libmthca => providers/mthca}/README               |     0
 {libmthca/src => providers/mthca}/ah.c             |     0
 {libmthca/src => providers/mthca}/buf.c            |     0
 {libmthca/src => providers/mthca}/cq.c             |     0
 {libmthca/src => providers/mthca}/doorbell.h       |     0
 {libmthca/src => providers/mthca}/memfree.c        |     2 +-
 {libmthca/src => providers/mthca}/mthca-abi.h      |     0
 {libmthca/src => providers/mthca}/mthca.c          |     0
 {libmthca/src => providers/mthca}/mthca.h          |     0
 {libmthca/src => providers/mthca}/qp.c             |     0
 {libmthca/src => providers/mthca}/srq.c            |     0
 {libmthca/src => providers/mthca}/verbs.c          |     0
 {libmthca/src => providers/mthca}/wqe.h            |     0
 {libi40iw => providers/nes}/AUTHORS                |     0
 providers/nes/CMakeLists.txt                       |     4 +
 {libnes => providers/nes}/COPYING                  |     0
 {libnes/src => providers/nes}/nes-abi.h            |     0
 {libnes/src => providers/nes}/nes_umain.c          |     0
 {libnes/src => providers/nes}/nes_umain.h          |     0
 {libnes/src => providers/nes}/nes_uverbs.c         |     0
 {libocrdma => providers/ocrdma}/AUTHORS            |     0
 providers/ocrdma/CMakeLists.txt                    |     4 +
 {libocrdma => providers/ocrdma}/Changelog          |     0
 {libocrdma => providers/ocrdma}/README             |     0
 {libocrdma/src => providers/ocrdma}/ocrdma_abi.h   |     0
 {libocrdma/src => providers/ocrdma}/ocrdma_list.h  |     0
 {libocrdma/src => providers/ocrdma}/ocrdma_main.c  |     0
 {libocrdma/src => providers/ocrdma}/ocrdma_main.h  |     0
 {libocrdma/src => providers/ocrdma}/ocrdma_verbs.c |     0
 providers/rxe/CMakeLists.txt                       |     7 +
 {librxe => providers/rxe}/README.md                |     0
 providers/rxe/man/CMakeLists.txt                   |     4 +
 {librxe => providers/rxe}/man/rxe.7                |     0
 {librxe => providers/rxe}/man/rxe_cfg.8            |     0
 {librxe/src => providers/rxe}/rxe-abi.h            |     0
 {librxe/src => providers/rxe}/rxe.c                |     0
 {librxe/src => providers/rxe}/rxe.h                |     0
 {librxe => providers/rxe}/rxe_cfg                  |     0
 {librxe/src => providers/rxe}/rxe_queue.h          |     0
 350 files changed, 1506 insertions(+), 54315 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 CMakeLists.txt
 create mode 100644 COPYING
 create mode 100644 COPYING.BSD
 rename libnes/gpl-2.0.txt => COPYING.GPL2 (98%)
 create mode 100644 MAINTAINERS
 create mode 100644 README.md
 create mode 100644 buildlib/FindLDSymVer.cmake
 create mode 100644 buildlib/RDMA_BuildType.cmake
 create mode 100644 buildlib/RDMA_DoFixup.cmake
 create mode 100644 buildlib/RDMA_EnableCStd.cmake
 create mode 100644 buildlib/config.h.in
 create mode 100644 buildlib/fixup-include/rdma-rdma_user_rxe.h
 create mode 100644 buildlib/fixup-include/valgrind-memcheck.h
 create mode 100644 buildlib/provider.map
 create mode 100644 buildlib/publish_headers.cmake
 create mode 100644 buildlib/rdma_functions.cmake
 delete mode 100644 libcxgb3/ChangeLog
 delete mode 100644 libcxgb3/Makefile.am
 delete mode 100755 libcxgb3/autogen.sh
 delete mode 100644 libcxgb3/config/.gitignore
 delete mode 100644 libcxgb3/configure.in
 delete mode 100644 libcxgb3/cxgb3.driver
 delete mode 100644 libcxgb3/libcxgb3.spec.in
 delete mode 100644 libcxgb3/src/iwch.map
 delete mode 100644 libcxgb4/COPYING
 delete mode 100644 libcxgb4/ChangeLog
 delete mode 100644 libcxgb4/Makefile.am
 delete mode 100755 libcxgb4/autogen.sh
 delete mode 100755 libcxgb4/config/config.guess
 delete mode 100755 libcxgb4/config/config.sub
 delete mode 100755 libcxgb4/config/depcomp
 delete mode 100755 libcxgb4/config/install-sh
 delete mode 100644 libcxgb4/configure.in
 delete mode 100644 libcxgb4/cxgb4.driver
 delete mode 100644 libcxgb4/libcxgb4.spec.in
 delete mode 100644 libcxgb4/src/cxgb4.map
 delete mode 100644 libhfi1verbs/.gitignore
 delete mode 100644 libhfi1verbs/Makefile.am
 delete mode 100755 libhfi1verbs/autogen.sh
 delete mode 100644 libhfi1verbs/configure.in
 delete mode 100644 libhfi1verbs/hfi1.driver
 delete mode 100644 libhfi1verbs/libhfi1verbs.spec.in
 delete mode 100644 libhfi1verbs/makefile
 delete mode 100644 libhfi1verbs/makesrpm.sh
 delete mode 100644 libhfi1verbs/src/hfiverbs.map
 delete mode 100644 libi40iw/COPYING
 delete mode 100644 libi40iw/Makefile.am
 delete mode 100644 libi40iw/configure.ac
 delete mode 100644 libi40iw/i40iw.driver
 delete mode 100644 libi40iw/libi40iw.spec.in
 delete mode 100644 libi40iw/src/i40iw.map
 delete mode 100644 libibcm/COPYING
 delete mode 100644 libibcm/ChangeLog
 delete mode 100644 libibcm/Makefile.am
 delete mode 100755 libibcm/autogen.sh
 delete mode 100644 libibcm/configure.in
 create mode 100644 libibcm/examples/CMakeLists.txt
 create mode 100644 libibcm/src/CMakeLists.txt
 mode change 100755 => 100644 libibcm/src/cm.c
 delete mode 100644 libibumad/COPYING
 delete mode 100644 libibumad/ChangeLog
 delete mode 100644 libibumad/Makefile.am
 delete mode 100755 libibumad/autogen.sh
 delete mode 100644 libibumad/configure.in
 create mode 100644 libibumad/man/CMakeLists.txt
 create mode 100644 libibumad/src/CMakeLists.txt
 create mode 100644 libibumad/tests/CMakeLists.txt
 delete mode 100644 libibverbs/.gitignore
 delete mode 100644 libibverbs/COPYING
 delete mode 100644 libibverbs/ChangeLog
 delete mode 100644 libibverbs/Makefile.am
 delete mode 100755 libibverbs/autogen.sh
 delete mode 100644 libibverbs/config/.gitignore
 delete mode 100644 libibverbs/configure.ac
 delete mode 100644 libibverbs/examples/.gitignore
 create mode 100644 libibverbs/examples/CMakeLists.txt
 create mode 100644 libibverbs/man/CMakeLists.txt
 delete mode 100644 libibverbs/src/.gitignore
 create mode 100644 libibverbs/src/CMakeLists.txt
 delete mode 100644 libipathverbs/.gitignore
 delete mode 100644 libipathverbs/Makefile.am
 delete mode 100755 libipathverbs/autogen.sh
 delete mode 100644 libipathverbs/configure.in
 delete mode 100644 libipathverbs/ipath.driver
 delete mode 100644 libipathverbs/libipathverbs.spec.in
 delete mode 100644 libipathverbs/src/ipathverbs.map
 delete mode 100644 libmlx4/.gitignore
 delete mode 100644 libmlx4/COPYING
 delete mode 100644 libmlx4/Makefile.am
 delete mode 100755 libmlx4/autogen.sh
 delete mode 100644 libmlx4/config/.gitignore
 delete mode 100644 libmlx4/configure.ac
 delete mode 100644 libmlx4/debian/changelog
 delete mode 100644 libmlx4/debian/compat
 delete mode 100644 libmlx4/debian/control
 delete mode 100644 libmlx4/debian/copyright
 delete mode 100644 libmlx4/debian/libmlx4-1.install
 delete mode 100644 libmlx4/debian/libmlx4-dev.install
 delete mode 100644 libmlx4/debian/patches/driver-plugin-directory.patch
 delete mode 100644 libmlx4/debian/patches/series
 delete mode 100755 libmlx4/debian/rules
 delete mode 100644 libmlx4/debian/source/format
 delete mode 100644 libmlx4/debian/watch
 delete mode 100644 libmlx4/libmlx4.spec.in
 delete mode 100644 libmlx4/mlx4.driver
 delete mode 100644 libmlx4/src/.gitignore
 delete mode 100644 libmlx4/src/mlx4.map
 delete mode 100644 libmlx5/.gitignore
 delete mode 100644 libmlx5/COPYING
 delete mode 100644 libmlx5/Makefile.am
 delete mode 100755 libmlx5/autogen.sh
 delete mode 100644 libmlx5/config/.gitignore
 delete mode 100644 libmlx5/configure.ac
 delete mode 100644 libmlx5/debian/changelog
 delete mode 100644 libmlx5/debian/compat
 delete mode 100644 libmlx5/debian/control
 delete mode 100644 libmlx5/debian/copyright
 delete mode 100644 libmlx5/debian/libmlx5-1.install
 delete mode 100644 libmlx5/debian/libmlx5-dev.install
 delete mode 100644 libmlx5/debian/patches/driver-plugin-directory.patch
 delete mode 100644 libmlx5/debian/patches/series
 delete mode 100755 libmlx5/debian/rules
 delete mode 100644 libmlx5/debian/source/format
 delete mode 100644 libmlx5/debian/watch
 delete mode 100644 libmlx5/libmlx5.spec.in
 delete mode 100644 libmlx5/m4/ax_gcc_func_attribute.m4
 delete mode 100644 libmlx5/mlx5.driver
 delete mode 100644 libmlx5/src/.gitignore
 delete mode 100644 libmlx5/src/mlx5.map
 delete mode 100644 libmthca/.gitignore
 delete mode 100644 libmthca/COPYING
 delete mode 100644 libmthca/ChangeLog
 delete mode 100644 libmthca/Makefile.am
 delete mode 100755 libmthca/autogen.sh
 delete mode 100644 libmthca/config/.gitignore
 delete mode 100644 libmthca/configure.in
 delete mode 100644 libmthca/debian/changelog
 delete mode 100644 libmthca/debian/compat
 delete mode 100644 libmthca/debian/control
 delete mode 100644 libmthca/debian/copyright
 delete mode 100644 libmthca/debian/libmthca-dev.install
 delete mode 100644 libmthca/debian/libmthca1.install
 delete mode 100644 libmthca/debian/patches/driver-plugin-directory.patch
 delete mode 100644 libmthca/debian/patches/series
 delete mode 100755 libmthca/debian/rules
 delete mode 100644 libmthca/debian/source/format
 delete mode 100644 libmthca/debian/watch
 delete mode 100644 libmthca/libmthca.spec.in
 delete mode 100644 libmthca/mthca.driver
 delete mode 100644 libmthca/src/.gitignore
 delete mode 100644 libmthca/src/mthca.map
 delete mode 100644 libnes/Makefile.am
 delete mode 100755 libnes/autogen.sh
 delete mode 100644 libnes/config/.gitignore
 delete mode 100644 libnes/configure.in
 delete mode 100644 libnes/libnes.spec.in
 delete mode 100644 libnes/nes.driver
 delete mode 100644 libnes/src/nes.map
 delete mode 100644 libocrdma/COPYING
 delete mode 100644 libocrdma/Makefile.am
 delete mode 100644 libocrdma/autogen.sh
 delete mode 100644 libocrdma/config/.gitignore
 delete mode 100644 libocrdma/configure.in
 delete mode 100644 libocrdma/libocrdma.spec.in
 delete mode 100644 libocrdma/ocrdma.driver
 delete mode 100644 libocrdma/src/ocrdma.map
 delete mode 100644 librdmacm/.gitignore
 delete mode 100644 librdmacm/COPYING
 delete mode 100644 librdmacm/ChangeLog
 delete mode 100644 librdmacm/Makefile.am
 delete mode 100755 librdmacm/autogen.sh
 delete mode 100644 librdmacm/configure.ac
 delete mode 100644 librdmacm/examples/.gitignore
 create mode 100644 librdmacm/examples/CMakeLists.txt
 create mode 100644 librdmacm/man/CMakeLists.txt
 delete mode 100644 librdmacm/src/.gitignore
 create mode 100644 librdmacm/src/CMakeLists.txt
 create mode 100644 librdmacm/src/librspreload.map
 delete mode 100644 librxe/AUTHORS
 delete mode 100644 librxe/COPYING
 delete mode 100644 librxe/ChangeLog
 delete mode 100644 librxe/INSTALL
 delete mode 100644 librxe/Makefile.am
 delete mode 100644 librxe/Makefile.in
 delete mode 100644 librxe/NEWS
 delete mode 100644 librxe/README
 delete mode 100644 librxe/aclocal.m4
 delete mode 100644 librxe/config.h.in
 delete mode 100755 librxe/config/config.guess
 delete mode 100755 librxe/config/config.sub
 delete mode 100755 librxe/config/depcomp
 delete mode 100755 librxe/config/install-sh
 delete mode 100755 librxe/config/ltmain.sh
 delete mode 100755 librxe/config/missing
 delete mode 100755 librxe/configure
 delete mode 100644 librxe/configure.in
 delete mode 100644 librxe/librxe.spec
 delete mode 100644 librxe/librxe.spec.in
 delete mode 100644 librxe/rxe.driver
 delete mode 100644 librxe/src/rxe.map
 rename {libcxgb4 => providers/cxgb3}/AUTHORS (100%)
 create mode 100644 providers/cxgb3/CMakeLists.txt
 rename {libcxgb3 => providers/cxgb3}/COPYING (100%)
 rename {libcxgb3 => providers/cxgb3}/README (100%)
 rename {libcxgb3/src => providers/cxgb3}/cq.c (100%)
 rename {libcxgb3/src => providers/cxgb3}/cxio_wr.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/firmware_exports.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/iwch-abi.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/iwch.c (100%)
 rename {libcxgb3/src => providers/cxgb3}/iwch.h (100%)
 rename {libcxgb3/src => providers/cxgb3}/qp.c (100%)
 rename {libcxgb3/src => providers/cxgb3}/verbs.c (100%)
 rename {libcxgb3 => providers/cxgb4}/AUTHORS (100%)
 create mode 100644 providers/cxgb4/CMakeLists.txt
 rename {libcxgb4 => providers/cxgb4}/README (100%)
 rename {libcxgb4/src => providers/cxgb4}/cq.c (100%)
 rename {libcxgb4/src => providers/cxgb4}/cxgb4-abi.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/dev.c (100%)
 rename {libcxgb4/src => providers/cxgb4}/libcxgb4.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/qp.c (100%)
 rename {libcxgb4/src => providers/cxgb4}/queue.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4_chip_type.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4_pci_id_tbl.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4_regs.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/t4fw_interface.h (100%)
 rename {libcxgb4/src => providers/cxgb4}/verbs.c (100%)
 rename {libhfi1verbs => providers/hfi1verbs}/AUTHORS (100%)
 create mode 100644 providers/hfi1verbs/CMakeLists.txt
 rename {libhfi1verbs => providers/hfi1verbs}/COPYING (100%)
 rename {libhfi1verbs => providers/hfi1verbs}/README (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/hfi-abi.h (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/hfiverbs.c (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/hfiverbs.h (100%)
 rename {libhfi1verbs/src => providers/hfi1verbs}/verbs.c (100%)
 rename {libnes => providers/i40iw}/AUTHORS (100%)
 create mode 100644 providers/i40iw/CMakeLists.txt
 rename {libi40iw/src => providers/i40iw}/i40e_devids.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw-abi.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_d.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_osdep.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_register.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_status.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_uk.c (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_umain.c (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_umain.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_user.h (100%)
 rename {libi40iw/src => providers/i40iw}/i40iw_uverbs.c (100%)
 rename {libipathverbs => providers/ipathverbs}/AUTHORS (100%)
 create mode 100644 providers/ipathverbs/CMakeLists.txt
 rename {libipathverbs => providers/ipathverbs}/COPYING (100%)
 rename {libipathverbs => providers/ipathverbs}/README (100%)
 rename {libipathverbs => providers/ipathverbs}/dracut_check (100%)
 rename {libipathverbs => providers/ipathverbs}/dracut_install (100%)
 rename {libipathverbs => providers/ipathverbs}/dracut_kmod (100%)
 rename {libipathverbs/src => providers/ipathverbs}/ipath-abi.h (100%)
 rename {libipathverbs/src => providers/ipathverbs}/ipathverbs.c (100%)
 rename {libipathverbs/src => providers/ipathverbs}/ipathverbs.h (100%)
 rename {libipathverbs => providers/ipathverbs}/truescale-serdes.cmds (100%)
 mode change 100644 => 100755
 rename {libipathverbs => providers/ipathverbs}/truescale.conf (100%)
 rename {libipathverbs/src => providers/ipathverbs}/verbs.c (100%)
 rename {libmlx4 => providers/mlx4}/AUTHORS (100%)
 create mode 100644 providers/mlx4/CMakeLists.txt
 rename {libmlx4 => providers/mlx4}/README (100%)
 rename {libmlx4/src => providers/mlx4}/buf.c (100%)
 rename {libmlx4/src => providers/mlx4}/cq.c (100%)
 rename {libmlx4/src => providers/mlx4}/dbrec.c (99%)
 rename {libmlx4/src => providers/mlx4}/doorbell.h (100%)
 rename {libmlx4/src => providers/mlx4}/mlx4-abi.h (100%)
 rename {libmlx4/src => providers/mlx4}/mlx4.c (100%)
 rename {libmlx4/src => providers/mlx4}/mlx4.h (100%)
 rename {libmlx4/src => providers/mlx4}/mmio.h (100%)
 rename {libmlx4/src => providers/mlx4}/qp.c (100%)
 rename {libmlx4/src => providers/mlx4}/srq.c (100%)
 rename {libmlx4/src => providers/mlx4}/verbs.c (100%)
 rename {libmlx4/src => providers/mlx4}/wqe.h (100%)
 rename {libmlx5 => providers/mlx5}/AUTHORS (100%)
 create mode 100644 providers/mlx5/CMakeLists.txt
 rename {libmlx5 => providers/mlx5}/README (100%)
 rename {libmlx5/src => providers/mlx5}/bitmap.h (100%)
 rename {libmlx5/src => providers/mlx5}/buf.c (100%)
 rename {libmlx5/src => providers/mlx5}/cq.c (100%)
 rename {libmlx5/src => providers/mlx5}/dbrec.c (99%)
 rename {libmlx5/src => providers/mlx5}/doorbell.h (100%)
 rename {libmlx5/src => providers/mlx5}/list.h (100%)
 rename {libmlx5/src => providers/mlx5}/mlx5-abi.h (100%)
 rename {libmlx5/src => providers/mlx5}/mlx5.c (99%)
 rename {libmlx5/src => providers/mlx5}/mlx5.h (100%)
 rename {libmlx5/src => providers/mlx5}/qp.c (100%)
 rename {libmlx5/src => providers/mlx5}/srq.c (100%)
 rename {libmlx5/src => providers/mlx5}/verbs.c (100%)
 rename {libmlx5/src => providers/mlx5}/wqe.h (100%)
 rename {libmthca => providers/mthca}/AUTHORS (100%)
 create mode 100644 providers/mthca/CMakeLists.txt
 rename {libmthca => providers/mthca}/README (100%)
 rename {libmthca/src => providers/mthca}/ah.c (100%)
 rename {libmthca/src => providers/mthca}/buf.c (100%)
 rename {libmthca/src => providers/mthca}/cq.c (100%)
 rename {libmthca/src => providers/mthca}/doorbell.h (100%)
 rename {libmthca/src => providers/mthca}/memfree.c (99%)
 rename {libmthca/src => providers/mthca}/mthca-abi.h (100%)
 rename {libmthca/src => providers/mthca}/mthca.c (100%)
 rename {libmthca/src => providers/mthca}/mthca.h (100%)
 rename {libmthca/src => providers/mthca}/qp.c (100%)
 rename {libmthca/src => providers/mthca}/srq.c (100%)
 rename {libmthca/src => providers/mthca}/verbs.c (100%)
 rename {libmthca/src => providers/mthca}/wqe.h (100%)
 rename {libi40iw => providers/nes}/AUTHORS (100%)
 create mode 100644 providers/nes/CMakeLists.txt
 rename {libnes => providers/nes}/COPYING (100%)
 rename {libnes/src => providers/nes}/nes-abi.h (100%)
 rename {libnes/src => providers/nes}/nes_umain.c (100%)
 rename {libnes/src => providers/nes}/nes_umain.h (100%)
 rename {libnes/src => providers/nes}/nes_uverbs.c (100%)
 rename {libocrdma => providers/ocrdma}/AUTHORS (100%)
 create mode 100644 providers/ocrdma/CMakeLists.txt
 rename {libocrdma => providers/ocrdma}/Changelog (100%)
 rename {libocrdma => providers/ocrdma}/README (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_abi.h (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_list.h (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_main.c (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_main.h (100%)
 rename {libocrdma/src => providers/ocrdma}/ocrdma_verbs.c (100%)
 create mode 100644 providers/rxe/CMakeLists.txt
 rename {librxe => providers/rxe}/README.md (100%)
 create mode 100644 providers/rxe/man/CMakeLists.txt
 rename {librxe => providers/rxe}/man/rxe.7 (100%)
 rename {librxe => providers/rxe}/man/rxe_cfg.8 (100%)
 rename {librxe/src => providers/rxe}/rxe-abi.h (100%)
 rename {librxe/src => providers/rxe}/rxe.c (100%)
 rename {librxe/src => providers/rxe}/rxe.h (100%)
 rename {librxe => providers/rxe}/rxe_cfg (100%)
 rename {librxe/src => providers/rxe}/rxe_queue.h (100%)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
