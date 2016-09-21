From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 00/23] rdma-core Trivial fixes and documentation updates
Date: Wed, 21 Sep 2016 16:08:26 -0600
Message-ID: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is the next batch of fixes, the 23 patches are all straight forward and
should be uncontroversial. Most are documentation updates, plus a few
obviously correct fixes from static checkers.

Please forward Acks and I will apply this to the github soonish.

The tree is here:
 https://github.com/linux-rdma/rdma-core

View the patches on github:
 https://github.com/linux-rdma/rdma-core/pull/2

Christoph Hellwig (6):
  Add reporting bugs and submitting patches sections to README.md
  verbs: Move documentation to Documentation/
  rdmacm: Move documentation to Documentation/
  ibcm: Move documentation to Documentation/
  rxe: Move documentation to Documentation/
  srp_daemon: Move documentation to Documentation/

Jason Gunthorpe (16):
  Consolidate the .gitignore files
  Move the AUTHORS files into MAINTAINERS
  mlx5: Add cmake options to replace --with-mlx5_debug/mw_debug
  ipathverbs: Recognize bashisms in truescale-serdes.cmds
  nes: Fix clang 3.6 warning
    -Wtautological-constant-out-of-range-compare
  ocrdma: Fix incorrect type of ibwc_status
  ocrdma: Fix incorrect enum constant
  verbs: Fix incorrect type of len
  verbs: Use inttypes.h format string macros
  rdmacm: Use correct format specifier for size_t
  rdmacm: Fix leading \'s in rcopy man page
  rdmacm: Fix typos
  umad: Replace .nl with .sp in man pages
  iwpmd: Install ancillary files for iwpm
  iwpmd: Remove syslog.target from service file
  srp_daemon: Use SRP_DEFAULT_START/STOP for substitution

