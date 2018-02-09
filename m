From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 0/7] Always use internal kernel headers
Date: Thu,  8 Feb 2018 20:08:57 -0700
Message-ID: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There have been some reports that the build fails on some systems, presumably
with weird kernel uapi headers installed.

Instead of trying to guess if the distro headers are good enough, just
unconditionally use our internal kernel headers, and provide a complete set of
headers from the latest kernel.

This also enhances check-build to detect wrong use of public headers and fixes
various bugs that are the result of check-build.

This is PR:

https://github.com/linux-rdma/rdma-core/pull/290

Jason Gunthorpe (7):
  verbs: Do not export kern-abi.h as a public header
  Enable GNU99 mode if the compiler does not support C11
  rxe: Remove duplicate include
  rxe: Do not use _sockaddr in struct rxe_av
  Support distros that have old kernel uapi headers
  Always user internal kernel headers when building
  Check that published headers do not rely on internal headers

 CMakeLists.txt                                     |  20 +-
 buildlib/RDMA_EnableCStd.cmake                     |   2 +
 buildlib/RDMA_LinuxHeaders.cmake                   |  98 -----
 buildlib/check-build                               |  86 ++++-
 buildlib/fixup-include/linux-in.h                  |   2 +
 buildlib/fixup-include/linux-in6.h                 |   2 +
 debian/libibverbs-dev.install                      |   1 -
 kernel-headers/CMakeLists.txt                      |  27 ++
 kernel-headers/rdma/bnxt_re-abi.h                  | 101 +++++
 kernel-headers/rdma/cxgb3-abi.h                    |  77 ++++
 kernel-headers/rdma/cxgb4-abi.h                    |  82 ++++
 kernel-headers/rdma/hfi/hfi1_ioctl.h               | 174 +++++++++
 kernel-headers/rdma/hfi/hfi1_user.h                | 267 +++++++++++++
 kernel-headers/rdma/hns-abi.h                      |  55 +++
 kernel-headers/rdma/ib_user_cm.h                   | 326 ++++++++++++++++
 kernel-headers/rdma/ib_user_ioctl_verbs.h          |  84 +++++
 kernel-headers/rdma/ib_user_mad.h                  | 234 ++++++++++++
 kernel-headers/rdma/ib_user_sa.h                   |  77 ++++
 .../rdma/ib_user_verbs.h                           |   7 +-
 kernel-headers/rdma/mlx4-abi.h                     | 159 ++++++++
 kernel-headers/rdma/mlx5-abi.h                     | 416 +++++++++++++++++++++
 kernel-headers/rdma/mthca-abi.h                    | 112 ++++++
 kernel-headers/rdma/nes-abi.h                      | 115 ++++++
 kernel-headers/rdma/ocrdma-abi.h                   | 152 ++++++++
 kernel-headers/rdma/qedr-abi.h                     | 110 ++++++
 .../rdma/rdma_netlink.h                            | 134 ++++++-
 kernel-headers/rdma/rdma_user_cm.h                 | 311 +++++++++++++++
 kernel-headers/rdma/rdma_user_ioctl.h              | 121 ++++++
 .../rdma/rdma_user_rxe.h                           |   5 +-
 .../rdma/vmw_pvrdma-abi.h                          |   0
 libibverbs/CMakeLists.txt                          |   2 +-
 librdmacm/rdma_cma_abi.h                           |   2 +-
 providers/rxe/rxe.c                                |  21 +-
 33 files changed, 3245 insertions(+), 137 deletions(-)
 delete mode 100644 buildlib/RDMA_LinuxHeaders.cmake
 create mode 100644 buildlib/fixup-include/linux-in.h
 create mode 100644 buildlib/fixup-include/linux-in6.h
 create mode 100644 kernel-headers/CMakeLists.txt
 create mode 100644 kernel-headers/rdma/bnxt_re-abi.h
 create mode 100644 kernel-headers/rdma/cxgb3-abi.h
 create mode 100644 kernel-headers/rdma/cxgb4-abi.h
 create mode 100644 kernel-headers/rdma/hfi/hfi1_ioctl.h
 create mode 100644 kernel-headers/rdma/hfi/hfi1_user.h
 create mode 100644 kernel-headers/rdma/hns-abi.h
 create mode 100644 kernel-headers/rdma/ib_user_cm.h
 create mode 100644 kernel-headers/rdma/ib_user_ioctl_verbs.h
 create mode 100644 kernel-headers/rdma/ib_user_mad.h
 create mode 100644 kernel-headers/rdma/ib_user_sa.h
 rename buildlib/fixup-include/rdma-ib_user_verbs.h => kernel-headers/rdma/ib_user_verbs.h (99%)
 create mode 100644 kernel-headers/rdma/mlx4-abi.h
 create mode 100644 kernel-headers/rdma/mlx5-abi.h
 create mode 100644 kernel-headers/rdma/mthca-abi.h
 create mode 100644 kernel-headers/rdma/nes-abi.h
 create mode 100644 kernel-headers/rdma/ocrdma-abi.h
 create mode 100644 kernel-headers/rdma/qedr-abi.h
 rename buildlib/fixup-include/rdma-rdma_netlink.h => kernel-headers/rdma/rdma_netlink.h (59%)
 create mode 100644 kernel-headers/rdma/rdma_user_cm.h
 create mode 100644 kernel-headers/rdma/rdma_user_ioctl.h
 rename buildlib/fixup-include/rdma-rdma_user_rxe.h => kernel-headers/rdma/rdma_user_rxe.h (95%)
 rename buildlib/fixup-include/rdma-vmw_pvrdma-abi.h => kernel-headers/rdma/vmw_pvrdma-abi.h (100%)

-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
