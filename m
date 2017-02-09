From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 00/10] Provide a compat infiniband/arch.h
Date: Thu,  9 Feb 2017 14:53:22 -0700
Message-ID: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Prior commits made arch.h into a private header, but there are several places
out there that include it to get htonll. Provide a dummy compat header that
will let such places continue to compile, but with warnings.

To do this we need to move the internal tree to use util/udma_barrier.h for
the barrier macros to free up the header file name and in the process replace
more of the crazy mix of byteswapping macros with endian.h equivalents.

To make sure that everything remains working travis also learns to
compile-test all the header files.

Jason Gunthorpe (10):
  Have check-build confirm that every public header is standalone
  Remove uses of htonll
  Remove uses of ntohll
  Do not use kernel byteswap macros
  Remove extraneous byteswap.h include
  mlx4: Remove include of asm/unistd.h
  rdmacm: Remove dangling cpu_to_be64 definitions
  umad: Replace htonll macros with proper inlines and mark deprecated
  Move the now private infiniband/arch.h to util/udma_barrier.h
  verbs: Add a compatibility arch.h

 CMakeLists.txt                    |   2 +-
 buildlib/check-build              |  55 ++++++++++++++++-
 buildlib/travis-build             |   2 +-
 ibacm/include/acm_mad.h           |  84 ++++++++++++-------------
 ibacm/linux/osd.h                 |   1 -
 ibacm/prov/acmp/src/acmp.c        |  12 ++--
 ibacm/src/acm.c                   |   6 +-
 iwpmd/iwarp_pm_common.c           |   5 +-
 libibcm/cm.h                      |   6 +-
 libibcm/examples/cmpost.c         |   7 +--
 libibumad/sysfs.c                 |   1 -
 libibumad/umad.h                  |  16 +++--
 libibverbs/CMakeLists.txt         |   2 +-
 libibverbs/arch.h                 | 101 +++---------------------------
 libibverbs/examples/asyncwatch.c  |   1 -
 libibverbs/examples/device_list.c |   1 -
 libibverbs/examples/devinfo.c     |   1 -
 librdmacm/cma.c                   |   1 -
 librdmacm/cma.h                   |   1 -
 librdmacm/examples/cmatose.c      |   1 -
 librdmacm/examples/common.c       |   1 -
 librdmacm/examples/common.h       |   3 -
 librdmacm/examples/mckey.c        |   1 -
 librdmacm/examples/rping.c        |   1 -
 librdmacm/examples/udaddy.c       |   1 -
 librdmacm/ib.h                    |   1 +
 librdmacm/rdma_cma_abi.h          |   1 +
 librdmacm/rsocket.c               |   1 +
 providers/cxgb3/cxio_wr.h         |   2 +-
 providers/cxgb3/iwch.h            |   2 +-
 providers/cxgb3/qp.c              |  12 ++--
 providers/cxgb4/dev.c             |   4 +-
 providers/cxgb4/libcxgb4.h        |   2 +-
 providers/cxgb4/t4.h              |   4 +-
 providers/hfi1verbs/hfiverbs.h    |   1 -
 providers/hns/hns_roce_u.h        |   2 +-
 providers/i40iw/i40iw_osdep.h     |   2 +-
 providers/i40iw/i40iw_uk.c        |   2 +
 providers/i40iw/i40iw_umain.h     |   2 +-
 providers/ipathverbs/ipathverbs.h |   1 -
 providers/mlx4/mlx4.h             |   2 +-
 providers/mlx4/mmio.h             |   1 -
 providers/mlx4/qp.c               |  12 ++--
 providers/mlx4/srq.c              |   2 +-
 providers/mlx5/cq.c               |   2 +-
 providers/mlx5/mlx5.h             |   2 +-
 providers/mlx5/qp.c               |  28 ++++-----
 providers/mlx5/srq.c              |   4 +-
 providers/mthca/mthca.h           |   2 +-
 providers/mthca/qp.c              |  34 +++++------
 providers/mthca/srq.c             |   4 +-
 providers/nes/nes_umain.h         |   2 +-
 providers/ocrdma/ocrdma_main.h    |   2 +-
 providers/qedr/qelr.h             |   2 +-
 providers/qedr/qelr_main.h        |   2 +-
 providers/qedr/qelr_verbs.c       |   2 +-
 providers/qedr/qelr_verbs.h       |   2 +-
 providers/rxe/rxe.c               |   1 -
 providers/vmw_pvrdma/cq.c         |   2 +-
 providers/vmw_pvrdma/qp.c         |   2 +-
 srp_daemon/srp_daemon.c           |  43 +++++++------
 srp_daemon/srp_daemon.h           |   1 -
 srp_daemon/srp_handle_traps.c     |   5 +-
 util/CMakeLists.txt               |   1 +
 util/udma_barrier.h               | 125 ++++++++++++++++++++++++++++++++++++++
 65 files changed, 356 insertions(+), 281 deletions(-)
 create mode 100644 util/udma_barrier.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
