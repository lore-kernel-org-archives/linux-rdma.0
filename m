From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 00/13] Policy changes and packaging support
Date: Fri, 23 Sep 2016 13:16:55 -0600
Message-ID: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Jolly <jjolly-IBi9RG/b67k@public.gmane.org>, Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is the next batch of rdma-core updates, these 13 patches deal primarily
with how the package is built and the install paths afterwards. Most likely
these changes are mainly of interest to packagers.

The discussion here is informative for some of the patches:
 http://www.spinics.net/lists/linux-rdma/msg39578.html

View the commits on github:

 https://github.com/linux-rdma/rdma-core/pull/3

Please forward Acks and I will update the commits.

One important thing to note is that this series pretty much eliminates all
hard coded paths from the tree. While this is a good thing, it means the
default behavior is to set SYSCONFDIR to /usr/local/etc/, which is probably
not what people testing the daemons really want. Compile with:

 cmake -GNinja .. -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc

Which is similar to the configure --sysconfdir option

Jason Gunthorpe (13):
  Be consistent about defining NDEBUG
  Switch valgrind memcheck.h to on by default
  Do not produce libtool .la files
  Do not produce static libraries by default
  Have cmake run man pages through text substitution
  Consolidate definitions for paths into config.h
  Pass ancillary files that use paths through cmake substitution
  srp_daemon: Move lock file into /var/run/
  verbs: Move the providers into /usr/lib.../libibverbs by default
  ipathverbs: Move truescale-serdes.cmds to /usr/libexec/
  srp_daemon: Add the debian initscripts as an option
  Document a versioning strategy and use it
  Remove ibsupport-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org from MAINTAINERS

 CMakeLists.txt                                     |  47 +++++-
 Documentation/versioning.md                        | 108 ++++++++++++++
 MAINTAINERS                                        |   1 -
 buildlib/RDMA_BuildType.cmake                      |  41 ++++++
 buildlib/config.h.in                               |  16 +-
 buildlib/rdma_functions.cmake                      | 162 ++++++---------------
 ibacm/CMakeLists.txt                               |   7 +-
 ibacm/ibacm.init.in                                |   2 +-
 ibacm/linux/osd.h                                  |   2 +-
 ibacm/man/{ibacm_prov.7 => ibacm_prov.7.in}        |   4 +-
 ibacm/src/acm.c                                    |   6 +-
 ibacm/src/acme.c                                   |  10 +-
 ibacm/src/libacm.c                                 |   2 +-
 iwpmd/CMakeLists.txt                               |   4 +-
 iwpmd/{iwpmd.1 => iwpmd.1.in}                      |   2 +-
 iwpmd/{iwpmd.conf.5 => iwpmd.conf.5.in}            |   2 +-
 iwpmd/src/iwarp_pm.h                               |   1 -
 iwpmd/src/iwarp_pm_server.c                        |   1 +
 libibcm/src/CMakeLists.txt                         |   4 +-
 libibcm/src/libibcm.map                            |   1 +
 libibumad/src/CMakeLists.txt                       |   4 +-
 libibumad/src/libibumad.map                        |   1 +
 libibverbs/src/CMakeLists.txt                      |   4 +-
 libibverbs/src/init.c                              |  55 +++++--
 libibverbs/src/libibverbs.map                      |   1 +
 libipathverbs/CMakeLists.txt                       |   6 +-
 libipathverbs/dracut_install                       |   2 +-
 libipathverbs/truescale.conf                       |   1 -
 libipathverbs/truescale.conf.in                    |   1 +
 librdmacm/man/CMakeLists.txt                       |   2 +-
 librdmacm/man/{rsocket.7 => rsocket.7.in}          |   4 +-
 librdmacm/src/CMakeLists.txt                       |   4 +-
 librdmacm/src/acm.c                                |   2 +-
 librdmacm/src/cma.h                                |   9 --
 librdmacm/src/librdmacm.map                        |   1 +
 srp_daemon/man/CMakeLists.txt                      |   2 +-
 srp_daemon/man/{srp_daemon.1 => srp_daemon.1.in}   |   8 +-
 srp_daemon/srp_daemon/CMakeLists.txt               |  33 +++--
 srp_daemon/srp_daemon/srp_daemon.c                 |   6 +-
 .../srp_daemon/{srp_daemon.sh => srp_daemon.sh.in} |   4 +-
 srp_daemon/srp_daemon/srpd.in                      |   6 +-
 srp_daemon/srptools.default                        |  14 ++
 srp_daemon/srptools.init                           |  89 +++++++++++
 43 files changed, 468 insertions(+), 214 deletions(-)
 create mode 100644 Documentation/versioning.md
 create mode 100644 buildlib/RDMA_BuildType.cmake
 rename ibacm/man/{ibacm_prov.7 => ibacm_prov.7.in} (95%)
 rename iwpmd/{iwpmd.1 => iwpmd.1.in} (98%)
 rename iwpmd/{iwpmd.conf.5 => iwpmd.conf.5.in} (92%)
 delete mode 100644 libipathverbs/truescale.conf
 create mode 100644 libipathverbs/truescale.conf.in
 rename librdmacm/man/{rsocket.7 => rsocket.7.in} (97%)
 rename srp_daemon/man/{srp_daemon.1 => srp_daemon.1.in} (90%)
 rename srp_daemon/srp_daemon/{srp_daemon.sh => srp_daemon.sh.in} (95%)
 create mode 100644 srp_daemon/srptools.default
 create mode 100644 srp_daemon/srptools.init

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
