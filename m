From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/6]  IB/Core: Adding support for RoCE V2 specification
Date: Thu, 25 Dec 2014 06:28:54 +0530
Message-ID: <30058c6e-f0fe-42ea-bac6-2fa8f4a92cdd@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The overarching goal behind this patch is to keep RDMA-CM as the central entity
that decides the protocol (ROCEV2 /ROCEV1) and hides all the address resolution
details from applications.
This is just a continuation of the existing RDMA-CM design philosophy for IP
based GIDs that lets applications operate over any form of RDMA Service in a
completely transparent way without any changes to the applications themselves.

Having said that, this patch series will not only work with applications using
RDMA-CM , but also with *non* RDMA-CM applications as well due to changes in
modify_qp and create_ah some of which were already present for IP-Based GIDs.

As per SPEC, a GID Index is also now associated with a Type(RoCEV1/RoCEV2)
with 2 GID Entries populated in the GID Table for each type.

The sgid_index is chosen in the RDMA-CM based on hint from the IP Stack
along with other path components like hop_limit.

As of this patch, default policy is to choose RoCEV1 for end-nodes that are 
connected locally on the same subnet.

While this can be considered as the 1st stage to get RoCEV2 working across 
all applications, what this misses is  an 'override' option to let admins
and application users to select V2/V1 on a node-wide or on a application basis
That can be the logical next stage of patch series. Moni Shua had an idea
of how to implement this. 
Following that as Moni Shua suggested, there could be the option of having
GID table population all done in one place

Devesh Sharma (3):
  RDMA/ocrdma: changes to support RoCE-v2 in RC path
  RDMA/ocrdma: changes to support user AH creation
  RDMA/ocrdma: introducing a function to check RoCE-v2 support

Somnath kotur (3):
  IB/Core: Changes to the IB Core infrastructure for RoCEv2 support
  RDMA/ocrdma: populate GID table as per RoCE-v2 spec
  RDMA/ocrdma: changes to support RoCE-v2 in UD path

 drivers/infiniband/core/addr.c              |    8 ++
 drivers/infiniband/core/cache.c             |   14 ++-
 drivers/infiniband/core/cm.c                |   15 +++-
 drivers/infiniband/core/cma.c               |   56 +++++++++++--
 drivers/infiniband/core/device.c            |   23 ++++++
 drivers/infiniband/core/multicast.c         |    3 +-
 drivers/infiniband/core/sa_query.c          |    3 +-
 drivers/infiniband/core/verbs.c             |   68 ++++++++++++++--
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   10 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   93 ++++++++++++++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   38 +++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  113 +++++++++++++++++++--------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   17 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   44 +++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |    2 +
 include/rdma/ib_addr.h                      |    1 +
 include/rdma/ib_cache.h                     |    2 +
 include/rdma/ib_sa.h                        |    1 +
 include/rdma/ib_verbs.h                     |   85 ++++++++++++++++++++-
 20 files changed, 511 insertions(+), 89 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
