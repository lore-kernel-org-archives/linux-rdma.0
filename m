From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/9] Dead Code Removal
Date: Thu, 29 Sep 2016 14:47:47 -0600
Message-ID: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This removes various #ifdef type stuff that no longer makes any sense.
cmake is arranged in a way that avoids alot of the ifdefs around header files.

The BYTE_ORDER patch is more substantial and consolidates everything around
glibc's endian.h

See

https://github.com/linux-rdma/rdma-core/pull/10

Jason Gunthorpe (9):
  Remove HAVE_CONFIG_H
  Remove HAVE_VALGRIND_MEMCHECK_H/INCLUDE_VALGRIND
  Remove HAVE_IBV_*
  Do not use IBV_CMD_(REG_MR|RESIZE_CQ)_HAS_RESP_PARAMS
  Remove HAVE_SYMVER_SUPPORT
  Remove old compat definitions of wmb/rmb/etc
  Remove old MADV_DONTFORK/DOFORK compat
  Remove most checks of __BYTE_ORDER
  nes: Remove code guarded by HAVE_DECL_IBV_QPT_RAW_ETH

 CMakeLists.txt                       |   2 -
 buildlib/config.h.in                 |  13 --
 ibacm/linux/osd.h                    |   8 +-
 ibacm/prov/acmp/src/acmp.c           |   4 +-
 ibacm/src/acm.c                      |   4 +-
 ibacm/src/acme.c                     |   4 +-
 ibacm/src/libacm.c                   |   4 +-
 libcxgb3/src/cq.c                    |   4 +-
 libcxgb3/src/cxio_wr.h               |  10 +-
 libcxgb3/src/iwch.c                  |   4 +-
 libcxgb3/src/qp.c                    |   4 +-
 libcxgb3/src/verbs.c                 |   4 +-
 libcxgb4/src/cq.c                    |   4 +-
 libcxgb4/src/dev.c                   |   4 +-
 libcxgb4/src/qp.c                    |   4 +-
 libcxgb4/src/t4.h                    |  11 +-
 libcxgb4/src/verbs.c                 |   4 +-
 libhfi1verbs/src/hfiverbs.c          |  22 +--
 libhfi1verbs/src/verbs.c             |  19 +-
 libi40iw/src/i40iw_umain.c           |   2 -
 libi40iw/src/i40iw_umain.h           |  18 +-
 libi40iw/src/i40iw_uverbs.c          |  28 ---
 libibcm/src/cm.c                     |  15 +-
 libibumad/src/sysfs.c                |  12 +-
 libibumad/src/umad.c                 |  18 +-
 libibumad/tests/umad_reg2_compat.c   |   4 +-
 libibumad/tests/umad_register2.c     |   4 +-
 libibverbs/examples/asyncwatch.c     |   4 +-
 libibverbs/examples/device_list.c    |   4 +-
 libibverbs/examples/devinfo.c        |   4 +-
 libibverbs/examples/rc_pingpong.c    |   4 +-
 libibverbs/examples/srq_pingpong.c   |   4 +-
 libibverbs/examples/uc_pingpong.c    |   4 +-
 libibverbs/examples/ud_pingpong.c    |   4 +-
 libibverbs/examples/xsrq_pingpong.c  |   4 +-
 libibverbs/include/infiniband/arch.h |  15 +-
 libibverbs/src/cmd.c                 |   4 +-
 libibverbs/src/compat-1_0.c          |   4 +-
 libibverbs/src/device.c              |   4 +-
 libibverbs/src/ibverbs.h             |  25 +--
 libibverbs/src/init.c                |   4 +-
 libibverbs/src/marshall.c            |   4 +-
 libibverbs/src/memory.c              |  15 +-
 libibverbs/src/sysfs.c               |   4 +-
 libibverbs/src/verbs.c               |   4 +-
 libipathverbs/src/ipathverbs.c       |  22 +--
 libipathverbs/src/verbs.c            |  20 +-
 libmlx4/src/buf.c                    |   4 +-
 libmlx4/src/cq.c                     |   4 +-
 libmlx4/src/dbrec.c                  |   4 +-
 libmlx4/src/mlx4.c                   |   4 +-
 libmlx4/src/mlx4.h                   |  42 +---
 libmlx4/src/qp.c                     |   4 +-
 libmlx4/src/srq.c                    |   4 +-
 libmlx4/src/verbs.c                  |   4 +-
 libmlx5/src/buf.c                    |  23 +--
 libmlx5/src/cq.c                     |   5 +-
 libmlx5/src/dbrec.c                  |   4 +-
 libmlx5/src/mlx5.c                   |   8 +-
 libmlx5/src/mlx5.h                   |  40 +---
 libmlx5/src/qp.c                     |   5 +-
 libmlx5/src/srq.c                    |   4 +-
 libmlx5/src/verbs.c                  |  24 +--
 libmthca/src/ah.c                    |   4 +-
 libmthca/src/buf.c                   |  23 +--
 libmthca/src/cq.c                    |   4 +-
 libmthca/src/memfree.c               |   4 +-
 libmthca/src/mthca.c                 |  62 +-----
 libmthca/src/mthca.h                 |  26 +--
 libmthca/src/qp.c                    |   4 +-
 libmthca/src/srq.c                   |   4 +-
 libmthca/src/verbs.c                 |  30 +--
 libnes/src/nes_umain.c               |   2 -
 libnes/src/nes_umain.h               |  17 +-
 libnes/src/nes_uverbs.c              | 359 -----------------------------------
 libocrdma/src/ocrdma_main.c          |   2 -
 libocrdma/src/ocrdma_verbs.c         |  34 +---
 librdmacm/examples/common.h          |  11 +-
 librdmacm/src/acm.c                  |   4 +-
 librdmacm/src/addrinfo.c             |   4 +-
 librdmacm/src/cma.c                  |   4 +-
 librdmacm/src/cma.h                  |  24 +--
 librdmacm/src/indexer.c              |   4 +-
 librdmacm/src/indexer.h              |   4 +-
 librdmacm/src/preload.c              |   4 +-
 librdmacm/src/rsocket.c              |   4 +-
 librxe/src/rxe.c                     |  34 +---
 srp_daemon/srp_daemon/srp_daemon.h   |  22 +--
 88 files changed, 124 insertions(+), 1144 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
