From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 0/2] Indirect Fast Memory registration support
Date: Tue,  7 Oct 2014 17:47:59 +0300
Message-ID: <1412693281-6161-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bvanassche-HInyCGIudOg@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set introduces support for registering a scattered
memory area in an indirect manner.

Current supported fast registration support has a known limitation
where the memory must be page aligned, meaning memory scatters must
be in chunks of page size except the first which may be in some offset
from the start of a page and the last which may end before the page
boundary.

This can make life hard for ULPs which may serve a scattered list without
the above limitations. Two immediate examples are iSER and SRP that have
some extra logic or work-arounds to handle an arbitrary scatter list of
buffers (which is supported in the entire stack above them).

The proposed API attempts to follow the well-known fast registration scheme
while allowing the ULP to pass an sg vector rather than a page list (u64 vector).
I expect ULPs to make use of the global DMA key to populate the lkey of the
sg vector. for example for a scatter list sg of 3 elements the indirect ib_sge
vector will look like:
ib_sge[0]: {dma_key, sg[0]->dma_addr, sg[0]->length}
ib_sge[1]: {dma_key, sg[1]->dma_addr, sg[1]->length}
ib_sge[2]: {dma_key, sg[2]->dma_addr, sg[2]->length}

Following this patch set I'll send out a usage for this feature in iSER.
In the meantime, I have a working example of krping utility practicing indirect
registration feature at: git://flatbed.openfabrics.org/~sgrimberg/krping.git
(branch: indir_registration)

Sagi Grimberg (2):
  IB/core: Introduce Fast Indirect Memory Registration verbs API
  IB/mlx5: Implement Fast Indirect Memory Registration Feature

 drivers/infiniband/core/verbs.c      |   29 +++++++++
 drivers/infiniband/hw/mlx5/cq.c      |    2 +
 drivers/infiniband/hw/mlx5/main.c    |    4 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   20 +++++++
 drivers/infiniband/hw/mlx5/mr.c      |   70 ++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/qp.c      |  104 ++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h              |   55 +++++++++++++++++-
 7 files changed, 280 insertions(+), 4 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
