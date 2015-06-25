From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Thu, 25 Jun 2015 16:29:17 -0500
Message-ID: <20150625212917.14869.66238.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The semantics for MR access rights are not consistent across RDMA
protocols.  So rather than have applications try and glean what they need,
have them pass in the intended roles for the MR to be allocated and let
the RDMA core select the appropriate access rights given the roles and
device capabilities.

This patch is just for reviewing the proposed API for allocating a dma mr
in a transport-independent way.  It is uncompiled/untested.  If this looks
ok for folks, then I'll incorporate it into the iSER/iWARP series and make
use of it in isert.

Steve.
---
 drivers/infiniband/core/verbs.c |   34 ++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |   38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac3fb4..8a365d5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1144,6 +1144,40 @@ struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 }
 EXPORT_SYMBOL(ib_get_dma_mr);
 
+struct ib_mr *rdma_get_dma_mr(struct ib_pd *pd, int mr_roles)
+{
+	int access_flags = 0;
+	struct ib_mr *mr;
+	int err;
+
+	if (mr_roles & RDMA_MRR_RECV)
+		access_flags |= IB_ACCESS_LOCAL_WRITE;
+
+	if (mr_roles & RDMA_MRR_WRITE_SINK)
+		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
+
+	if (mr_roles & RDMA_MRR_READ_SINK) {
+		access_flags |= IB_ACCESS_LOCAL_WRITE;
+		if (rdma_protocol_iwarp(pd->device, rdma_start_port(pd->device))
+			access_flags |= IB_ACCESS_REMOTE_WRITE;
+	}
+
+	if (mr_roles & RDMA_MRR_ATOMIC)
+		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_ATOMIC;
+
+	if (mr_roles & RDMA_MRR_MW_BIND)
+		access_flags |= IB_ACCESS_MW_BIND:
+
+	if (mr_roles & RDMA_MRR_ZERO_BASED)
+		access_flags |= IB_ACCESS_ZERO_BASED:
+
+	if (mr_roles & RDMA_MRR_ON_DEMAND)
+		access_flags |= IB_ACCESS_ON_DEMAND:
+
+	return ib_get_dma_mr(pd, access_flags);
+}
+EXPORT_SYMBOL(rdma_get_dma_mr);
+
 struct ib_mr *ib_reg_phys_mr(struct ib_pd *pd,
 			     struct ib_phys_buf *phys_buf_array,
 			     int num_phys_buf,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 986fddb..feee869 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2494,7 +2494,43 @@ static inline int ib_req_ncomp_notif(struct ib_cq *cq, int wc_cnt)
 struct ib_mr *ib_get_dma_mr(struct ib_pd *pd, int mr_access_flags);
 
 /**
- * ib_dma_mapping_error - check a DMA addr for error
+ * rdma_mr_roles - possible roles a MR will be used for
+ *
+ * This allows a transport independent RDMA application to
+ * create MRs that are usable for all the desired roles w/o
+ * having to understand which access rights are needed.
+ */
+enum rdma_mr_roles {
+	RDMA_MRR_RECV			= 1,
+	RDMA_MRR_SEND			= (1<<1),
+	RDMA_MRR_READ_SOURCE		= (1<<2),
+	RDMA_MRR_READ_SINK		= (1<<3),
+	RDMA_MRR_WRITE_SOURCE		= (1<<4),
+	RDMA_MRR_WRITE_SINK		= (1<<5),
+	RDMA_MRR_ATOMIC			= (1<<6),
+	RDMA_MRR_MW_BIND		= (1<<7),
+	RDMA_MRR_ZERO_BASED		= (1<<8),
+	RDMA_MRR_ACCESS_ON_DEMAND	= (1<<9),
+};
+
+/**
+ * rdma_get_dma_mr - Returns a memory region for system memory that is
+ * usable for DMA.
+ * @pd: The protection domain associated with the memory region.
+ * @mr_roles: Specifies the intended roles of the MR
+ *
+ * Use the intended roles from @mr_roles along with the device
+ * capabilities to define the needed access rights, and call
+ * ib_get_dma_mr() to allocate the MR.
+ *
+ * Note that the ib_dma_*() functions defined below must be used
+ * to create/destroy addresses used with the Lkey or Rkey returned
+ * by ib_get_dma_mr().
+ */
+struct ib_mr *rdma_get_dma_mr(struct ib_pd *pd, int mr_roles);
+
+/**
+ * rdma_dma_mapping_error - check a DMA addr for error
  * @dev: The device for which the dma_addr was created
  * @dma_addr: The DMA address to check
  */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
