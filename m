From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Migrate to use kernel uAPI headers
Date: Thu, 27 Oct 2016 17:06:06 -0600
Message-ID: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a start on this process, verbs will be quite challenging.

https://github.com/linux-rdma/rdma-core/pull/29

Jason Gunthorpe (4):
  Support -DKERNEL_DIR to use kernel UAPI headers directly
  Move rdma_netlink compat into CMake
  verbs: Replace infiniband/sa-kern-abi.h with the kernel's
    uapi/rdma/ib_user_sa.h
  ibcm: Replace infiniband/cm_abi.h with the kernel's
    uapi/rdma/ib_user_cm.h

 CMakeLists.txt                             |  11 +-
 buildlib/RDMA_LinuxHeaders.cmake           |  85 +++++++
 buildlib/fixup-include/rdma-rdma_netlink.h | 225 ++++++++++++++++++
 ibacm/src/acm.c                            |   3 -
 ibacm/src/acm_netlink.h                    | 128 -----------
 iwpmd/iwarp_pm.h                           |   2 +-
 iwpmd/iwarp_pm_common.c                    |   5 -
 iwpmd/iwarp_pm_server.c                    |   4 +-
 iwpmd/iwpm_netlink.h                       | 214 ------------------
 libibcm/cm.c                               |  78 ++++---
 libibcm/cm_abi.h                           | 351 ++++-------------------------
 libibverbs/marshall.c                      |   4 +-
 libibverbs/marshall.h                      |   6 +-
 libibverbs/sa-kern-abi.h                   |  34 +--
 librdmacm/rdma_cma_abi.h                   |   4 +-
 15 files changed, 416 insertions(+), 738 deletions(-)
 create mode 100644 buildlib/RDMA_LinuxHeaders.cmake
 create mode 100644 buildlib/fixup-include/rdma-rdma_netlink.h
 delete mode 100644 ibacm/src/acm_netlink.h
 delete mode 100644 iwpmd/iwpm_netlink.h

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
