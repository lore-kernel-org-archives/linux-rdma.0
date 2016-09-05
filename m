From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 00/28] Patches for userspace
Date: Mon,  5 Sep 2016 15:07:50 -0600
Message-ID: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Everyone,

I have audited rdma-plumbing for correct compilation, compiler compatability
and warnings. This has resulted in a number of patches to basically
everything, I am presenting them here seperately from rdma-plumbing to get
them picked up and reviewed.

If you missed my earlier emails, read about rdma-plumbing here:
  http://www.spinics.net/lists/linux-rdma/msg39026.html
  http://www.spinics.net/lists/linux-rdma/msg39328.html
  https://github.com/jgunthorpe/rdma-plumbing

If you are maintaining one of the 17 packages being absorbed into
rdma-plumbing please do one of the following:

1) Take your patches into your git tree and send me a note. These patches
   will need to be applied with patch -p2, and sometimes a bit more
   fussing as they are against the initial merge in rdma-plubming.
   It is much too much work for me to create patches against each of
   the 17 repos individually.
2) Send a Acked-by/Reviewed-by and the patch will be carried in
   rdma-plumbing.
3) Do nothing. I will mark you as retired in the rdma-plumbing
   MAINTAINERS file.

Within rdma-plumbing, the net result of all these patches (and more) is clean
compilation on gcc 6.1/clang 3.8 with a high warning level (-Wall -Wextra
-Wno-sign-compare -Wno-unused-parameter), which is highly desired.

