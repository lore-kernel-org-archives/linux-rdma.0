From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 09/18] IB/core: Rename ib_query_ah to rdma_query_ah
Date: Sat, 29 Apr 2017 14:41:21 -0400
Message-ID: <1493491290-31621-10-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename ib_query_ah to rdma_query_ah so its in sync with the
rename of the ib address handle attribute

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c      | 2 +-
 drivers/infiniband/core/mad_rmpp.c | 2 +-
 drivers/infiniband/core/verbs.c    | 4 ++--
 drivers/infiniband/hw/mlx4/mcg.c   | 2 +-
 include/rdma/ib_verbs.h            | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 6d8c9ee..309c7f3 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1847,7 +1847,7 @@ static inline int rcv_has_same_gid(const struct ib_mad_agent_private *mad_agent_
 		/* both requests, or both responses. GIDs different */
 		return 0;
 
-	if (ib_query_ah(wr->send_buf.ah, &attr))
+	if (rdma_query_ah(wr->send_buf.ah, &attr))
 		/* Assume not equal, to avoid false positives. */
 		return 0;
 
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 3536dcf..0e597c8 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -867,7 +867,7 @@ static int init_newwin(struct ib_mad_send_wr_private *mad_send_wr)
 		    (rmpp_recv->method & IB_MGMT_METHOD_RESP))
 			continue;
 
-		if (ib_query_ah(mad_send_wr->send_buf.ah, &ah_attr))
+		if (rdma_query_ah(mad_send_wr->send_buf.ah, &ah_attr))
 			continue;
 
 		if (rmpp_recv->slid == ah_attr.dlid) {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e856547..35efff6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -579,13 +579,13 @@ int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(rdma_modify_ah);
 
-int ib_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
+int rdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 {
 	return ah->device->query_ah ?
 		ah->device->query_ah(ah, ah_attr) :
 		-ENOSYS;
 }
-EXPORT_SYMBOL(ib_query_ah);
+EXPORT_SYMBOL(rdma_query_ah);
 
 int ib_destroy_ah(struct ib_ah *ah)
 {
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 492eded..eb00904 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -237,7 +237,7 @@ static int send_mad_to_slave(int slave, struct mlx4_ib_demux_ctx *ctx,
 	if (!agent)
 		return -EAGAIN;
 
-	ib_query_ah(dev->sm_ah[ctx->port - 1], &ah_attr);
+	rdma_query_ah(dev->sm_ah[ctx->port - 1], &ah_attr);
 
 	if (ib_find_cached_pkey(&dev->ib_dev, ctx->port, IB_DEFAULT_PKEY_FULL, &wc.pkey_index))
 		return -EINVAL;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 73fb465..16fd940 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2787,13 +2787,13 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 int rdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 
 /**
- * ib_query_ah - Queries the address vector associated with an address
+ * rdma_query_ah - Queries the address vector associated with an address
  *   handle.
  * @ah: The address handle to query.
  * @ah_attr: The address vector attributes associated with the address
  *   handle.
  */
-int ib_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
+int rdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_destroy_ah - Destroys an address handle.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
