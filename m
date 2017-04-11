From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 00/18] Enhance ib_ah_attr to specify types
Date: Tue, 11 Apr 2017 13:42:07 -0400
Message-ID: <1491932545-60894-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series introduces a typed address handle attribute
that replaces the exisiting IB specific version. One of the 
drawbacks with the existing attibute was the lack of extensibility
when underlying drivers wanted to leverage specific fields in the
attribute structure. This resulted in some of the fields being used
differently than what it was originally intended for.
This patch addresses that drawback by defining three address handle
types namely 'ib', 'eth' and 'opa'. While these these types share most
of the original fields, the changes provide the infrastucture to 
extend and cleanup the fields based on their types. 

Note that these patches apply on the earlier patch series with subject
"[PATCH v2 0/7] Add support for OPA classport info"

The patches are organized as follows:
* The first 3 patches perform checkpatch fixes that later patches
  touch upon.
* Patch 4 fixes user verbs ABI to read and write grh fields
  of the address handle only when the appropriate flags are set.
* Patch 5 has a minor fix the soft roce driver in properly initializing
  ah_attr fields during query
* Patch 6 renames struct ib_ah_attr to rdma_ah_attr
* Patch 7 to 10 renames verbs APIs ib_create_ah, ib_query_ah, ib_modify_ah
  and ib_destroy_ah
* Patches 11 to 14 renames some of the internal driver functions
  so they are in sync with the structure rename of patch 5.
* Patch 15 introduces set/get accessor functions to access
  individual elements of the structure
* Patch 16 applies the accessor functions introduced in patch 15
* Patch 17 re-defines rdma_ah_attr to now contain types 'ib' and 'eth'.
  Calling code that uses the attribute are now expected to have
  knowledge of the type.
* Patch 18 defines the 'opa' address handle type. Changes to calling
  code that leverages opa address handle types will be introduced in
  forthcoming patches which enable 32 bit LID support in the kernel.

