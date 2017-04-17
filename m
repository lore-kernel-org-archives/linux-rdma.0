From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 0/6] Add support for OPA path records
Date: Mon, 17 Apr 2017 16:56:24 -0400
Message-ID: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Traditional IB path records have 16 bit SLID and DLID
fields that cannot really be used by applications and ULPs working
with 32-bit LIDs. OPA path records add support for 32 bit
SLIDs and DLIDs. Support for OPA path records is specified
by bit 26 of the capmask2 field in the OPA class portinfo.

Note that these patches apply on the earlier patch series with subject
"[PATCH v2 rdma-next 00/18] Enhance ib_ah_attr to specify types"

This patches are organized as follows:
* Patch 1 performs checkpatch fixes that later patches
  touch upon.
* Patch 2 renames ib_sa_path_rec to sa_path_rec
* Patch 3 introduces the 'rec_type' field that identifies
  a path record type. This field replaces the existing
  'gid_type' field.
* Patch 4 splits the existing sa_path_rec into a union of
  sa_path_rec_ib and sa_path_rec_roce structures. Fields that
  are common to both continue to be part of sa_path_rec.
* Patch 5 extends sa_path_rec to have path records of type opa
* Patch 6 enables SA component to query for OPA path records if
  ULPs and other kernel components request for it

Dasaratharaman Chandramouli (6):
  IB/CM: Add braces when using sizeof
  IB/SA: Rename ib_sa_path_rec to sa_path_rec
  IB/SA: Introduce path record specific types
  IB/SA: Split struct sa_path_rec based on IB and ROCE specific fields
  IB/SA: Add OPA path record type
  IB/SA: Add support to query OPA path records

 drivers/infiniband/core/cm.c              | 103 ++++++----
 drivers/infiniband/core/cma.c             |  50 +++--
 drivers/infiniband/core/sa_query.c        | 320 ++++++++++++++++++++++++++----
 drivers/infiniband/core/ucm.c             |   6 +-
 drivers/infiniband/core/ucma.c            |  24 ++-
 drivers/infiniband/core/uverbs_marshall.c |  52 +++--
 drivers/infiniband/ulp/ipoib/ipoib.h      |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c   |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  22 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |  13 +-
 drivers/infiniband/ulp/srp/ib_srp.h       |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c     |   3 +-
 include/rdma/ib_cm.h                      |  14 +-
 include/rdma/ib_mad.h                     |  13 ++
 include/rdma/ib_marshall.h                |   4 +-
 include/rdma/ib_sa.h                      | 287 +++++++++++++++++++++++++--
 include/rdma/opa_addr.h                   |  79 ++++++++
 include/rdma/rdma_cm.h                    |   2 +-
 include/rdma/rdma_cm_ib.h                 |   2 +-
 20 files changed, 849 insertions(+), 161 deletions(-)
 create mode 100644 include/rdma/opa_addr.h

-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