Jason Gunthorpe (28):
  Fix bogus executable file permissions
  Include pthreads in the provider libraries
  Be explicit about _GNU_SOURCE
  cxgb3/4: Display correct version number in error message
  hfi/ipath: Use the name of the provider for the .driver file
  i40iw: Avoid gcc warning -Wint-to-pointer-cast
  iwpm: Add AM_INIT_AUTOMAKE([subdir-objects])
  ibcm: Actually use the version script when linking
  mlx5: Fix gcc 6.4 uninitialized variable warning
  nes: Fix clang 3.6 warning
    -Wtautological-constant-out-of-range-compare
  ocrdma: Fix incorrect type of ibwc_status
  ocrdma: Fix incorrect enum constant
  rdmacm: Use correct format specifier for size_t
  rdmacm: Control symbol export from librspreload
  umad: Include umad.h in the canonical way
  umad: Fix incorrect arguments to umad_register2 in tests
  verbs: Fix incorrect type of len
  verbs: Fix clang 3.6 warning -Wtautological-compare
  verbs: Avoid gcc 6.1 warning -Wunused-variable
  verbs: Use inttypes.h format string macros
  mlx5: Avoid gcc 5.4 warning -Wempty-body
  nes: Avoid gcc 6.1 warning -Wmisleading-indentation
  rxe: Avoid gcc 5.4 warning -Wswitch
  Fix gcc 5.4, clang 3.6 warnings about unused objects
  Avoid gcc 5.4 warning -Wtype-limits
  Avoid gcc 5.4 warning -Wunused-result
  Avoid clang 3.6 warning -Wmissing-field-initializers
  Avoid gcc warning -Wpointer-to-int-cast

 iwpm/Makefile.am                                  |  2 +-
 iwpm/configure.ac                                 |  2 +-
 iwpm/src/iwarp_pm_helper.c                        |  2 +-
 libcxgb3/Makefile.am                              |  2 +-
 libcxgb3/configure.in                             |  2 +
 libcxgb3/src/iwch.c                               |  4 +-
 libcxgb3/src/qp.c                                 | 41 ----------------
 libcxgb4/Makefile.am                              |  2 +-
 libcxgb4/configure.in                             |  2 +
 libcxgb4/src/dev.c                                |  6 +--
 libhfi1verbs/Makefile.am                          |  6 +--
 libhfi1verbs/configure.in                         |  2 +
 libhfi1verbs/{hfi1.driver => hfi1verbs.driver}    |  0
 libhfi1verbs/src/verbs.c                          |  2 +-
 libi40iw/Makefile.am                              |  2 +-
 libi40iw/configure.ac                             |  2 +
 libi40iw/src/i40iw_uverbs.c                       |  6 +--
 libibcm/Makefile.am                               |  6 +--
 libibcm/src/cm.c                                  |  2 +-
 libibumad/src/sysfs.c                             |  3 --
 libibumad/src/umad.c                              |  2 +-
 libibumad/tests/umad_reg2_compat.c                |  5 +-
 libibumad/tests/umad_register2.c                  |  8 +--
 libibverbs/configure.ac                           |  1 -
 libibverbs/examples/asyncwatch.c                  |  4 +-
 libibverbs/examples/devinfo.c                     |  4 +-
 libibverbs/examples/pingpong.c                    |  2 +-
 libibverbs/examples/rc_pingpong.c                 | 21 ++++----
 libibverbs/examples/srq_pingpong.c                | 19 ++++---
 libibverbs/examples/uc_pingpong.c                 | 21 ++++----
 libibverbs/examples/ud_pingpong.c                 | 23 ++++-----
 libibverbs/examples/xsrq_pingpong.c               |  6 +--
 libibverbs/src/device.c                           |  2 +-
 libibverbs/src/init.c                             |  2 +-
 libibverbs/src/neigh.c                            | 21 ++++----
 libibverbs/src/sysfs.c                            |  2 +-
 libipathverbs/Makefile.am                         |  6 +--
 libipathverbs/configure.in                        |  2 +
 libipathverbs/{ipath.driver => ipathverbs.driver} |  0
 libipathverbs/src/verbs.c                         |  2 +-
 libipathverbs/truescale-serdes.cmds               |  0
 libmlx4/Makefile.am                               |  2 +-
 libmlx4/configure.ac                              |  2 +
 libmlx4/src/dbrec.c                               |  2 +-
 libmlx5/Makefile.am                               |  2 +-
 libmlx5/configure.ac                              |  3 ++
 libmlx5/src/cq.c                                  |  3 ++
 libmlx5/src/dbrec.c                               |  3 +-
 libmlx5/src/mlx5.c                                |  3 +-
 libmlx5/src/mlx5.h                                |  6 ++-
 libmlx5/src/qp.c                                  |  7 ---
 libmlx5/src/verbs.c                               | 14 +-----
 libmthca/Makefile.am                              |  2 +-
 libmthca/configure.in                             |  2 +
 libmthca/src/memfree.c                            |  2 +-
 libnes/Makefile.am                                |  2 +-
 libnes/configure.in                               |  2 +
 libnes/src/nes_uverbs.c                           | 29 ++++++-----
 libocrdma/Makefile.am                             |  2 +-
 libocrdma/configure.in                            |  2 +
 libocrdma/src/ocrdma_verbs.c                      |  7 +--
 librdmacm/Makefile.am                             |  7 ++-
 librdmacm/examples/cmtime.c                       | 16 ------
 librdmacm/examples/rping.c                        |  4 +-
 librdmacm/examples/udpong.c                       |  2 +-
 librdmacm/src/acm.c                               |  3 +-
 librdmacm/src/librspreload.map                    | 33 +++++++++++++
 librdmacm/src/preload.c                           |  6 +--
 librdmacm/src/rsocket.c                           | 60 ++++++++++++++++-------
 librxe/Makefile.am                                |  2 +-
 librxe/configure.in                               |  2 +
 librxe/src/rxe.c                                  |  6 +++
 72 files changed, 256 insertions(+), 231 deletions(-)
 rename libhfi1verbs/{hfi1.driver => hfi1verbs.driver} (100%)
 mode change 100755 => 100644 libibcm/src/cm.c
 rename libipathverbs/{ipath.driver => ipathverbs.driver} (100%)
 mode change 100644 => 100755 libipathverbs/truescale-serdes.cmds
 create mode 100644 librdmacm/src/librspreload.map

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
