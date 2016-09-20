From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 00/16] Consolidated RDMA userspace: rdma-core
Date: Tue, 20 Sep 2016 16:10:09 -0600
Message-ID: <1474409425-15769-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Donald Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Jolly <jjolly-IBi9RG/b67k@public.gmane.org>, Kamal Heib <kheib-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise@opengridcomputing.c>
List-Id: linux-rdma@vger.kernel.org

Hello Everyone,

We are starting the transition to the consolidated user space. Doug has setup
a shared github here:

  https://github.com/linux-rdma/rdma-core

Which now contains the base 'merge' commit, this is simply each of the
original 18 repositories placed in a sub directory, unmodified.

This tree will not be rebased. New work can target this tree.

An earlier version of the patch series that follows has already been
posted, and has been part of my preview tree for some time. The
original mailing list threads are here:

  http://www.spinics.net/lists/linux-rdma/msg39026.html
  http://www.spinics.net/lists/linux-rdma/msg39328.html
  http://www.spinics.net/lists/linux-rdma/msg40014.html
  http://www.spinics.net/lists/linux-rdma/msg40086.html

This series to unify the build system (+ any comments) will be applied to the
tree right away and Doug + Leon will start generally accepting patches.

My preview tree:
 https://github.com/jgunthorpe/rdma-plumbing

Contains another ~70 patches which will be batched up and posted to this list
for review. Notably those patches include the sample RPM and DEB packaging,
and other packaging related items.

Jason

Christoph Hellwig (2):
  Remove README files in the provider directories
  Remove iwpmd/README