Steve Wise (1):
  iwpmd: Add man pages

 .gitignore                                     |  71 +++++++++++
 CMakeLists.txt                                 |   1 +
 Documentation/ibsrpdm.md                       |  41 +++++++
 libibcm/README => Documentation/libibcm.md     |  14 +--
 Documentation/libibverbs.md                    |  58 +++++++++
 librdmacm/README => Documentation/librdmacm.md |  27 +---
 Documentation/rxe.md                           |  22 ++++
 MAINTAINERS                                    |  13 ++
 README.md                                      |  28 +++++
 ibacm/AUTHORS                                  |   1 -
 iwpmd/AUTHORS                                  |   2 -
 iwpmd/CMakeLists.txt                           |   4 +
 iwpmd/iwpmd.1                                  |  56 +++++++++
 iwpmd/iwpmd.conf.5                             |  20 +++
 iwpmd/iwpmd.service                            |   2 +-
 iwpmd/src/CMakeLists.txt                       |  10 +-
 libcxgb3/AUTHORS                               |   1 -
 libcxgb4/AUTHORS                               |   1 -
 libhfi1verbs/.gitignore                        |  18 ---
 libhfi1verbs/AUTHORS                           |   1 -
 libi40iw/AUTHORS                               |   1 -
 libibcm/AUTHORS                                |   2 -
 libibumad/AUTHORS                              |   3 -
 libibumad/man/umad_get_ca.3                    |   2 +-
 libibumad/man/umad_get_port.3                  |   2 +-
 libibumad/man/umad_init.3                      |   2 +-
 libibverbs/.gitignore                          |  24 ----
 libibverbs/AUTHORS                             |   4 -
 libibverbs/README                              | 164 -------------------------
 libibverbs/examples/.gitignore                 |  10 --
 libibverbs/examples/devinfo.c                  |   4 +-
 libibverbs/src/.gitignore                      |   3 -
 libipathverbs/.gitignore                       |  22 ----
 libipathverbs/AUTHORS                          |   1 -
 libipathverbs/truescale-serdes.cmds            |   2 +-
 libmlx4/.gitignore                             |  17 ---
 libmlx4/AUTHORS                                |   2 -
 libmlx4/src/.gitignore                         |   3 -
 libmlx5/.gitignore                             |  33 -----
 libmlx5/AUTHORS                                |   2 -
 libmlx5/src/.gitignore                         |   3 -
 libmlx5/src/CMakeLists.txt                     |  12 ++
 libmthca/.gitignore                            |  17 ---
 libmthca/AUTHORS                               |   2 -
 libmthca/src/.gitignore                        |   3 -
 libnes/AUTHORS                                 |   1 -
 libnes/src/nes_uverbs.c                        |   8 +-
 libocrdma/AUTHORS                              |   1 -
 libocrdma/src/ocrdma_verbs.c                   |   4 +-
 librdmacm/.gitignore                           |  64 ----------
 librdmacm/AUTHORS                              |   1 -
 librdmacm/examples/.gitignore                  |  23 ----
 librdmacm/examples/rping.c                     |   2 +-
 librdmacm/examples/udpong.c                    |   2 +-
 librdmacm/include/rdma/rdma_cma.h              |   2 +-
 librdmacm/man/mckey.1                          |   2 +-
 librdmacm/man/rcopy.1                          |   6 +-
 librdmacm/man/rdma_cm.7                        |   4 +-
 librdmacm/man/rdma_migrate_id.3                |   2 +-
 librdmacm/man/rdma_post_write.3                |   2 +-
 librdmacm/man/rdma_post_writev.3               |   2 +-
 librdmacm/man/rdma_reg_msgs.3                  |   2 +-
 librdmacm/man/rdma_set_option.3                |   2 +-
 librdmacm/src/.gitignore                       |   9 --
 librxe/README.md                               |  63 ----------
 srp_daemon/.gitignore                          |  18 ---
 srp_daemon/README                              |  82 -------------
 srp_daemon/srp_daemon/CMakeLists.txt           |   4 +-
 srp_daemon/srp_daemon/srpd.in                  |   4 +-
 69 files changed, 372 insertions(+), 669 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 Documentation/ibsrpdm.md
 rename libibcm/README => Documentation/libibcm.md (54%)
 create mode 100644 Documentation/libibverbs.md
 rename librdmacm/README => Documentation/librdmacm.md (65%)
 create mode 100644 Documentation/rxe.md
 delete mode 100644 ibacm/AUTHORS
 delete mode 100644 iwpmd/AUTHORS
 create mode 100644 iwpmd/CMakeLists.txt
 create mode 100644 iwpmd/iwpmd.1
 create mode 100644 iwpmd/iwpmd.conf.5
 delete mode 100644 libcxgb3/AUTHORS
 delete mode 100644 libcxgb4/AUTHORS
 delete mode 100644 libhfi1verbs/.gitignore
 delete mode 100644 libhfi1verbs/AUTHORS
 delete mode 100644 libi40iw/AUTHORS
 delete mode 100644 libibcm/AUTHORS
 delete mode 100644 libibumad/AUTHORS
 delete mode 100644 libibverbs/.gitignore
 delete mode 100644 libibverbs/AUTHORS
 delete mode 100644 libibverbs/README
 delete mode 100644 libibverbs/examples/.gitignore
 delete mode 100644 libibverbs/src/.gitignore
 delete mode 100644 libipathverbs/.gitignore
 delete mode 100644 libipathverbs/AUTHORS
 delete mode 100644 libmlx4/.gitignore
 delete mode 100644 libmlx4/AUTHORS
 delete mode 100644 libmlx4/src/.gitignore
 delete mode 100644 libmlx5/.gitignore
 delete mode 100644 libmlx5/AUTHORS
 delete mode 100644 libmlx5/src/.gitignore
 delete mode 100644 libmthca/.gitignore
 delete mode 100644 libmthca/AUTHORS
 delete mode 100644 libmthca/src/.gitignore
 delete mode 100644 libnes/AUTHORS
 delete mode 100644 libocrdma/AUTHORS
 delete mode 100644 librdmacm/.gitignore
 delete mode 100644 librdmacm/AUTHORS
 delete mode 100644 librdmacm/examples/.gitignore
 delete mode 100644 librdmacm/src/.gitignore
 delete mode 100644 librxe/README.md
 delete mode 100644 srp_daemon/.gitignore
 delete mode 100644 srp_daemon/README

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
