From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 08/18] IB/core: Rename ib_modify_ah to rdma_modify_ah
Date: Sat, 29 Apr 2017 14:41:20 -0400
Message-ID: <1493491290-31621-9-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename ib_modify_ah to rdma_modify_ah so its in sync with the
rename of the ib address handle attribute

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 4 ++--
 include/rdma/ib_verbs.h         | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b52f4a1..e856547 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -571,13 +571,13 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 }
 EXPORT_SYMBOL(ib_create_ah_from_wc);
 
-int ib_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
+int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 {
 	return ah->device->modify_ah ?
 		ah->device->modify_ah(ah, ah_attr) :
 		-ENOSYS;
 }
-EXPORT_SYMBOL(ib_modify_ah);
+EXPORT_SYMBOL(rdma_modify_ah);
 
 int ib_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d658121..73fb465 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2778,13 +2778,13 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 				   const struct ib_grh *grh, u8 port_num);
 
 /**
- * ib_modify_ah - Modifies the address vector associated with an address
+ * rdma_modify_ah - Modifies the address vector associated with an address
  *   handle.
  * @ah: The address handle to modify.
  * @ah_attr: The new address vector attributes to associate with the
  *   address handle.
  */
-int ib_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
+int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_query_ah - Queries the address vector associated with an address
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
