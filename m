From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/7] Add support for OPA classport info
Date: Mon, 20 Mar 2017 19:38:03 -0400
Message-ID: <1490053090-32840-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series moves the classport info query initiation and update
from callers such as ipoib to the ib_sa module itself. The classport
info cache is updated whenever ib_sa receives an appropriate state
change event.

Since classport info is only used to check if sendonly full member support
is enabled by the SM, we expose a function ib_sa_sendonly_fullmem_support
that can be called to check if the support is enabled. 

Additionally, we introduce support for opa classport info. These are
defined specifically for OPA devices and expose additional features in the
capability mask bits along with longer LID sizes in some of the other
fields.

Patch 1 to 3 fix checkpatch issues (1 issue type per patch) on two
functions that patch 4 then moves around. Patch 5 makes changes
to implicitly query and cache classport info. Patch 6 adds 
verbs capability API for core layers to query and find out if they
are running on an OPA device. Finally, patch 7 adds OPA classport info
query support.

Changes from v0:
---------------
1. Initiate Classport Info refresh also on a LID change and SM change
events.

2. Make proper use of the 'flags' field in struct ib_sa_query that carries
the flag IB_SA_QUERY_OPA. This makes changes to static functions such as
alloc_mad and init_mad unnecessary.

3. Remove the unwanted rename of CLASSPORTINFO_REC_FIELD to
IB_CLASSPORTINFO_REC_FIELD.

4. Fix the subject prefix. Remove 'rdma-core' from the subject.

Dasaratharaman Chandramouli (7):
  IB/SA: Fix lines longer than 80 columns
  IB/SA: Add braces when using sizeof
  IB/SA: Remove unwanted braces
  IB/SA: Move functions update_sm_ah() and ib_sa_event()
  IB/SA: Modify SA to implicitly cache Class Port info
  IB/core: Add rdma_cap_opa_ah to expose opa address handles
  IB/SA: Add support to query opa classport info.

 drivers/infiniband/core/cma.c                  |  76 +---
 drivers/infiniband/core/sa_query.c             | 521 +++++++++++++++++--------
 drivers/infiniband/hw/hfi1/mad.c               |  25 --
 drivers/infiniband/ulp/ipoib/ipoib.h           |   1 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  71 ----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   9 +-
 include/rdma/ib_mad.h                          |  25 ++
 include/rdma/ib_sa.h                           |  13 +-
 include/rdma/ib_verbs.h                        |  16 +
 9 files changed, 418 insertions(+), 339 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
