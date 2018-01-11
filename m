From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 00/17] Use the kernel ABI header instead of kern-abi.h
Date: Thu, 11 Jan 2018 15:13:23 -0700
Message-ID: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This substantially eliminates most of kern-abi.h. All that remains are the
structs that have been modified by appending the header.

Much of the hard work was done via an automatic script.

I've been threatening to do this for some time, but forthcoming work on the
kabi has now made it timely.

This is a github pull request:

https://github.com/linux-rdma/rdma-core/pull/282

Jason Gunthorpe (17):
  Update rdma/ib_user_verbs.h
  verbs: Include rdma/ib_user_verbs.h in kern-abi.h
  verbs: Delete extended command definitions from kern-abi.h
  verbs: Remove unused structs
  verbs: Remove kernel ABI v2 compat cruft
  verbs: Add missing endian annotations to kern-abi.h
  verbs: Use kernel uapi names for identical structs
  verbs: Use kernel uapi header for ibv_cq_moderation_caps_resp
  verbs: Use kernel uapi header for ibv_query_device_resp_ex
  verbs: Use kernel uapi header for ibv_kern_wc and ibv_poll_cq_resp
  verbs: Use kernel uapi header for ibv_create_ah_resp
  verbs: Use kernel uapi header for ibv_kern_send_wr
  verbs: Use kernel uapi header for
    IBV_CREATE_QP_EX_KERNEL_MASK_IND_TABLE
  verbs: Use kernel uapi header for flow steering types
  verbs: Use kernel uapi header for ibv_modify_qp_common
  verb: Use kernel uapi header in struct ex_hdr
  verbs: Tidy up the remaining structs in kern-abi.h

 buildlib/RDMA_LinuxHeaders.cmake            |    2 +-
 buildlib/fixup-include/rdma-ib_user_verbs.h | 1176 +++++++++++++++++++++++++++
 libibcm/cm.c                                |    2 +-
 libibverbs/cmd.c                            |  157 ++--
 libibverbs/device.c                         |    2 +-
 libibverbs/driver.h                         |   40 +-
 libibverbs/ibverbs.h                        |   44 +-
 libibverbs/kern-abi.h                       |  971 ++--------------------
 libibverbs/marshall.c                       |    4 +-
 libibverbs/marshall.h                       |    4 +-
 libibverbs/verbs.c                          |   37 +-
 librdmacm/cma.c                             |    2 +-
 librdmacm/rdma_cma_abi.h                    |    2 +-
 providers/bnxt_re/bnxt_re-abi.h             |   10 +-
 providers/bnxt_re/verbs.c                   |    2 +-
 providers/cxgb3/iwch-abi.h                  |   12 +-
 providers/cxgb4/cxgb4-abi.h                 |   10 +-
 providers/cxgb4/verbs.c                     |    4 +-
 providers/hfi1verbs/hfi-abi.h               |   10 +-
 providers/hfi1verbs/hfiverbs.c              |    2 +-
 providers/hfi1verbs/verbs.c                 |   14 +-
 providers/hns/hns_roce_u_abi.h              |    6 +-
 providers/hns/hns_roce_u_verbs.c            |    6 +-
 providers/i40iw/i40iw-abi.h                 |    8 +-
 providers/i40iw/i40iw_uverbs.c              |    6 +-
 providers/ipathverbs/ipath-abi.h            |   10 +-
 providers/ipathverbs/ipathverbs.c           |    2 +-
 providers/ipathverbs/verbs.c                |   14 +-
 providers/mlx4/mlx4-abi.h                   |   16 +-
 providers/mlx4/verbs.c                      |   18 +-
 providers/mlx5/mlx5-abi.h                   |   22 +-
 providers/mlx5/verbs.c                      |   10 +-
 providers/mthca/mthca-abi.h                 |    8 +-
 providers/mthca/verbs.c                     |    6 +-
 providers/nes/nes-abi.h                     |    8 +-
 providers/nes/nes_uverbs.c                  |    6 +-
 providers/ocrdma/ocrdma_abi.h               |   12 +-
 providers/ocrdma/ocrdma_verbs.c             |    4 +-
 providers/qedr/qelr_abi.h                   |   10 +-
 providers/rxe/rxe-abi.h                     |   10 +-
 providers/rxe/rxe.c                         |   16 +-
 providers/vmw_pvrdma/pvrdma-abi-fix.h       |    8 +-
 providers/vmw_pvrdma/qp.c                   |    4 +-
 providers/vmw_pvrdma/verbs.c                |    2 +-
 44 files changed, 1504 insertions(+), 1215 deletions(-)
 create mode 100644 buildlib/fixup-include/rdma-ib_user_verbs.h

-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