Dasaratharaman Chandramouli (18):
  IB/ocrdma: Add identifier names to function definitions
  IB/IPoIB: Remove 'else' when the 'if' has a return.
  IB/core: Add braces when using sizeof
  IB/core: Check for global flag when using ah_attr
  IB/rxe: Initialize ib_ah_attr during query_ah
  IB/core: Rename struct ib_ah_attr to rdma_ah_attr
  IB/core: Rename ib_create_ah to rdma_create_ah
  IB/core: Rename ib_modify_ah to rdma_modify_ah
  IB/core: Rename ib_query_ah to rdma_query_ah
  IB/core: Rename ib_destroy_ah to rdma_destroy_ah
  IB/mlx4: Rename to_ib_ah_attr to to_rdma_ah_attr
  IB/mlx5: Rename to_ib_ah_attr to to_rdma_ah_attr
  IB/mthca: Rename to_ib_ah_attr to to_rdma_ah_attr
  IB/PVRDMA: Rename ib_ah_attr related functions
  IB/core: Add accessor functions for rdma_ah_attr fields
  IB/core: Use rdma_ah_attr accessor functions
  IB/core: Define 'ib' and 'eth' rdma_ah_attr types
  IB/core: Define 'opa' rdma_ah_attr type

 drivers/infiniband/core/agent.c                 |   4 +-
 drivers/infiniband/core/cm.c                    |  24 +-
 drivers/infiniband/core/cma.c                   |   3 +-
 drivers/infiniband/core/mad.c                   |  25 +-
 drivers/infiniband/core/mad_rmpp.c              |  16 +-
 drivers/infiniband/core/multicast.c             |  27 ++-
 drivers/infiniband/core/sa_query.c              |  56 ++---
 drivers/infiniband/core/user_mad.c              |  44 ++--
 drivers/infiniband/core/uverbs_cmd.c            | 159 ++++++++-----
 drivers/infiniband/core/uverbs_marshall.c       |  29 ++-
 drivers/infiniband/core/uverbs_std_types.c      |   2 +-
 drivers/infiniband/core/verbs.c                 |  79 ++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c        |  96 ++++----
 drivers/infiniband/hw/bnxt_re/ib_verbs.h        |   6 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c     |   2 +-
 drivers/infiniband/hw/cxgb4/provider.c          |   2 +-
 drivers/infiniband/hw/hfi1/driver.c             |   4 +-
 drivers/infiniband/hw/hfi1/mad.c                |   4 +-
 drivers/infiniband/hw/hfi1/qp.c                 |  12 +-
 drivers/infiniband/hw/hfi1/rc.c                 |  24 +-
 drivers/infiniband/hw/hfi1/ruc.c                |  82 ++++---
 drivers/infiniband/hw/hfi1/uc.c                 |   6 +-
 drivers/infiniband/hw/hfi1/ud.c                 |  55 ++---
 drivers/infiniband/hw/hfi1/verbs.c              |  34 +--
 drivers/infiniband/hw/hfi1/verbs.h              |   4 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c         |  62 ++---
 drivers/infiniband/hw/hns/hns_roce_device.h     |   5 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c      | 117 +++++-----
 drivers/infiniband/hw/i40iw/i40iw_verbs.c       |   2 +-
 drivers/infiniband/hw/mlx4/ah.c                 | 134 ++++++-----
 drivers/infiniband/hw/mlx4/mad.c                |  87 ++++---
 drivers/infiniband/hw/mlx4/mcg.c                |   8 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h            |   6 +-
 drivers/infiniband/hw/mlx4/qp.c                 | 110 ++++-----
 drivers/infiniband/hw/mlx5/ah.c                 |  74 +++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h            |   4 +-
 drivers/infiniband/hw/mlx5/qp.c                 | 100 ++++----
 drivers/infiniband/hw/mthca/mthca_av.c          |  69 +++---
 drivers/infiniband/hw/mthca/mthca_dev.h         |   4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c         |  17 +-
 drivers/infiniband/hw/mthca/mthca_provider.c    |   2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c          |  94 ++++----
 drivers/infiniband/hw/nes/nes_verbs.c           |   3 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h           |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |  64 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h        |  10 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c        |  23 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     |  39 ++--
 drivers/infiniband/hw/qedr/qedr.h               |  15 +-
 drivers/infiniband/hw/qedr/qedr_cm.c            |  19 +-
 drivers/infiniband/hw/qedr/qedr_cm.h            |   2 +-
 drivers/infiniband/hw/qedr/verbs.c              |  47 ++--
 drivers/infiniband/hw/qedr/verbs.h              |   2 +-
 drivers/infiniband/hw/qib/qib_mad.c             |   7 +-
 drivers/infiniband/hw/qib/qib_qp.c              |   2 +-
 drivers/infiniband/hw/qib/qib_rc.c              |  21 +-
 drivers/infiniband/hw/qib/qib_ruc.c             |  72 +++---
 drivers/infiniband/hw/qib/qib_uc.c              |   6 +-
 drivers/infiniband/hw/qib/qib_ud.c              |  57 ++---
 drivers/infiniband/hw/qib/qib_verbs.c           |  22 +-
 drivers/infiniband/hw/qib/qib_verbs.h           |   4 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c    |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h    |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h       |   8 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c  |  41 ++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c    |   8 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |  30 +--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h |   2 +-
 drivers/infiniband/sw/rdmavt/ah.c               |  37 +--
 drivers/infiniband/sw/rdmavt/ah.h               |   6 +-
 drivers/infiniband/sw/rdmavt/mad.c              |   2 +-
 drivers/infiniband/sw/rdmavt/qp.c               |  12 +-
 drivers/infiniband/sw/rxe/rxe_av.c              |  32 +--
 drivers/infiniband/sw/rxe/rxe_loc.h             |   8 +-
 drivers/infiniband/sw/rxe/rxe_qp.c              |  12 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c           |  17 +-
 drivers/infiniband/ulp/ipoib/ipoib.h            |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c         |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c  |  61 +++--
 drivers/infiniband/ulp/srpt/ib_srpt.c           |   4 +-
 include/rdma/ib_marshall.h                      |   2 +-
 include/rdma/ib_sa.h                            |   4 +-
 include/rdma/ib_verbs.h                         | 294 ++++++++++++++++++++++--
 include/rdma/rdma_cm.h                          |   2 +-
 include/rdma/rdma_vt.h                          |   8 +-
 include/rdma/rdmavt_qp.h                        |   4 +-
 net/smc/smc_ib.c                                |  11 +-
 88 files changed, 1608 insertions(+), 1126 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