Jason Gunthorpe (14):
  Fix bogus executable file permissions
  Include pthreads in the provider libraries
  Be explicit about _GNU_SOURCE
  hfi/ipath: Use the name of the provider for the .driver file
  ibcm: Actually use the version script when linking
  iwpm: Update autotools enough to build
  rdmacm: Control symbol export from librspreload
  Unified CMake build system
  Support obsolete cmake from 2013
  Add a MAINTAINERS file
  Remove the auto* based build systems
  Remove the ChangeLog files
  Remove Debian and RPM packaging files
  ibacm: Remove windows support files

 CMakeLists.txt                                     |   293 +
 COPYING                                            |     6 +
 COPYING.BSD                                        |    26 +
 srp_daemon/debian/copyright => COPYING.GPL2        |    51 +-
 MAINTAINERS                                        |   125 +
 README.md                                          |    97 +
 buildlib/FindLDSymVer.cmake                        |    41 +
 buildlib/RDMA_DoFixup.cmake                        |    25 +
 buildlib/RDMA_EnableCStd.cmake                     |    23 +
 buildlib/config.h.in                               |    35 +
 buildlib/fixup-include/rdma-rdma_user_rxe.h        |   144 +
 buildlib/fixup-include/valgrind-drd.h              |     3 +
 buildlib/fixup-include/valgrind-memcheck.h         |     5 +
 buildlib/provider.map                              |     6 +
 buildlib/publish_headers.cmake                     |    20 +
 buildlib/rdma_functions.cmake                      |   280 +
 ibacm/CMakeLists.txt                               |    69 +
 ibacm/ChangeLog                                    |     0
 ibacm/INSTALL                                      |     0
 ibacm/Makefile.am                                  |    49 -
 ibacm/NEWS                                         |     0
 ibacm/README                                       |    12 -
 ibacm/autogen.sh                                   |     5 -
 ibacm/configure.ac                                 |   106 -
 ibacm/dirs                                         |     1 -
 ibacm/ibacm.spec.in                                |    90 -
 ibacm/windows/acm_windows.c                        |    33 -
 ibacm/windows/acme/SOURCES                         |    36 -
 ibacm/windows/acme/makefile                        |     7 -
 ibacm/windows/acme_windows.c                       |    96 -
 ibacm/windows/dirs                                 |     1 -
 ibacm/windows/libacm_windows.c                     |    52 -
 ibacm/windows/library/Sources                      |    32 -
 ibacm/windows/library/libacm.rc                    |    46 -
 ibacm/windows/library/libacm_export.def            |    34 -
 ibacm/windows/library/libacm_exports.src           |    12 -
 ibacm/windows/library/makefile                     |     7 -
 ibacm/windows/osd.h                                |    91 -
 ibacm/windows/service/Sources                      |    31 -
 ibacm/windows/service/makefile                     |     7 -
 iwpmd/ChangeLog                                    |   276 -
 iwpmd/Makefile.am                                  |    11 -
 iwpmd/README                                       |    36 -
 iwpmd/autogen.sh                                   |    11 -
 iwpmd/configure.ac                                 |    37 -
 iwpmd/iwpmd.spec.in                                |   127 -
 iwpmd/src/CMakeLists.txt                           |    12 +
 libcxgb3/ChangeLog                                 |   791 -
 libcxgb3/Makefile.am                               |    27 -
 libcxgb3/README                                    |    19 -
 libcxgb3/autogen.sh                                |     8 -
 libcxgb3/config/.gitignore                         |     0
 libcxgb3/configure.in                              |    69 -
 libcxgb3/cxgb3.driver                              |     1 -
 libcxgb3/libcxgb3.spec.in                          |    55 -
 libcxgb3/src/CMakeLists.txt                        |     6 +
 libcxgb3/src/iwch.map                              |     6 -
 libcxgb4/ChangeLog                                 |  1133 --
 libcxgb4/Makefile.am                               |    27 -
 libcxgb4/README                                    |    19 -
 libcxgb4/autogen.sh                                |     8 -
 libcxgb4/config/config.guess                       |  1439 --
 libcxgb4/config/config.sub                         |  1811 ---
 libcxgb4/config/depcomp                            |   530 -
 libcxgb4/config/install-sh                         |   323 -
 libcxgb4/configure.in                              |    69 -
 libcxgb4/cxgb4.driver                              |     1 -
 libcxgb4/libcxgb4.spec.in                          |    55 -
 libcxgb4/src/CMakeLists.txt                        |     8 +
 libcxgb4/src/cxgb4.map                             |     6 -
 libhfi1verbs/Makefile.am                           |    83 -
 libhfi1verbs/README                                |    23 -
 libhfi1verbs/add_fedora_entry.sh                   |    18 -
 libhfi1verbs/autogen.sh                            |    64 -
 libhfi1verbs/configure.in                          |   124 -
 libhfi1verbs/fedora_changelog.txt                  |     2 -
 libhfi1verbs/hfi1.driver                           |     1 -
 libhfi1verbs/libhfi1.spec.in                       |   109 -
 libhfi1verbs/makefile                              |   107 -
 libhfi1verbs/makesrpm.sh                           |    21 -
 libhfi1verbs/src/CMakeLists.txt                    |     4 +
 libhfi1verbs/src/hfiverbs.map                      |     4 -
 libi40iw/Makefile.am                               |    26 -
 libi40iw/configure.ac                              |    72 -
 libi40iw/i40iw.driver                              |     1 -
 libi40iw/libi40iw.spec.in                          |    72 -
 libi40iw/src/CMakeLists.txt                        |     5 +
 libi40iw/src/i40iw.map                             |    39 -
 libibcm/ChangeLog                                  |     0
 libibcm/INSTALL                                    |     0
 libibcm/Makefile.am                                |    35 -
 libibcm/NEWS                                       |     0
 libibcm/autogen.sh                                 |     9 -
 libibcm/configure.in                               |    72 -
 libibcm/examples/CMakeLists.txt                    |     2 +
 libibcm/libibcm.spec.in                            |    53 -
 libibcm/src/CMakeLists.txt                         |     9 +
 libibcm/src/cm.c                                   |     2 +-
 libibumad/ChangeLog                                |    94 -
 libibumad/Makefile.am                              |    75 -
 libibumad/autogen.sh                               |    11 -
 libibumad/configure.in                             |    72 -
 libibumad/libibumad.spec.in                        |    74 -
 libibumad/man/CMakeLists.txt                       |    42 +
 libibumad/src/CMakeLists.txt                       |    14 +
 libibumad/tests/CMakeLists.txt                     |     5 +
 libibverbs/ChangeLog                               |   583 -
 libibverbs/Makefile.am                             |   132 -
 libibverbs/autogen.sh                              |     4 -
 libibverbs/config/.gitignore                       |     8 -
 libibverbs/configure.ac                            |   125 -
 libibverbs/debian/changelog                        |   139 -
 libibverbs/debian/compat                           |     1 -
 libibverbs/debian/control                          |    80 -
 libibverbs/debian/copyright                        |    49 -
 libibverbs/debian/ibverbs-utils.install            |     2 -
 libibverbs/debian/libibverbs-dev.install           |     4 -
 libibverbs/debian/libibverbs-dev.links             |    16 -
 libibverbs/debian/libibverbs1.install              |     1 -
 libibverbs/debian/libibverbs1.postinst             |    10 -
 libibverbs/debian/rules                            |    11 -
 libibverbs/debian/source/format                    |     1 -
 libibverbs/debian/watch                            |     3 -
 libibverbs/examples/CMakeLists.txt                 |    31 +
 libibverbs/examples/asyncwatch.c                   |     2 +-
 libibverbs/examples/rc_pingpong.c                  |     2 +-
 libibverbs/examples/srq_pingpong.c                 |     2 +-
 libibverbs/examples/uc_pingpong.c                  |     2 +-
 libibverbs/examples/ud_pingpong.c                  |     2 +-
 libibverbs/examples/xsrq_pingpong.c                |     2 +-
 libibverbs/libibverbs.spec.in                      |   169 -
 libibverbs/man/CMakeLists.txt                      |    83 +
 libibverbs/src/CMakeLists.txt                      |    36 +
 libibverbs/src/device.c                            |     2 +-
 libibverbs/src/init.c                              |     2 +-
 libibverbs/src/sysfs.c                             |     2 +-
 libibverbs/src/verbs.c                             |     1 +
 libipathverbs/CMakeLists.txt                       |     4 +
 libipathverbs/Makefile.am                          |    79 -
 libipathverbs/README                               |    24 -
 libipathverbs/autogen.sh                           |    43 -
 libipathverbs/configure.in                         |   118 -
 libipathverbs/ipath.driver                         |     1 -
 libipathverbs/libipathverbs.spec.in                |   104 -
 libipathverbs/src/CMakeLists.txt                   |     4 +
 libipathverbs/src/ipathverbs.map                   |     4 -
 libipathverbs/truescale-serdes.cmds                |     0
 libmlx4/Makefile.am                                |    19 -
 libmlx4/README                                     |    58 -
 libmlx4/autogen.sh                                 |     4 -
 libmlx4/config/.gitignore                          |     8 -
 libmlx4/configure.ac                               |    96 -
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
 libmlx4/src/CMakeLists.txt                         |     9 +
 libmlx4/src/mlx4.map                               |     5 -
 libmlx5/Makefile.am                                |    27 -
 libmlx5/README                                     |    14 -
 libmlx5/autogen.sh                                 |     7 -
 libmlx5/config/.gitignore                          |     8 -
 libmlx5/configure.ac                               |   108 -
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
 libmlx5/src/CMakeLists.txt                         |     9 +
 libmlx5/src/mlx5.map                               |     5 -
 libmthca/ChangeLog                                 |   378 -
 libmthca/Makefile.am                               |    29 -
 libmthca/README                                    |    59 -
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
 libmthca/src/CMakeLists.txt                        |    10 +
 libmthca/src/memfree.c                             |     2 +-
 libmthca/src/mthca.map                             |     5 -
 libnes/Makefile.am                                 |    26 -
 libnes/autogen.sh                                  |    12 -
 libnes/config/.gitignore                           |     0
 libnes/configure.in                                |    72 -
 libnes/libnes.spec.in                              |   107 -
 libnes/nes.driver                                  |     1 -
 libnes/src/CMakeLists.txt                          |     4 +
 libnes/src/nes.map                                 |     5 -
 libocrdma/Makefile.am                              |    23 -
 libocrdma/README                                   |    19 -
 libocrdma/autogen.sh                               |     8 -
 libocrdma/config/.gitignore                        |     8 -
 libocrdma/configure.in                             |    68 -
 libocrdma/libocrdma.spec.in                        |    71 -
 libocrdma/ocrdma.driver                            |     1 -
 libocrdma/src/CMakeLists.txt                       |     4 +
 libocrdma/src/ocrdma.map                           |     5 -
 librdmacm/ChangeLog                                |     0
 librdmacm/INSTALL                                  |     0
 librdmacm/Makefile.am                              |   138 -
 librdmacm/NEWS                                     |     0
 librdmacm/autogen.sh                               |     5 -
 librdmacm/configure.ac                             |   108 -
 librdmacm/examples/CMakeLists.txt                  |    43 +
 librdmacm/examples/rping.c                         |     2 +-
 librdmacm/librdmacm.spec.in                        |    79 -
 librdmacm/man/CMakeLists.txt                       |    65 +
 librdmacm/src/CMakeLists.txt                       |    39 +
 librdmacm/src/librspreload.map                     |    33 +
 librdmacm/src/preload.c                            |     6 +-
 librdmacm/src/rsocket.c                            |     2 +-
 librxe/AUTHORS                                     |     0
 librxe/CMakeLists.txt                              |     4 +
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
 librxe/man/CMakeLists.txt                          |     4 +
 librxe/rxe.driver                                  |     1 -
 librxe/src/CMakeLists.txt                          |     3 +
 librxe/src/rxe.map                                 |     5 -
 srp_daemon/ChangeLog                               |    66 -
 srp_daemon/Makefile.am                             |    80 -
 srp_daemon/NEWS                                    |     1 -
 srp_daemon/autogen.sh                              |     7 -
 srp_daemon/build-deb.sh                            |    68 -
 srp_daemon/configure.ac                            |    73 -
 srp_daemon/debian/changelog                        |    11 -
 srp_daemon/debian/compat                           |     1 -
 srp_daemon/debian/control                          |    14 -
 srp_daemon/debian/postinst                         |    26 -
 srp_daemon/debian/prerm                            |    11 -
 srp_daemon/debian/rules                            |    14 -
 srp_daemon/debian/source/format                    |     1 -
 srp_daemon/man/CMakeLists.txt                      |     4 +
 srp_daemon/srp_daemon/CMakeLists.txt               |    32 +
 srp_daemon/srptools.spec.in                        |   141 -
 282 files changed, 1750 insertions(+), 53469 deletions(-)
 create mode 100644 CMakeLists.txt
 create mode 100644 COPYING
 create mode 100644 COPYING.BSD
 rename srp_daemon/debian/copyright => COPYING.GPL2 (89%)
 create mode 100644 MAINTAINERS
 create mode 100644 README.md
 create mode 100644 buildlib/FindLDSymVer.cmake
 create mode 100644 buildlib/RDMA_DoFixup.cmake
 create mode 100644 buildlib/RDMA_EnableCStd.cmake
 create mode 100644 buildlib/config.h.in
 create mode 100644 buildlib/fixup-include/rdma-rdma_user_rxe.h
 create mode 100644 buildlib/fixup-include/valgrind-drd.h
 create mode 100644 buildlib/fixup-include/valgrind-memcheck.h
 create mode 100644 buildlib/provider.map
 create mode 100644 buildlib/publish_headers.cmake
 create mode 100644 buildlib/rdma_functions.cmake
 create mode 100644 ibacm/CMakeLists.txt
 delete mode 100644 ibacm/ChangeLog
 delete mode 100644 ibacm/INSTALL
 delete mode 100644 ibacm/Makefile.am
 delete mode 100644 ibacm/NEWS
 delete mode 100644 ibacm/README
 delete mode 100755 ibacm/autogen.sh
 delete mode 100644 ibacm/configure.ac
 delete mode 100644 ibacm/dirs
 delete mode 100644 ibacm/ibacm.spec.in
 delete mode 100644 ibacm/windows/acm_windows.c
 delete mode 100644 ibacm/windows/acme/SOURCES
 delete mode 100644 ibacm/windows/acme/makefile
 delete mode 100644 ibacm/windows/acme_windows.c
 delete mode 100644 ibacm/windows/dirs
 delete mode 100644 ibacm/windows/libacm_windows.c
 delete mode 100644 ibacm/windows/library/Sources
 delete mode 100644 ibacm/windows/library/libacm.rc
 delete mode 100644 ibacm/windows/library/libacm_export.def
 delete mode 100644 ibacm/windows/library/libacm_exports.src
 delete mode 100644 ibacm/windows/library/makefile
 delete mode 100644 ibacm/windows/osd.h
 delete mode 100644 ibacm/windows/service/Sources
 delete mode 100644 ibacm/windows/service/makefile
 delete mode 100644 iwpmd/ChangeLog
 delete mode 100644 iwpmd/Makefile.am
 delete mode 100644 iwpmd/README
 delete mode 100755 iwpmd/autogen.sh
 delete mode 100644 iwpmd/configure.ac
 delete mode 100644 iwpmd/iwpmd.spec.in
 create mode 100644 iwpmd/src/CMakeLists.txt
 delete mode 100644 libcxgb3/ChangeLog
 delete mode 100644 libcxgb3/Makefile.am
 delete mode 100644 libcxgb3/README
 delete mode 100755 libcxgb3/autogen.sh
 delete mode 100644 libcxgb3/config/.gitignore
 delete mode 100644 libcxgb3/configure.in
 delete mode 100644 libcxgb3/cxgb3.driver
 delete mode 100644 libcxgb3/libcxgb3.spec.in
 create mode 100644 libcxgb3/src/CMakeLists.txt
 delete mode 100644 libcxgb3/src/iwch.map
 delete mode 100644 libcxgb4/ChangeLog
 delete mode 100644 libcxgb4/Makefile.am
 delete mode 100644 libcxgb4/README
 delete mode 100755 libcxgb4/autogen.sh
 delete mode 100755 libcxgb4/config/config.guess
 delete mode 100755 libcxgb4/config/config.sub
 delete mode 100755 libcxgb4/config/depcomp
 delete mode 100755 libcxgb4/config/install-sh
 delete mode 100644 libcxgb4/configure.in
 delete mode 100644 libcxgb4/cxgb4.driver
 delete mode 100644 libcxgb4/libcxgb4.spec.in
 create mode 100644 libcxgb4/src/CMakeLists.txt
 delete mode 100644 libcxgb4/src/cxgb4.map
 delete mode 100644 libhfi1verbs/Makefile.am
 delete mode 100644 libhfi1verbs/README
 delete mode 100644 libhfi1verbs/add_fedora_entry.sh
 delete mode 100755 libhfi1verbs/autogen.sh
 delete mode 100644 libhfi1verbs/configure.in
 delete mode 100644 libhfi1verbs/fedora_changelog.txt
 delete mode 100644 libhfi1verbs/hfi1.driver
 delete mode 100644 libhfi1verbs/libhfi1.spec.in
 delete mode 100644 libhfi1verbs/makefile
 delete mode 100644 libhfi1verbs/makesrpm.sh
 create mode 100644 libhfi1verbs/src/CMakeLists.txt
 delete mode 100644 libhfi1verbs/src/hfiverbs.map
 delete mode 100644 libi40iw/Makefile.am
 delete mode 100644 libi40iw/configure.ac
 delete mode 100644 libi40iw/i40iw.driver
 delete mode 100644 libi40iw/libi40iw.spec.in
 create mode 100644 libi40iw/src/CMakeLists.txt
 delete mode 100644 libi40iw/src/i40iw.map
 delete mode 100644 libibcm/ChangeLog
 delete mode 100644 libibcm/INSTALL
 delete mode 100644 libibcm/Makefile.am
 delete mode 100644 libibcm/NEWS
 delete mode 100755 libibcm/autogen.sh
 delete mode 100644 libibcm/configure.in
 create mode 100644 libibcm/examples/CMakeLists.txt
 delete mode 100644 libibcm/libibcm.spec.in
 create mode 100644 libibcm/src/CMakeLists.txt
 mode change 100755 => 100644 libibcm/src/cm.c
 delete mode 100644 libibumad/ChangeLog
 delete mode 100644 libibumad/Makefile.am
 delete mode 100755 libibumad/autogen.sh
 delete mode 100644 libibumad/configure.in
 delete mode 100644 libibumad/libibumad.spec.in
 create mode 100644 libibumad/man/CMakeLists.txt
 create mode 100644 libibumad/src/CMakeLists.txt
 create mode 100644 libibumad/tests/CMakeLists.txt
 delete mode 100644 libibverbs/ChangeLog
 delete mode 100644 libibverbs/Makefile.am
 delete mode 100755 libibverbs/autogen.sh
 delete mode 100644 libibverbs/config/.gitignore
 delete mode 100644 libibverbs/configure.ac
 delete mode 100644 libibverbs/debian/changelog
 delete mode 100644 libibverbs/debian/compat
 delete mode 100644 libibverbs/debian/control
 delete mode 100644 libibverbs/debian/copyright
 delete mode 100644 libibverbs/debian/ibverbs-utils.install
 delete mode 100644 libibverbs/debian/libibverbs-dev.install
 delete mode 100644 libibverbs/debian/libibverbs-dev.links
 delete mode 100644 libibverbs/debian/libibverbs1.install
 delete mode 100644 libibverbs/debian/libibverbs1.postinst
 delete mode 100755 libibverbs/debian/rules
 delete mode 100644 libibverbs/debian/source/format
 delete mode 100644 libibverbs/debian/watch
 create mode 100644 libibverbs/examples/CMakeLists.txt
 delete mode 100644 libibverbs/libibverbs.spec.in
 create mode 100644 libibverbs/man/CMakeLists.txt
 create mode 100644 libibverbs/src/CMakeLists.txt
 create mode 100644 libipathverbs/CMakeLists.txt
 delete mode 100644 libipathverbs/Makefile.am
 delete mode 100644 libipathverbs/README
 delete mode 100755 libipathverbs/autogen.sh
 delete mode 100644 libipathverbs/configure.in
 delete mode 100644 libipathverbs/ipath.driver
 delete mode 100644 libipathverbs/libipathverbs.spec.in
 create mode 100644 libipathverbs/src/CMakeLists.txt
 delete mode 100644 libipathverbs/src/ipathverbs.map
 mode change 100644 => 100755 libipathverbs/truescale-serdes.cmds
 delete mode 100644 libmlx4/Makefile.am
 delete mode 100644 libmlx4/README
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
 create mode 100644 libmlx4/src/CMakeLists.txt
 delete mode 100644 libmlx4/src/mlx4.map
 delete mode 100644 libmlx5/Makefile.am
 delete mode 100644 libmlx5/README
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
 create mode 100644 libmlx5/src/CMakeLists.txt
 delete mode 100644 libmlx5/src/mlx5.map
 delete mode 100644 libmthca/ChangeLog
 delete mode 100644 libmthca/Makefile.am
 delete mode 100644 libmthca/README
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
 create mode 100644 libmthca/src/CMakeLists.txt
 delete mode 100644 libmthca/src/mthca.map
 delete mode 100644 libnes/Makefile.am
 delete mode 100755 libnes/autogen.sh
 delete mode 100644 libnes/config/.gitignore
 delete mode 100644 libnes/configure.in
 delete mode 100644 libnes/libnes.spec.in
 delete mode 100644 libnes/nes.driver
 create mode 100644 libnes/src/CMakeLists.txt
 delete mode 100644 libnes/src/nes.map
 delete mode 100644 libocrdma/Makefile.am
 delete mode 100644 libocrdma/README
 delete mode 100644 libocrdma/autogen.sh
 delete mode 100644 libocrdma/config/.gitignore
 delete mode 100644 libocrdma/configure.in
 delete mode 100644 libocrdma/libocrdma.spec.in
 delete mode 100644 libocrdma/ocrdma.driver
 create mode 100644 libocrdma/src/CMakeLists.txt
 delete mode 100644 libocrdma/src/ocrdma.map
 delete mode 100644 librdmacm/ChangeLog
 delete mode 100644 librdmacm/INSTALL
 delete mode 100644 librdmacm/Makefile.am
 delete mode 100644 librdmacm/NEWS
 delete mode 100755 librdmacm/autogen.sh
 delete mode 100644 librdmacm/configure.ac
 create mode 100644 librdmacm/examples/CMakeLists.txt
 delete mode 100644 librdmacm/librdmacm.spec.in
 create mode 100644 librdmacm/man/CMakeLists.txt
 create mode 100644 librdmacm/src/CMakeLists.txt
 create mode 100644 librdmacm/src/librspreload.map
 delete mode 100644 librxe/AUTHORS
 create mode 100644 librxe/CMakeLists.txt
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
 create mode 100644 librxe/man/CMakeLists.txt
 delete mode 100644 librxe/rxe.driver
 create mode 100644 librxe/src/CMakeLists.txt
 delete mode 100644 librxe/src/rxe.map
 delete mode 100644 srp_daemon/ChangeLog
 delete mode 100644 srp_daemon/Makefile.am
 delete mode 100644 srp_daemon/NEWS
 delete mode 100755 srp_daemon/autogen.sh
 delete mode 100755 srp_daemon/build-deb.sh
 delete mode 100644 srp_daemon/configure.ac
 delete mode 100644 srp_daemon/debian/changelog
 delete mode 100644 srp_daemon/debian/compat
 delete mode 100644 srp_daemon/debian/control
 delete mode 100644 srp_daemon/debian/postinst
 delete mode 100644 srp_daemon/debian/prerm
 delete mode 100755 srp_daemon/debian/rules
 delete mode 100644 srp_daemon/debian/source/format
 create mode 100644 srp_daemon/man/CMakeLists.txt
 create mode 100644 srp_daemon/srp_daemon/CMakeLists.txt
 delete mode 100644 srp_daemon/srptools.spec.in

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
