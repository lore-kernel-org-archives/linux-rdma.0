From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Support compiling on ARM32 and others
Date: Tue, 10 Jan 2017 12:02:07 -0700
Message-ID: <1484074931-3847-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is PR

https://github.com/linux-rdma/rdma-core/

The basic idea is to limit the use of arch.h to only places working with DMA,
detect when the arch does not support coherent DMA, and then disable compiling
those providers. non-DMA providers are ported to use C11 atomics and
can compile on all arches.

- Only use inifiniband/arch.h in provides that require coherent DMA
- Convert rxe/hfi1/ipath to use the C11 memory model to create portable barriers for this non-DMA use
- Update cmake to enable C11
- Update cmake to support stdatomic.h

Jason Gunthorpe (4):
  Minimize the places where infiniband/arch.h is included
  Detect if infiniband/arch.h is supported by the compiler
  Provide cmake support to enable C11 stdatomic.h
  Use C11 atomics instead of wmb/rmb macros for CPU-only atomics

 CMakeLists.txt                     |  23 ++-
 buildlib/RDMA_EnableCStd.cmake     |  11 +-
 buildlib/fixup-include/stdatomic.h | 369 +++++++++++++++++++++++++++++++++++++
 ibacm/linux/osd.h                  |   1 -
 ibacm/src/libacm.c                 |   6 +-
 libibumad/sysfs.c                  |   3 +-
 libibverbs/device.c                |   4 +-
 libibverbs/examples/device_list.c  |   3 +-
 libibverbs/examples/devinfo.c      |   3 +-
 librdmacm/addrinfo.c               |   6 +-
 librdmacm/cma.c                    |   6 +-
 librdmacm/cma.h                    |   1 -
 librdmacm/examples/rping.c         |   7 +-
 librdmacm/rsocket.c                |   8 +-
 providers/hfi1verbs/hfiverbs.h     |  10 +-
 providers/hfi1verbs/verbs.c        |  17 +-
 providers/ipathverbs/ipathverbs.h  |  10 +-
 providers/ipathverbs/verbs.c       |  18 +-
 providers/rxe/rxe.c                |   5 +-
 providers/rxe/rxe_queue.h          |  72 ++++----
 srp_daemon/srp_daemon.h            |   1 -
 21 files changed, 484 insertions(+), 100 deletions(-)
 create mode 100644 buildlib/fixup-include/stdatomic.h

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
