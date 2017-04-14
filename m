From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 rdma-next 01/18] IB/ocrdma: Add identifier names to function definitions
Date: Fri, 14 Apr 2017 19:28:41 -0400
Message-ID: <1492212538-32459-2-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1492212538-32459-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492212538-32459-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Address a checkpatch issue on missing identifier names
on function definitions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 0704a24..5370eb7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -51,11 +51,11 @@ enum {
 	OCRDMA_AH_L3_TYPE_SHIFT		= 0x1D /* 29 bits */
 };
 
-struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *,
-			       struct ib_udata *);
-int ocrdma_destroy_ah(struct ib_ah *);
-int ocrdma_query_ah(struct ib_ah *, struct ib_ah_attr *);
-int ocrdma_modify_ah(struct ib_ah *, struct ib_ah_attr *);
+struct ib_ah *ocrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+			       struct ib_udata *udata);
+int ocrdma_destroy_ah(struct ib_ah *ah);
+int ocrdma_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
+int ocrdma_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
 
 int ocrdma_process_mad(struct ib_device *,
 		       int process_mad_flags,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
